import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// SMS verification uses a separate Auth instance so an intermediate phone UID
/// cannot replace the buyer's existing UID or redirect the main application.
class BuyerPhoneSignIn {
  static FirebaseAuth? _auth;
  static FirebaseApp? _app;
  static String? _verificationId;
  static ConfirmationResult? _webConfirmation;
  static String phone = '';

  static Future<void> _initialize() async {
    _app ??= await Firebase.initializeApp(
      name: 'buyer-phone-verification',
      options: Firebase.app().options,
    );
    _auth ??= FirebaseAuth.instanceFor(app: _app!);
  }

  static String normalize(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('8'))
      digits = '7${digits.substring(1)}';
    if (!RegExp(r'^7\d{10}$').hasMatch(digits)) {
      throw const FormatException('Введите номер в формате +7 701 123 45 67');
    }
    return '+$digits';
  }

  static Future<void> sendCode(String value) async {
    phone = normalize(value);
    await _initialize();
    await _auth!.signOut();
    _verificationId = null;
    _webConfirmation = null;
    if (kIsWeb) {
      _webConfirmation = await _auth!.signInWithPhoneNumber(phone);
      return;
    }
    final sent = Completer<void>();
    await _auth!.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      // The confirmation screen handles one explicit SMS proof consistently.
      verificationCompleted: (_) {},
      verificationFailed: (error) {
        if (!sent.isCompleted) sent.completeError(error);
      },
      codeSent: (id, _) {
        _verificationId = id;
        if (!sent.isCompleted) sent.complete();
      },
      codeAutoRetrievalTimeout: (id) {
        _verificationId ??= id;
      },
    );
    // A person may need several minutes to finish Google's iOS reCAPTCHA.
    await sent.future.timeout(defaultTargetPlatform == TargetPlatform.iOS
        ? const Duration(minutes: 10)
        : const Duration(seconds: 90));
  }

  static Future<String> verify(String code) async {
    if (!RegExp(r'^\d{6}$').hasMatch(code.trim())) {
      throw const FormatException('Введите шесть цифр из SMS');
    }
    if (_auth == null ||
        (kIsWeb ? _webConfirmation == null : _verificationId == null)) {
      throw StateError('Запросите новый код на экране входа');
    }
    try {
      if (kIsWeb) {
        await _webConfirmation!.confirm(code.trim());
      } else {
        await _auth!.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: code.trim(),
        ));
      }
      final result =
          await FirebaseFunctions.instanceFor(app: _app!, region: 'us-central1')
              .httpsCallable('finalizeBuyerPhoneSignIn')
              .call();
      final token = result.data['token'];
      if (token is! String || token.isEmpty)
        throw StateError('Не удалось завершить вход');
      _verificationId = null;
      _webConfirmation = null;
      return token;
    } finally {
      await _auth!.signOut();
    }
  }
}

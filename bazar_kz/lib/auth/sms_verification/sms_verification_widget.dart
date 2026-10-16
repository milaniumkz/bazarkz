import '/auth/firebase_auth/auth_util.dart';
import '/auth/firebase_auth/phone_sign_in.dart';
import '/components/legal_links.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmsVerificationWidget extends StatefulWidget {
  const SmsVerificationWidget({super.key});
  static String routeName = 'smsVerification';
  static String routePath = '/smsVerification';
  @override
  State<SmsVerificationWidget> createState() => _SmsVerificationWidgetState();
}

class _SmsVerificationWidgetState extends State<SmsVerificationWidget> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final token = await BuyerPhoneSignIn.verify(_code.text);
      if (!mounted) return;
      GoRouter.of(context).prepareAuthEvent();
      final user = await authManager.signInWithJwtToken(context, token);
      if (user == null || !mounted) return;
      context.goNamedAuth(
          currentUserDocument?.displayName.isNotEmpty == true
              ? HomeWidget.routeName
              : CreateProfileWidget.routeName,
          mounted);
    } on FirebaseAuthException catch (_) {
      if (mounted)
        setState(() => _error = 'Код неверен или истёк. Запросите новый код.');
    } on FirebaseFunctionsException catch (e) {
      if (mounted)
        setState(() => _error = e.message ?? 'Не удалось завершить вход.');
    } on FormatException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted)
        setState(() => _error =
            'Не удалось войти. Вернитесь назад и запросите новый код.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Подтверждение телефона')),
        bottomNavigationBar: const LegalLinks(),
        body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                          'Введите код из SMS, отправленного на ${BuyerPhoneSignIn.phone}'),
                      const SizedBox(height: 16),
                      TextField(
                          controller: _code,
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          enabled: !_busy,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          decoration: const InputDecoration(
                              labelText: 'Код из SMS',
                              border: OutlineInputBorder()),
                          onSubmitted: (_) => _verify()),
                      const SizedBox(height: 16),
                      if (_error != null)
                        Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      FilledButton(
                          onPressed: _busy ? null : _verify,
                          child: Text(_busy ? 'Проверка…' : 'Войти')),
                      TextButton(
                          onPressed: _busy
                              ? null
                              : () => context.goNamed(LoginWidget.routeName),
                          child: const Text(
                              'Изменить номер или запросить новый код')),
                    ]),
              )),
        ),
      );
}

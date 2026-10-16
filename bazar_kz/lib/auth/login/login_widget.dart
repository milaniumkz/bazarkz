import '/auth/firebase_auth/phone_sign_in.dart';
import '/components/legal_links.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  static String routeName = 'login';
  static String routePath = '/login';
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _phone = TextEditingController(text: '+7');
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await BuyerPhoneSignIn.sendCode(_phone.text);
      FFAppState().phone = BuyerPhoneSignIn.phone;
      if (mounted) context.pushNamed(SmsVerificationWidget.routeName);
    } on FirebaseAuthException catch (e) {
      if (mounted)
        setState(() => _error = switch (e.code) {
              'invalid-phone-number' => 'Проверьте номер телефона.',
              'too-many-requests' => 'Слишком много попыток. Попробуйте позже.',
              _ =>
                'Не удалось отправить код. Проверьте соединение или обратитесь в поддержку.',
            });
    } on FormatException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted)
        setState(
            () => _error = 'Не удалось отправить SMS. Попробуйте ещё раз.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Вход в BazarKz')),
        bottomNavigationBar: const LegalLinks(),
        body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          enabled: !_busy,
                          decoration: const InputDecoration(
                              labelText: 'Ваш номер телефона',
                              hintText: '+7 701 123 45 67',
                              border: OutlineInputBorder()),
                          onSubmitted: (_) => _send()),
                      const SizedBox(height: 16),
                      const Text(
                          'Google отправит SMS с кодом для входа. Номер передаётся Google для проверки и защиты от злоупотреблений.'),
                      const SizedBox(height: 16),
                      if (_error != null)
                        Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      FilledButton(
                          onPressed: _busy ? null : _send,
                          child: Text(_busy ? 'Отправка…' : 'Получить код')),
                    ]),
              )),
        ),
      );
}

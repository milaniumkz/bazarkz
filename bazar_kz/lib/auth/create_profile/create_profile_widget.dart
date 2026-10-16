import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/legal_links.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class CreateProfileWidget extends StatefulWidget {
  const CreateProfileWidget({super.key});
  static String routeName = 'CreateProfile';
  static String routePath = '/createProfile';
  @override
  State<CreateProfileWidget> createState() => _CreateProfileWidgetState();
}

class _CreateProfileWidgetState extends State<CreateProfileWidget> {
  final _name = TextEditingController();
  String? _city;
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    if (currentUserReference == null) {
      context.goNamed(LoginWidget.routeName);
      return;
    }
    if (_name.text.trim().isEmpty || _city == null) {
      setState(() => _error = 'Введите имя и выберите город.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await currentUserReference!.update(
          createUsersRecordData(displayName: _name.text.trim(), city: _city));
      FFAppState().city = _city!;
      if (mounted) context.goNamedAuth(HomeWidget.routeName, mounted);
    } catch (_) {
      if (mounted)
        setState(
            () => _error = 'Не удалось сохранить профиль. Попробуйте ещё раз.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Создайте профиль')),
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
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          maxLength: 100,
                          decoration: const InputDecoration(
                              labelText: 'Ваше имя',
                              border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      StreamBuilder<List<CityRecord>>(
                          stream: queryCityRecord(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return const Text(
                                  'Не удалось загрузить города. Проверьте соединение.');
                            if (!snapshot.hasData)
                              return const Center(
                                  child: CircularProgressIndicator());
                            final cities = snapshot.data!
                                .map((e) => e.title)
                                .where((e) => e.isNotEmpty)
                                .toSet()
                                .toList()
                              ..sort();
                            return DropdownButtonFormField<String>(
                                initialValue:
                                    cities.contains(_city) ? _city : null,
                                decoration: const InputDecoration(
                                    labelText: 'Город',
                                    border: OutlineInputBorder()),
                                items: cities
                                    .map((city) => DropdownMenuItem(
                                        value: city, child: Text(city)))
                                    .toList(),
                                onChanged: _busy
                                    ? null
                                    : (value) => setState(() => _city = value));
                          }),
                      const SizedBox(height: 16),
                      if (_error != null)
                        Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      FilledButton(
                          onPressed: _busy ? null : _save,
                          child: Text(_busy ? 'Сохранение…' : 'Сохранить')),
                    ]),
              )),
        ),
      );
}

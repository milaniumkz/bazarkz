import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

Future<bool> deleteAccount(BuildContext context,
    {bool confirmed = false}) async {
  if (!confirmed) {
    confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
                  title: const Text('Удалить аккаунт?'),
                  content: const Text(
                      'Аккаунт и связанные персональные данные будут удалены. Опубликованные магазины и товары продавца также будут удалены. Исполненные заказы сохранятся без контактных данных.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Отмена')),
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Удалить')),
                  ],
                )) ??
        false;
  }
  if (!confirmed || !context.mounted) return false;
  try {
    await FirebaseFunctions.instance.httpsCallable('deleteOwnAccount').call();
    await FirebaseAuth.instance.signOut();
    if (context.mounted) GoRouter.of(context).go('/login');
    return true;
  } on FirebaseFunctionsException catch (error) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message ?? 'Не удалось удалить аккаунт.')));
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Не удалось удалить аккаунт. Проверьте соединение и повторите попытку.')));
  }
  return false;
}

/// Public support and data controls remain available before sign-in.
class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              if (FirebaseAuth.instance.currentUser != null)
                TextButton(
                    onPressed: () => deleteAccount(context),
                    child: const Text('Удалить аккаунт')),
              for (final link in const {
                'Конфиденциальность': 'privacy',
                'Поддержка': 'support',
                'Удаление данных': 'delete-account',
              }.entries)
                TextButton(
                  onPressed: () async {
                    final opened = await launchUrl(
                      Uri.parse(
                          'https://bazarkz-policies.web.app/#${link.value}'),
                      mode: LaunchMode.externalApplication,
                    );
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Напишите в поддержку: milaniumkz@yandex.kz'),
                      ));
                    }
                  },
                  child: Text(link.key),
                ),
            ],
          ),
        ),
      );
}

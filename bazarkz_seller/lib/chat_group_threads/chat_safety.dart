import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

Future<void> showChatSafety(BuildContext context, DocumentReference user,
    DocumentReference chat) async {
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (sheet) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Пожаловаться на участника'),
            onTap: () => Navigator.pop(sheet, 'report')),
        ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Заблокировать и выйти из чата'),
            onTap: () => Navigator.pop(sheet, 'block')),
      ]),
    ),
  );
  if (!context.mounted || action == null) return;
  try {
    if (action == 'report') {
      var reason = '';
      final submitted = await showDialog<bool>(
          context: context,
          builder: (dialog) => AlertDialog(
                title: const Text('Жалоба на участника'),
                content: TextField(
                    onChanged: (value) => reason = value,
                    maxLength: 1000,
                    maxLines: 4,
                    decoration:
                        const InputDecoration(labelText: 'Что произошло?')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialog, false),
                      child: const Text('Отмена')),
                  TextButton(
                      onPressed: () {
                        if (reason.trim().isNotEmpty)
                          Navigator.pop(dialog, true);
                      },
                      child: const Text('Отправить'))
                ],
              ));
      final text = reason.trim();
      if (submitted != true) return;
      await FirebaseFirestore.instance.collection('contentReports').add({
        'sender': currentUserReference,
        'target': user,
        'chat': chat,
        'reason': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Жалоба сохранена для проверки. Поддержка: milaniumkz@yandex.kz')));
    } else {
      final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialog) => AlertDialog(
                  title: const Text('Заблокировать участника?'),
                  content: const Text(
                      'Вы выйдете из этого чата. Этот участник не сможет добавить вас в новый чат.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialog, false),
                        child: const Text('Отмена')),
                    TextButton(
                        onPressed: () => Navigator.pop(dialog, true),
                        child: const Text('Заблокировать'))
                  ]));
      if (confirmed != true) return;
      final batch = FirebaseFirestore.instance.batch();
      batch.update(currentUserReference!, {
        'blocked_users': FieldValue.arrayUnion([user])
      });
      batch.update(chat, {
        'users': FieldValue.arrayRemove([currentUserReference])
      });
      await batch.commit();
      if (context.mounted) context.goNamed('chat_2_main');
    }
  } catch (_) {
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Не удалось выполнить действие. Попробуйте ещё раз.')));
  }
}

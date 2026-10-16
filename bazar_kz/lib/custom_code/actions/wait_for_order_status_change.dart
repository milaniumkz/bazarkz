// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> waitForOrderStatusChange(String orderId) async {
  final docRef = FirebaseFirestore.instance.collection('order').doc(orderId);

  final completer = Completer<bool>();

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> subscription;

  subscription = docRef.snapshots().listen((snapshot) async {
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final status = data['status'] ?? 0;

      if (status == 1) {
        await subscription.cancel();
        completer.complete(true);
      }
    }
  });

  return completer.future;
}

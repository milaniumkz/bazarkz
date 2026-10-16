import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

int? islength(String? str) {
  return str!.length;
}

DocumentReference? qrId(String? str) {
  String ids = str!.split(",")[1];

  final db = FirebaseFirestore.instance;
  final docRef = db.collection("qr").doc(ids);
  return docRef;
}

List<PredZakazStruct>? convertCartToPredZakaz(List<CartRecord>? cartList) {
  if (cartList == null) return [];

  return cartList.map((cartItem) {
    return PredZakazStruct(
      idTovar: cartItem.idTovar, // <-- Убедись в правильности имени
      idUser: cartItem.idUsers, // <-- ИСПРАВЬ если поле называется иначе
      cols: cartItem.cols,
    );
  }).toList();
}

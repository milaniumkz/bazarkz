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
import '/auth/firebase_auth/auth_util.dart';

int? islength(String? str) {
  return str!.length;
}

DateTime? parseDateString(String? dateString) {
  List<String> parts = dateString!.split('.');

  if (parts.length != 3) {
    // Неверный формат строки
    return null;
  }

  int? day = int.tryParse(parts[0]);
  int? month = int.tryParse(parts[1]);
  int? year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) {
    // Неверные числовые значения
    return null;
  }

  try {
    // Создаем и возвращаем объект DateTime
    return DateTime(year, month, day);
  } catch (e) {
    // Обработка ошибок, например, если дата невалидна
    return null;
  }
}

void main() {
  // Пример использования
  String dateString = "14.12.2023";
  DateTime? result = parseDateString(dateString);

  if (result != null) {
    print("Дата: ${DateFormat('yyyy-MM-dd').format(result)}");
  } else {
    print("Неверный формат даты");
  }
}

String? typeQr(String? str) {
  return str!.split(",")[0];
}

DocumentReference? qrId(String? str) {
  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('shopSkidki');

  // Создаем документ с уникальным идентификатором пользователя
  DocumentReference<Map<String, dynamic>> userReference =
      usersCollection.doc(str);

  // Возвращаем reference на пользователя
  return userReference;
}

DocumentReference? qrIdPartner(String? str) {
  String id = str!.split(",")[1];
  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Создаем документ с уникальным идентификатором пользователя
  DocumentReference<Map<String, dynamic>> userReference =
      usersCollection.doc(id);

  // Возвращаем reference на пользователя
  return userReference;
}

DocumentReference? refPartner(String? str) {
  CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Создаем документ с уникальным идентификатором пользователя
  DocumentReference<Map<String, dynamic>> userReference =
      usersCollection.doc(str);

  // Возвращаем reference на пользователя
  return userReference;
}

DateTime? newDate(
  DateTime? initialDate,
  int? months,
) {
  DateTime currentDate = DateTime.now();

  if (initialDate == null) {
    // Если дата не установлена, используем текущую дату
    initialDate = currentDate;
  }

  // Создаем новый экземпляр DateTime, увеличивая исходную дату на указанный срок
  DateTime newDate = initialDate.add(Duration(days: months!));
  return newDate;
}

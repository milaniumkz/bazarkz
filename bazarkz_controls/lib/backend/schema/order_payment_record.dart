import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderPaymentRecord extends FirestoreRecord {
  OrderPaymentRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUser" field.
  DocumentReference? _idUser;
  DocumentReference? get idUser => _idUser;
  bool hasIdUser() => _idUser != null;

  // "summa" field.
  double? _summa;
  double get summa => _summa ?? 0.0;
  bool hasSumma() => _summa != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  void _initializeFields() {
    _idUser = snapshotData['idUser'] as DocumentReference?;
    _summa = castToType<double>(snapshotData['summa']);
    _date = snapshotData['date'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orderPayment');

  static Stream<OrderPaymentRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrderPaymentRecord.fromSnapshot(s));

  static Future<OrderPaymentRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrderPaymentRecord.fromSnapshot(s));

  static OrderPaymentRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrderPaymentRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrderPaymentRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrderPaymentRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrderPaymentRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrderPaymentRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrderPaymentRecordData({
  DocumentReference? idUser,
  double? summa,
  DateTime? date,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUser': idUser,
      'summa': summa,
      'date': date,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrderPaymentRecordDocumentEquality
    implements Equality<OrderPaymentRecord> {
  const OrderPaymentRecordDocumentEquality();

  @override
  bool equals(OrderPaymentRecord? e1, OrderPaymentRecord? e2) {
    return e1?.idUser == e2?.idUser &&
        e1?.summa == e2?.summa &&
        e1?.date == e2?.date;
  }

  @override
  int hash(OrderPaymentRecord? e) =>
      const ListEquality().hash([e?.idUser, e?.summa, e?.date]);

  @override
  bool isValidKey(Object? o) => o is OrderPaymentRecord;
}

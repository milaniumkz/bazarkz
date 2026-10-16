import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderRecord extends FirestoreRecord {
  OrderRecord._(
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

  // "Date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "City" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "adres" field.
  String? _adres;
  String get adres => _adres ?? '';
  bool hasAdres() => _adres != null;

  // "status" field.
  int? _status;
  int get status => _status ?? 0;
  bool hasStatus() => _status != null;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  bool hasId() => _id != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "tel" field.
  String? _tel;
  String get tel => _tel ?? '';
  bool hasTel() => _tel != null;

  // "carts" field.
  List<PredZakazStruct>? _carts;
  List<PredZakazStruct> get carts => _carts ?? const [];
  bool hasCarts() => _carts != null;

  void _initializeFields() {
    _idUser = snapshotData['idUser'] as DocumentReference?;
    _summa = castToType<double>(snapshotData['summa']);
    _date = snapshotData['Date'] as DateTime?;
    _city = snapshotData['City'] as String?;
    _adres = snapshotData['adres'] as String?;
    _status = castToType<int>(snapshotData['status']);
    _id = castToType<int>(snapshotData['id']);
    _type = snapshotData['type'] as String?;
    _tel = snapshotData['tel'] as String?;
    _carts = getStructList(
      snapshotData['carts'],
      PredZakazStruct.fromMap,
    );
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('order');

  static Stream<OrderRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrderRecord.fromSnapshot(s));

  static Future<OrderRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrderRecord.fromSnapshot(s));

  static OrderRecord fromSnapshot(DocumentSnapshot snapshot) => OrderRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrderRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrderRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrderRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrderRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrderRecordData({
  DocumentReference? idUser,
  double? summa,
  DateTime? date,
  String? city,
  String? adres,
  int? status,
  int? id,
  String? type,
  String? tel,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUser': idUser,
      'summa': summa,
      'Date': date,
      'City': city,
      'adres': adres,
      'status': status,
      'id': id,
      'type': type,
      'tel': tel,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrderRecordDocumentEquality implements Equality<OrderRecord> {
  const OrderRecordDocumentEquality();

  @override
  bool equals(OrderRecord? e1, OrderRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idUser == e2?.idUser &&
        e1?.summa == e2?.summa &&
        e1?.date == e2?.date &&
        e1?.city == e2?.city &&
        e1?.adres == e2?.adres &&
        e1?.status == e2?.status &&
        e1?.id == e2?.id &&
        e1?.type == e2?.type &&
        e1?.tel == e2?.tel &&
        listEquality.equals(e1?.carts, e2?.carts);
  }

  @override
  int hash(OrderRecord? e) => const ListEquality().hash([
        e?.idUser,
        e?.summa,
        e?.date,
        e?.city,
        e?.adres,
        e?.status,
        e?.id,
        e?.type,
        e?.tel,
        e?.carts
      ]);

  @override
  bool isValidKey(Object? o) => o is OrderRecord;
}

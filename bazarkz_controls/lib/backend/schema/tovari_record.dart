import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TovariRecord extends FirestoreRecord {
  TovariRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idSale" field.
  DocumentReference? _idSale;
  DocumentReference? get idSale => _idSale;
  bool hasIdSale() => _idSale != null;

  // "idPartner" field.
  DocumentReference? _idPartner;
  DocumentReference? get idPartner => _idPartner;
  bool hasIdPartner() => _idPartner != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "priceSale" field.
  double? _priceSale;
  double get priceSale => _priceSale ?? 0.0;
  bool hasPriceSale() => _priceSale != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "tegi" field.
  List<String>? _tegi;
  List<String> get tegi => _tegi ?? const [];
  bool hasTegi() => _tegi != null;

  // "image" field.
  List<String>? _image;
  List<String> get image => _image ?? const [];
  bool hasImage() => _image != null;

  void _initializeFields() {
    _idSale = snapshotData['idSale'] as DocumentReference?;
    _idPartner = snapshotData['idPartner'] as DocumentReference?;
    _price = castToType<double>(snapshotData['price']);
    _priceSale = castToType<double>(snapshotData['priceSale']);
    _title = snapshotData['title'] as String?;
    _tegi = getDataList(snapshotData['tegi']);
    _image = getDataList(snapshotData['image']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tovari');

  static Stream<TovariRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TovariRecord.fromSnapshot(s));

  static Future<TovariRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TovariRecord.fromSnapshot(s));

  static TovariRecord fromSnapshot(DocumentSnapshot snapshot) => TovariRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TovariRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TovariRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TovariRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TovariRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTovariRecordData({
  DocumentReference? idSale,
  DocumentReference? idPartner,
  double? price,
  double? priceSale,
  String? title,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idSale': idSale,
      'idPartner': idPartner,
      'price': price,
      'priceSale': priceSale,
      'title': title,
    }.withoutNulls,
  );

  return firestoreData;
}

class TovariRecordDocumentEquality implements Equality<TovariRecord> {
  const TovariRecordDocumentEquality();

  @override
  bool equals(TovariRecord? e1, TovariRecord? e2) {
    const listEquality = ListEquality();
    return e1?.idSale == e2?.idSale &&
        e1?.idPartner == e2?.idPartner &&
        e1?.price == e2?.price &&
        e1?.priceSale == e2?.priceSale &&
        e1?.title == e2?.title &&
        listEquality.equals(e1?.tegi, e2?.tegi) &&
        listEquality.equals(e1?.image, e2?.image);
  }

  @override
  int hash(TovariRecord? e) => const ListEquality().hash([
        e?.idSale,
        e?.idPartner,
        e?.price,
        e?.priceSale,
        e?.title,
        e?.tegi,
        e?.image
      ]);

  @override
  bool isValidKey(Object? o) => o is TovariRecord;
}

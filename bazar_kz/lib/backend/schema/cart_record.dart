import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartRecord extends FirestoreRecord {
  CartRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "idUsers" field.
  DocumentReference? _idUsers;
  DocumentReference? get idUsers => _idUsers;
  bool hasIdUsers() => _idUsers != null;

  // "idTovar" field.
  DocumentReference? _idTovar;
  DocumentReference? get idTovar => _idTovar;
  bool hasIdTovar() => _idTovar != null;

  // "idPartner" field.
  DocumentReference? _idPartner;
  DocumentReference? get idPartner => _idPartner;
  bool hasIdPartner() => _idPartner != null;

  // "cols" field.
  int? _cols;
  int get cols => _cols ?? 0;
  bool hasCols() => _cols != null;

  void _initializeFields() {
    _idUsers = snapshotData['idUsers'] as DocumentReference?;
    _idTovar = snapshotData['idTovar'] as DocumentReference?;
    _idPartner = snapshotData['idPartner'] as DocumentReference?;
    _cols = castToType<int>(snapshotData['cols']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('cart');

  static Stream<CartRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CartRecord.fromSnapshot(s));

  static Future<CartRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CartRecord.fromSnapshot(s));

  static CartRecord fromSnapshot(DocumentSnapshot snapshot) => CartRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CartRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CartRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CartRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CartRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCartRecordData({
  DocumentReference? idUsers,
  DocumentReference? idTovar,
  DocumentReference? idPartner,
  int? cols,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'idUsers': idUsers,
      'idTovar': idTovar,
      'idPartner': idPartner,
      'cols': cols,
    }.withoutNulls,
  );

  return firestoreData;
}

class CartRecordDocumentEquality implements Equality<CartRecord> {
  const CartRecordDocumentEquality();

  @override
  bool equals(CartRecord? e1, CartRecord? e2) {
    return e1?.idUsers == e2?.idUsers &&
        e1?.idTovar == e2?.idTovar &&
        e1?.idPartner == e2?.idPartner &&
        e1?.cols == e2?.cols;
  }

  @override
  int hash(CartRecord? e) => const ListEquality()
      .hash([e?.idUsers, e?.idTovar, e?.idPartner, e?.cols]);

  @override
  bool isValidKey(Object? o) => o is CartRecord;
}

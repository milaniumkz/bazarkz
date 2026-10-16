import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContactRecord extends FirestoreRecord {
  ContactRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "insta" field.
  String? _insta;
  String get insta => _insta ?? '';
  bool hasInsta() => _insta != null;

  // "tel" field.
  String? _tel;
  String get tel => _tel ?? '';
  bool hasTel() => _tel != null;

  void _initializeFields() {
    _insta = snapshotData['insta'] as String?;
    _tel = snapshotData['tel'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('contact');

  static Stream<ContactRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ContactRecord.fromSnapshot(s));

  static Future<ContactRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ContactRecord.fromSnapshot(s));

  static ContactRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ContactRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContactRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContactRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContactRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContactRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContactRecordData({
  String? insta,
  String? tel,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'insta': insta,
      'tel': tel,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContactRecordDocumentEquality implements Equality<ContactRecord> {
  const ContactRecordDocumentEquality();

  @override
  bool equals(ContactRecord? e1, ContactRecord? e2) {
    return e1?.insta == e2?.insta && e1?.tel == e2?.tel;
  }

  @override
  int hash(ContactRecord? e) => const ListEquality().hash([e?.insta, e?.tel]);

  @override
  bool isValidKey(Object? o) => o is ContactRecord;
}

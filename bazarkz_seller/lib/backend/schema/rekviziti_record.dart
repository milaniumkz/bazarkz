import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RekvizitiRecord extends FirestoreRecord {
  RekvizitiRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  void _initializeFields() {
    _text = snapshotData['text'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rekviziti');

  static Stream<RekvizitiRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RekvizitiRecord.fromSnapshot(s));

  static Future<RekvizitiRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RekvizitiRecord.fromSnapshot(s));

  static RekvizitiRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RekvizitiRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RekvizitiRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RekvizitiRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RekvizitiRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RekvizitiRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRekvizitiRecordData({
  String? text,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'text': text,
    }.withoutNulls,
  );

  return firestoreData;
}

class RekvizitiRecordDocumentEquality implements Equality<RekvizitiRecord> {
  const RekvizitiRecordDocumentEquality();

  @override
  bool equals(RekvizitiRecord? e1, RekvizitiRecord? e2) {
    return e1?.text == e2?.text;
  }

  @override
  int hash(RekvizitiRecord? e) => const ListEquality().hash([e?.text]);

  @override
  bool isValidKey(Object? o) => o is RekvizitiRecord;
}

import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SoglashenieRecord extends FirestoreRecord {
  SoglashenieRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('soglashenie');

  static Stream<SoglashenieRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SoglashenieRecord.fromSnapshot(s));

  static Future<SoglashenieRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SoglashenieRecord.fromSnapshot(s));

  static SoglashenieRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SoglashenieRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SoglashenieRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SoglashenieRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SoglashenieRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SoglashenieRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSoglashenieRecordData({
  String? title,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
    }.withoutNulls,
  );

  return firestoreData;
}

class SoglashenieRecordDocumentEquality implements Equality<SoglashenieRecord> {
  const SoglashenieRecordDocumentEquality();

  @override
  bool equals(SoglashenieRecord? e1, SoglashenieRecord? e2) {
    return e1?.title == e2?.title;
  }

  @override
  int hash(SoglashenieRecord? e) => const ListEquality().hash([e?.title]);

  @override
  bool isValidKey(Object? o) => o is SoglashenieRecord;
}

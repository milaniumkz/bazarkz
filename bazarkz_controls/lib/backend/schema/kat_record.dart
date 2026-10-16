import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class KatRecord extends FirestoreRecord {
  KatRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "sort" field.
  int? _sort;
  int get sort => _sort ?? 0;
  bool hasSort() => _sort != null;

  // "blu" field.
  String? _blu;
  String get blu => _blu ?? '';
  bool hasBlu() => _blu != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _image = snapshotData['image'] as String?;
    _sort = castToType<int>(snapshotData['sort']);
    _blu = snapshotData['blu'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('kat');

  static Stream<KatRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => KatRecord.fromSnapshot(s));

  static Future<KatRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => KatRecord.fromSnapshot(s));

  static KatRecord fromSnapshot(DocumentSnapshot snapshot) => KatRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static KatRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      KatRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'KatRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is KatRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createKatRecordData({
  String? title,
  String? image,
  int? sort,
  String? blu,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'image': image,
      'sort': sort,
      'blu': blu,
    }.withoutNulls,
  );

  return firestoreData;
}

class KatRecordDocumentEquality implements Equality<KatRecord> {
  const KatRecordDocumentEquality();

  @override
  bool equals(KatRecord? e1, KatRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.image == e2?.image &&
        e1?.sort == e2?.sort &&
        e1?.blu == e2?.blu;
  }

  @override
  int hash(KatRecord? e) =>
      const ListEquality().hash([e?.title, e?.image, e?.sort, e?.blu]);

  @override
  bool isValidKey(Object? o) => o is KatRecord;
}

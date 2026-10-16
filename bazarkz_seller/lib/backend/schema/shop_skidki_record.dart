import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShopSkidkiRecord extends FirestoreRecord {
  ShopSkidkiRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "adres" field.
  String? _adres;
  String get adres => _adres ?? '';
  bool hasAdres() => _adres != null;

  // "logo" field.
  String? _logo;
  String get logo => _logo ?? '';
  bool hasLogo() => _logo != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "video" field.
  String? _video;
  String get video => _video ?? '';
  bool hasVideo() => _video != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "idPartner" field.
  DocumentReference? _idPartner;
  DocumentReference? get idPartner => _idPartner;
  bool hasIdPartner() => _idPartner != null;

  // "tel" field.
  String? _tel;
  String get tel => _tel ?? '';
  bool hasTel() => _tel != null;

  // "inst" field.
  String? _inst;
  String get inst => _inst ?? '';
  bool hasInst() => _inst != null;

  // "kat" field.
  String? _kat;
  String get kat => _kat ?? '';
  bool hasKat() => _kat != null;

  // "podKat" field.
  String? _podKat;
  String get podKat => _podKat ?? '';
  bool hasPodKat() => _podKat != null;

  // "podKat2" field.
  String? _podKat2;
  String get podKat2 => _podKat2 ?? '';
  bool hasPodKat2() => _podKat2 != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "osob" field.
  String? _osob;
  String get osob => _osob ?? '';
  bool hasOsob() => _osob != null;

  // "uslovia" field.
  String? _uslovia;
  String get uslovia => _uslovia ?? '';
  bool hasUslovia() => _uslovia != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "fovaritUsers" field.
  List<DocumentReference>? _fovaritUsers;
  List<DocumentReference> get fovaritUsers => _fovaritUsers ?? const [];
  bool hasFovaritUsers() => _fovaritUsers != null;

  // "dateTheEnd" field.
  DateTime? _dateTheEnd;
  DateTime? get dateTheEnd => _dateTheEnd;
  bool hasDateTheEnd() => _dateTheEnd != null;

  // "pnOt" field.
  String? _pnOt;
  String get pnOt => _pnOt ?? '';
  bool hasPnOt() => _pnOt != null;

  // "pnDo" field.
  String? _pnDo;
  String get pnDo => _pnDo ?? '';
  bool hasPnDo() => _pnDo != null;

  // "vtOt" field.
  String? _vtOt;
  String get vtOt => _vtOt ?? '';
  bool hasVtOt() => _vtOt != null;

  // "vtDo" field.
  String? _vtDo;
  String get vtDo => _vtDo ?? '';
  bool hasVtDo() => _vtDo != null;

  // "srOt" field.
  String? _srOt;
  String get srOt => _srOt ?? '';
  bool hasSrOt() => _srOt != null;

  // "srDo" field.
  String? _srDo;
  String get srDo => _srDo ?? '';
  bool hasSrDo() => _srDo != null;

  // "chOt" field.
  String? _chOt;
  String get chOt => _chOt ?? '';
  bool hasChOt() => _chOt != null;

  // "chDo" field.
  String? _chDo;
  String get chDo => _chDo ?? '';
  bool hasChDo() => _chDo != null;

  // "ptOt" field.
  String? _ptOt;
  String get ptOt => _ptOt ?? '';
  bool hasPtOt() => _ptOt != null;

  // "ptDo" field.
  String? _ptDo;
  String get ptDo => _ptDo ?? '';
  bool hasPtDo() => _ptDo != null;

  // "sbOt" field.
  String? _sbOt;
  String get sbOt => _sbOt ?? '';
  bool hasSbOt() => _sbOt != null;

  // "sbDo" field.
  String? _sbDo;
  String get sbDo => _sbDo ?? '';
  bool hasSbDo() => _sbDo != null;

  // "vsOt" field.
  String? _vsOt;
  String get vsOt => _vsOt ?? '';
  bool hasVsOt() => _vsOt != null;

  // "vsDo" field.
  String? _vsDo;
  String get vsDo => _vsDo ?? '';
  bool hasVsDo() => _vsDo != null;

  // "procent" field.
  String? _procent;
  String get procent => _procent ?? '';
  bool hasProcent() => _procent != null;

  void _initializeFields() {
    _adres = snapshotData['adres'] as String?;
    _logo = snapshotData['logo'] as String?;
    _images = getDataList(snapshotData['images']);
    _video = snapshotData['video'] as String?;
    _title = snapshotData['title'] as String?;
    _idPartner = snapshotData['idPartner'] as DocumentReference?;
    _tel = snapshotData['tel'] as String?;
    _inst = snapshotData['inst'] as String?;
    _kat = snapshotData['kat'] as String?;
    _podKat = snapshotData['podKat'] as String?;
    _podKat2 = snapshotData['podKat2'] as String?;
    _text = snapshotData['text'] as String?;
    _osob = snapshotData['osob'] as String?;
    _uslovia = snapshotData['uslovia'] as String?;
    _city = snapshotData['city'] as String?;
    _fovaritUsers = getDataList(snapshotData['fovaritUsers']);
    _dateTheEnd = snapshotData['dateTheEnd'] as DateTime?;
    _pnOt = snapshotData['pnOt'] as String?;
    _pnDo = snapshotData['pnDo'] as String?;
    _vtOt = snapshotData['vtOt'] as String?;
    _vtDo = snapshotData['vtDo'] as String?;
    _srOt = snapshotData['srOt'] as String?;
    _srDo = snapshotData['srDo'] as String?;
    _chOt = snapshotData['chOt'] as String?;
    _chDo = snapshotData['chDo'] as String?;
    _ptOt = snapshotData['ptOt'] as String?;
    _ptDo = snapshotData['ptDo'] as String?;
    _sbOt = snapshotData['sbOt'] as String?;
    _sbDo = snapshotData['sbDo'] as String?;
    _vsOt = snapshotData['vsOt'] as String?;
    _vsDo = snapshotData['vsDo'] as String?;
    _procent = snapshotData['procent'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('shopSkidki');

  static Stream<ShopSkidkiRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ShopSkidkiRecord.fromSnapshot(s));

  static Future<ShopSkidkiRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ShopSkidkiRecord.fromSnapshot(s));

  static ShopSkidkiRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ShopSkidkiRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ShopSkidkiRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ShopSkidkiRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ShopSkidkiRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ShopSkidkiRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createShopSkidkiRecordData({
  String? adres,
  String? logo,
  String? video,
  String? title,
  DocumentReference? idPartner,
  String? tel,
  String? inst,
  String? kat,
  String? podKat,
  String? podKat2,
  String? text,
  String? osob,
  String? uslovia,
  String? city,
  DateTime? dateTheEnd,
  String? pnOt,
  String? pnDo,
  String? vtOt,
  String? vtDo,
  String? srOt,
  String? srDo,
  String? chOt,
  String? chDo,
  String? ptOt,
  String? ptDo,
  String? sbOt,
  String? sbDo,
  String? vsOt,
  String? vsDo,
  String? procent,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'adres': adres,
      'logo': logo,
      'video': video,
      'title': title,
      'idPartner': idPartner,
      'tel': tel,
      'inst': inst,
      'kat': kat,
      'podKat': podKat,
      'podKat2': podKat2,
      'text': text,
      'osob': osob,
      'uslovia': uslovia,
      'city': city,
      'dateTheEnd': dateTheEnd,
      'pnOt': pnOt,
      'pnDo': pnDo,
      'vtOt': vtOt,
      'vtDo': vtDo,
      'srOt': srOt,
      'srDo': srDo,
      'chOt': chOt,
      'chDo': chDo,
      'ptOt': ptOt,
      'ptDo': ptDo,
      'sbOt': sbOt,
      'sbDo': sbDo,
      'vsOt': vsOt,
      'vsDo': vsDo,
      'procent': procent,
    }.withoutNulls,
  );

  return firestoreData;
}

class ShopSkidkiRecordDocumentEquality implements Equality<ShopSkidkiRecord> {
  const ShopSkidkiRecordDocumentEquality();

  @override
  bool equals(ShopSkidkiRecord? e1, ShopSkidkiRecord? e2) {
    const listEquality = ListEquality();
    return e1?.adres == e2?.adres &&
        e1?.logo == e2?.logo &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.video == e2?.video &&
        e1?.title == e2?.title &&
        e1?.idPartner == e2?.idPartner &&
        e1?.tel == e2?.tel &&
        e1?.inst == e2?.inst &&
        e1?.kat == e2?.kat &&
        e1?.podKat == e2?.podKat &&
        e1?.podKat2 == e2?.podKat2 &&
        e1?.text == e2?.text &&
        e1?.osob == e2?.osob &&
        e1?.uslovia == e2?.uslovia &&
        e1?.city == e2?.city &&
        listEquality.equals(e1?.fovaritUsers, e2?.fovaritUsers) &&
        e1?.dateTheEnd == e2?.dateTheEnd &&
        e1?.pnOt == e2?.pnOt &&
        e1?.pnDo == e2?.pnDo &&
        e1?.vtOt == e2?.vtOt &&
        e1?.vtDo == e2?.vtDo &&
        e1?.srOt == e2?.srOt &&
        e1?.srDo == e2?.srDo &&
        e1?.chOt == e2?.chOt &&
        e1?.chDo == e2?.chDo &&
        e1?.ptOt == e2?.ptOt &&
        e1?.ptDo == e2?.ptDo &&
        e1?.sbOt == e2?.sbOt &&
        e1?.sbDo == e2?.sbDo &&
        e1?.vsOt == e2?.vsOt &&
        e1?.vsDo == e2?.vsDo &&
        e1?.procent == e2?.procent;
  }

  @override
  int hash(ShopSkidkiRecord? e) => const ListEquality().hash([
        e?.adres,
        e?.logo,
        e?.images,
        e?.video,
        e?.title,
        e?.idPartner,
        e?.tel,
        e?.inst,
        e?.kat,
        e?.podKat,
        e?.podKat2,
        e?.text,
        e?.osob,
        e?.uslovia,
        e?.city,
        e?.fovaritUsers,
        e?.dateTheEnd,
        e?.pnOt,
        e?.pnDo,
        e?.vtOt,
        e?.vtDo,
        e?.srOt,
        e?.srDo,
        e?.chOt,
        e?.chDo,
        e?.ptOt,
        e?.ptDo,
        e?.sbOt,
        e?.sbDo,
        e?.vsOt,
        e?.vsDo,
        e?.procent
      ]);

  @override
  bool isValidKey(Object? o) => o is ShopSkidkiRecord;
}

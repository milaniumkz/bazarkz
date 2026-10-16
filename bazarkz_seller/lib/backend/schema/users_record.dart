import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "premium" field.
  bool? _premium;
  bool get premium => _premium ?? false;
  bool hasPremium() => _premium != null;

  // "datePremium" field.
  DateTime? _datePremium;
  DateTime? get datePremium => _datePremium;
  bool hasDatePremium() => _datePremium != null;

  // "pinCode" field.
  int? _pinCode;
  int get pinCode => _pinCode ?? 0;
  bool hasPinCode() => _pinCode != null;

  // "shortDescription" field.
  String? _shortDescription;
  String get shortDescription => _shortDescription ?? '';
  bool hasShortDescription() => _shortDescription != null;

  // "last_active_time" field.
  DateTime? _lastActiveTime;
  DateTime? get lastActiveTime => _lastActiveTime;
  bool hasLastActiveTime() => _lastActiveTime != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "favorites" field.
  List<DocumentReference>? _favorites;
  List<DocumentReference> get favorites => _favorites ?? const [];
  bool hasFavorites() => _favorites != null;

  // "admin" field.
  bool? _admin;
  bool get admin => _admin ?? false;
  bool hasAdmin() => _admin != null;

  // "partner" field.
  bool? _partner;
  bool get partner => _partner ?? false;
  bool hasPartner() => _partner != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "balance" field.
  double? _balance;
  double get balance => _balance ?? 0.0;
  bool hasBalance() => _balance != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _city = snapshotData['city'] as String?;
    _premium = snapshotData['premium'] as bool?;
    _datePremium = snapshotData['datePremium'] as DateTime?;
    _pinCode = castToType<int>(snapshotData['pinCode']);
    _shortDescription = snapshotData['shortDescription'] as String?;
    _lastActiveTime = snapshotData['last_active_time'] as DateTime?;
    _role = snapshotData['role'] as String?;
    _title = snapshotData['title'] as String?;
    _favorites = getDataList(snapshotData['favorites']);
    _admin = snapshotData['admin'] as bool?;
    _partner = snapshotData['partner'] as bool?;
    _name = snapshotData['name'] as String?;
    _balance = castToType<double>(snapshotData['balance']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static DocumentReference _readableProfile(DocumentReference ref) =>
      ref.id == FirebaseAuth.instance.currentUser?.uid
          ? ref
          : FirebaseFirestore.instance.collection('userDirectory').doc(ref.id);

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      _readableProfile(ref).snapshots().map((s) =>
          UsersRecord.getDocumentFromData(
              (s.data() as Map<String, dynamic>?) ?? {}, ref));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      _readableProfile(ref).get().then((s) => UsersRecord.getDocumentFromData(
          (s.data() as Map<String, dynamic>?) ?? {}, ref));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? city,
  bool? premium,
  DateTime? datePremium,
  int? pinCode,
  String? shortDescription,
  DateTime? lastActiveTime,
  String? role,
  String? title,
  bool? admin,
  bool? partner,
  String? name,
  double? balance,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'city': city,
      'premium': premium,
      'datePremium': datePremium,
      'pinCode': pinCode,
      'shortDescription': shortDescription,
      'last_active_time': lastActiveTime,
      'role': role,
      'title': title,
      'admin': admin,
      'partner': partner,
      'name': name,
      'balance': balance,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.city == e2?.city &&
        e1?.premium == e2?.premium &&
        e1?.datePremium == e2?.datePremium &&
        e1?.pinCode == e2?.pinCode &&
        e1?.shortDescription == e2?.shortDescription &&
        e1?.lastActiveTime == e2?.lastActiveTime &&
        e1?.role == e2?.role &&
        e1?.title == e2?.title &&
        listEquality.equals(e1?.favorites, e2?.favorites) &&
        e1?.admin == e2?.admin &&
        e1?.partner == e2?.partner &&
        e1?.name == e2?.name &&
        e1?.balance == e2?.balance;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.city,
        e?.premium,
        e?.datePremium,
        e?.pinCode,
        e?.shortDescription,
        e?.lastActiveTime,
        e?.role,
        e?.title,
        e?.favorites,
        e?.admin,
        e?.partner,
        e?.name,
        e?.balance
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}

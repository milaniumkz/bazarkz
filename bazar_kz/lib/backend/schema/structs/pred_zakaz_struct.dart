// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PredZakazStruct extends FFFirebaseStruct {
  PredZakazStruct({
    DocumentReference? idTovar,
    int? cols,
    DocumentReference? idUser,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _idTovar = idTovar,
        _cols = cols,
        _idUser = idUser,
        super(firestoreUtilData);

  // "idTovar" field.
  DocumentReference? _idTovar;
  DocumentReference? get idTovar => _idTovar;
  set idTovar(DocumentReference? val) => _idTovar = val;

  bool hasIdTovar() => _idTovar != null;

  // "cols" field.
  int? _cols;
  int get cols => _cols ?? 0;
  set cols(int? val) => _cols = val;

  void incrementCols(int amount) => cols = cols + amount;

  bool hasCols() => _cols != null;

  // "idUser" field.
  DocumentReference? _idUser;
  DocumentReference? get idUser => _idUser;
  set idUser(DocumentReference? val) => _idUser = val;

  bool hasIdUser() => _idUser != null;

  static PredZakazStruct fromMap(Map<String, dynamic> data) => PredZakazStruct(
        idTovar: data['idTovar'] as DocumentReference?,
        cols: castToType<int>(data['cols']),
        idUser: data['idUser'] as DocumentReference?,
      );

  static PredZakazStruct? maybeFromMap(dynamic data) => data is Map
      ? PredZakazStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idTovar': _idTovar,
        'cols': _cols,
        'idUser': _idUser,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idTovar': serializeParam(
          _idTovar,
          ParamType.DocumentReference,
        ),
        'cols': serializeParam(
          _cols,
          ParamType.int,
        ),
        'idUser': serializeParam(
          _idUser,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static PredZakazStruct fromSerializableMap(Map<String, dynamic> data) =>
      PredZakazStruct(
        idTovar: deserializeParam(
          data['idTovar'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['tovari'],
        ),
        cols: deserializeParam(
          data['cols'],
          ParamType.int,
          false,
        ),
        idUser: deserializeParam(
          data['idUser'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
      );

  @override
  String toString() => 'PredZakazStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PredZakazStruct &&
        idTovar == other.idTovar &&
        cols == other.cols &&
        idUser == other.idUser;
  }

  @override
  int get hashCode => const ListEquality().hash([idTovar, cols, idUser]);
}

PredZakazStruct createPredZakazStruct({
  DocumentReference? idTovar,
  int? cols,
  DocumentReference? idUser,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PredZakazStruct(
      idTovar: idTovar,
      cols: cols,
      idUser: idUser,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PredZakazStruct? updatePredZakazStruct(
  PredZakazStruct? predZakaz, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    predZakaz
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPredZakazStructData(
  Map<String, dynamic> firestoreData,
  PredZakazStruct? predZakaz,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (predZakaz == null) {
    return;
  }
  if (predZakaz.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && predZakaz.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final predZakazData = getPredZakazFirestoreData(predZakaz, forFieldValue);
  final nestedData = predZakazData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = predZakaz.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPredZakazFirestoreData(
  PredZakazStruct? predZakaz, [
  bool forFieldValue = false,
]) {
  if (predZakaz == null) {
    return {};
  }
  final firestoreData = mapToFirestore(predZakaz.toMap());

  // Add any Firestore field values
  predZakaz.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPredZakazListFirestoreData(
  List<PredZakazStruct>? predZakazs,
) =>
    predZakazs?.map((e) => getPredZakazFirestoreData(e, true)).toList() ?? [];

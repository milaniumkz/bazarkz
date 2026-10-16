import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _city = await secureStorage.getString('ff_city') ?? _city;
    });
    await _safeInitAsync(() async {
      _qrDate = await secureStorage.getString('ff_qrDate') ?? _qrDate;
    });
    await _safeInitAsync(() async {
      await secureStorage.delete(key: 'ff_sms');
      _sms = ''; // Clear legacy persisted password.
    });
    await _safeInitAsync(() async {
      _phone = await secureStorage.getString('ff_phone') ?? _phone;
    });
    await _safeInitAsync(() async {
      _qrdata = await secureStorage.getString('ff_qrdata') ?? _qrdata;
    });
    await _safeInitAsync(() async {
      _nedel = await secureStorage.getStringList('ff_nedel') ?? _nedel;
    });
    await _safeInitAsync(() async {
      _uslovia = (await secureStorage.getString('ff_uslovia'))?.ref ?? _uslovia;
    });
    await _safeInitAsync(() async {
      _podSale = await secureStorage.getBool('ff_podSale') ?? _podSale;
    });
    await _safeInitAsync(() async {
      _favorites = (await secureStorage.getStringList('ff_favorites'))
              ?.map((path) => path.ref)
              .toList() ??
          _favorites;
    });
    await _safeInitAsync(() async {
      _summa = await secureStorage.getDouble('ff_summa') ?? _summa;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  String _city = '';
  String get city => _city;
  set city(String value) {
    _city = value;
    secureStorage.setString('ff_city', value);
  }

  void deleteCity() {
    secureStorage.delete(key: 'ff_city');
  }

  String _qrDate = '';
  String get qrDate => _qrDate;
  set qrDate(String value) {
    _qrDate = value;
    secureStorage.setString('ff_qrDate', value);
  }

  void deleteQrDate() {
    secureStorage.delete(key: 'ff_qrDate');
  }

  String _sms = '';
  String get sms => _sms;
  set sms(String value) {
    _sms = value;
    secureStorage.setString('ff_sms', value);
  }

  void deleteSms() {
    secureStorage.delete(key: 'ff_sms');
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    secureStorage.setString('ff_phone', value);
  }

  void deletePhone() {
    secureStorage.delete(key: 'ff_phone');
  }

  String _qrdata = '';
  String get qrdata => _qrdata;
  set qrdata(String value) {
    _qrdata = value;
    secureStorage.setString('ff_qrdata', value);
  }

  void deleteQrdata() {
    secureStorage.delete(key: 'ff_qrdata');
  }

  List<String> _nedel = [];
  List<String> get nedel => _nedel;
  set nedel(List<String> value) {
    _nedel = value;
    secureStorage.setStringList('ff_nedel', value);
  }

  void deleteNedel() {
    secureStorage.delete(key: 'ff_nedel');
  }

  void addToNedel(String value) {
    nedel.add(value);
    secureStorage.setStringList('ff_nedel', _nedel);
  }

  void removeFromNedel(String value) {
    nedel.remove(value);
    secureStorage.setStringList('ff_nedel', _nedel);
  }

  void removeAtIndexFromNedel(int index) {
    nedel.removeAt(index);
    secureStorage.setStringList('ff_nedel', _nedel);
  }

  void updateNedelAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    nedel[index] = updateFn(_nedel[index]);
    secureStorage.setStringList('ff_nedel', _nedel);
  }

  void insertAtIndexInNedel(int index, String value) {
    nedel.insert(index, value);
    secureStorage.setStringList('ff_nedel', _nedel);
  }

  DocumentReference? _uslovia =
      FirebaseFirestore.instance.doc('/soglashenie/0QDXJdigP7lRK2RtuhR5');
  DocumentReference? get uslovia => _uslovia;
  set uslovia(DocumentReference? value) {
    _uslovia = value;
    value != null
        ? secureStorage.setString('ff_uslovia', value.path)
        : secureStorage.remove('ff_uslovia');
  }

  void deleteUslovia() {
    secureStorage.delete(key: 'ff_uslovia');
  }

  bool _podSale = false;
  bool get podSale => _podSale;
  set podSale(bool value) {
    _podSale = value;
    secureStorage.setBool('ff_podSale', value);
  }

  void deletePodSale() {
    secureStorage.delete(key: 'ff_podSale');
  }

  List<DocumentReference> _favorites = [];
  List<DocumentReference> get favorites => _favorites;
  set favorites(List<DocumentReference> value) {
    _favorites = value;
    secureStorage.setStringList(
        'ff_favorites', value.map((x) => x.path).toList());
  }

  void deleteFavorites() {
    secureStorage.delete(key: 'ff_favorites');
  }

  void addToFavorites(DocumentReference value) {
    favorites.add(value);
    secureStorage.setStringList(
        'ff_favorites', _favorites.map((x) => x.path).toList());
  }

  void removeFromFavorites(DocumentReference value) {
    favorites.remove(value);
    secureStorage.setStringList(
        'ff_favorites', _favorites.map((x) => x.path).toList());
  }

  void removeAtIndexFromFavorites(int index) {
    favorites.removeAt(index);
    secureStorage.setStringList(
        'ff_favorites', _favorites.map((x) => x.path).toList());
  }

  void updateFavoritesAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    favorites[index] = updateFn(_favorites[index]);
    secureStorage.setStringList(
        'ff_favorites', _favorites.map((x) => x.path).toList());
  }

  void insertAtIndexInFavorites(int index, DocumentReference value) {
    favorites.insert(index, value);
    secureStorage.setStringList(
        'ff_favorites', _favorites.map((x) => x.path).toList());
  }

  double _summa = 0.0;
  double get summa => _summa;
  set summa(double value) {
    _summa = value;
    secureStorage.setDouble('ff_summa', value);
  }

  void deleteSumma() {
    secureStorage.delete(key: 'ff_summa');
  }

  final _historyManager = StreamRequestManager<List<OrderRecord>>();
  Stream<List<OrderRecord>> history({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<OrderRecord>> Function() requestFn,
  }) =>
      _historyManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearHistoryCache() => _historyManager.clear();
  void clearHistoryCacheKey(String? uniqueKey) =>
      _historyManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}

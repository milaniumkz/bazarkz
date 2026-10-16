import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _city = prefs.getString('ff_city') ?? _city;
    });
    _safeInit(() {
      _qrDate = prefs.getString('ff_qrDate') ?? _qrDate;
    });
    _safeInit(() {
      _sms = prefs.getString('ff_sms') ?? _sms;
    });
    _safeInit(() {
      _phone = prefs.getString('ff_phone') ?? _phone;
    });
    _safeInit(() {
      _qrdata = prefs.getString('ff_qrdata') ?? _qrdata;
    });
    _safeInit(() {
      _nedel = prefs.getStringList('ff_nedel') ?? _nedel;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _city = '';
  String get city => _city;
  set city(String value) {
    _city = value;
    prefs.setString('ff_city', value);
  }

  String _qrDate = '';
  String get qrDate => _qrDate;
  set qrDate(String value) {
    _qrDate = value;
    prefs.setString('ff_qrDate', value);
  }

  String _sms = '';
  String get sms => _sms;
  set sms(String value) {
    _sms = value;
    prefs.setString('ff_sms', value);
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    prefs.setString('ff_phone', value);
  }

  String _qrdata = '';
  String get qrdata => _qrdata;
  set qrdata(String value) {
    _qrdata = value;
    prefs.setString('ff_qrdata', value);
  }

  List<String> _nedel = [];
  List<String> get nedel => _nedel;
  set nedel(List<String> value) {
    _nedel = value;
    prefs.setStringList('ff_nedel', value);
  }

  void addToNedel(String value) {
    nedel.add(value);
    prefs.setStringList('ff_nedel', _nedel);
  }

  void removeFromNedel(String value) {
    nedel.remove(value);
    prefs.setStringList('ff_nedel', _nedel);
  }

  void removeAtIndexFromNedel(int index) {
    nedel.removeAt(index);
    prefs.setStringList('ff_nedel', _nedel);
  }

  void updateNedelAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    nedel[index] = updateFn(_nedel[index]);
    prefs.setStringList('ff_nedel', _nedel);
  }

  void insertAtIndexInNedel(int index, String value) {
    nedel.insert(index, value);
    prefs.setStringList('ff_nedel', _nedel);
  }

  final _userDocQueryManager = FutureRequestManager<UsersRecord>();
  Future<UsersRecord> userDocQuery({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<UsersRecord> Function() requestFn,
  }) =>
      _userDocQueryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserDocQueryCache() => _userDocQueryManager.clear();
  void clearUserDocQueryCacheKey(String? uniqueKey) =>
      _userDocQueryManager.clearRequest(uniqueKey);
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

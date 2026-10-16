import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class LocationCall {
  static Future<ApiCallResponse> call({
    String? q = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'location',
      apiUrl: 'https://nominatim.openstreetmap.org/search',
      callType: ApiCallType.GET,
      headers: {
        'User-Agent': 'com.milanium.bazarkz/1.0',
        'Accept': 'application/json',
      },
      params: {
        'q': q,
        'format': "JSON",
        'limit': 1,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeliveryPriceCall {
  static Future<ApiCallResponse> call({
    double? punkt1,
    double? punkt11,
    double? punkt2,
    double? punkt22,
  }) async {
    final ffApiRequestBody = '''
{
  "route_points": [
    {
      "id": 1,
      "coordinates": [${punkt1},${punkt11}]
    },
    {
      "id": 2,
      "coordinates": [${punkt2},${punkt22}]
    }
  ],
  "items": [
    {
      "size": {
        "length": 0.003,
        "width": 0.002,
        "height": 0.001
      },
      "weight": 0.008,
      "quantity": 1,
      "pickup_point": 1,
      "dropoff_point": 2
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deliveryPrice',
      apiUrl:
          'https://us-central1-ba-za-r-k-z-np0vyz.cloudfunctions.net/getYandexDeliveryPrice',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? price(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.price''',
      ));
  static String? typeDeliver(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.requirements.taxi_class''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}

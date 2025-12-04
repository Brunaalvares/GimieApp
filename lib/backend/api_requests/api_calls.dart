import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SalvarLinkCall {
  static Future<ApiCallResponse> call({
    String? productUrl = 'urlaqui[link]',
  }) async {
    final payload = json.encode({
      'url': productUrl?.trim() ?? '',
    });
    return ApiManager.instance.makeApiCall(
      callName: 'salvar link',
      apiUrl: 'https://gimieapi.onrender.com/links',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: payload,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static Map<String, dynamic>? _extractProduct(dynamic response) {
    if (response == null) {
      return null;
    }
    final product = _castToMap(response);
    if (product != null) {
      return product;
    }
    if (response is List && response.isNotEmpty) {
      return _castToMap(response.first);
    }
    return null;
  }

  static Map<String, dynamic>? _castToMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }
    return null;
  }

  static String? _stringField(dynamic response, String key) {
    final product = _extractProduct(response);
    if (product == null || !product.containsKey(key)) {
      return null;
    }
    final value = product[key];
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }

  static dynamic name(dynamic response) => _extractProduct(response);
  static String? nome(dynamic response) => _stringField(response, 'nome');
  static String? price(dynamic response) => _stringField(response, 'preco');
  static String? imagem(dynamic response) => _stringField(response, 'imagem');
  static String? url(dynamic response) => _stringField(response, 'url');
}

class SalvarNaListaCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'Salvar na lista',
      apiUrl: 'https://gimieapi.onrender.com/',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
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

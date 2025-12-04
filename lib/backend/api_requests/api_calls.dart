import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SalvarLinkCall {
  static Future<ApiCallResponse> call({
    required String productUrl,
  }) async {
    final sanitizedUrl = productUrl.trim();
    final ffApiRequestBody = json.encode({'url': sanitizedUrl});
    return ApiManager.instance.makeApiCall(
      callName: 'salvar link',
      apiUrl: 'https://gimieapi.onrender.com/links',
      callType: ApiCallType.POST,
      headers: const {
        'Content-Type': 'application/json',
      },
      params: const {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static Map<String, dynamic>? _entity(dynamic response) {
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) {
        return first;
      }
    }
    if (response is Map<String, dynamic>) {
      return response;
    }
    return null;
  }

  static String? title(dynamic response) {
    final entity = _entity(response);
    return castToType<String>(
          entity?['title'],
        ) ??
        castToType<String>(entity?['nome']);
  }

  static String? price(dynamic response) {
    final entity = _entity(response);
    final value = entity?['price'] ?? entity?['preco'];
    return value?.toString();
  }

  static String? image(dynamic response) {
    final entity = _entity(response);
    return castToType<String>(
          entity?['imageUrl'],
        ) ??
        castToType<String>(entity?['image']) ??
        castToType<String>(entity?['imagem']);
  }

  static String? productUrl(dynamic response) {
    final entity = _entity(response);
    return castToType<String>(
          entity?['productUrl'],
        ) ??
        castToType<String>(entity?['url']);
  }
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

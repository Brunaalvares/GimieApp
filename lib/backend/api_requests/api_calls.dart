import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class SalvarLinkCall {
  static Future<ApiCallResponse> call({
    String? productUrl = '',
  }) async {
    // Try POST first (when API is ready)
    final ffApiRequestBody = '''
{
  "url": "${escapeStringForJson(productUrl)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'salvar link',
      apiUrl: 'https://gimieapi.onrender.com/links',
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
  
  // Fallback GET method (for testing or when POST is not available)
  static Future<ApiCallResponse> callGet({
    String? productUrl = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'salvar link GET',
      apiUrl: 'https://gimieapi.onrender.com/links',
      callType: ApiCallType.GET,
      headers: {},
      params: productUrl != null && productUrl.isNotEmpty
          ? {'url': productUrl}
          : {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic name(dynamic response) => getJsonField(response, r'''$''');

  // Robust extractors: support object ({...}) or array ([{...}]) responses.
  static String? nome(dynamic response) {
    final direct = getJsonField(response, r'''$.nome''');
    if (direct != null && direct.toString().isNotEmpty) {
      return castToType<String>(direct);
    }
    return castToType<String>(getJsonField(response, r'''$[0].nome'''));
  }

  static String? price(dynamic response) {
    final direct = getJsonField(response, r'''$.preco''');
    if (direct != null && direct.toString().isNotEmpty) {
      return direct.toString();
    }
    final fromArray = getJsonField(response, r'''$[0].preco''');
    return fromArray?.toString();
  }

  static String? imagem(dynamic response) {
    final direct = getJsonField(response, r'''$.imagem''');
    if (direct != null && direct.toString().isNotEmpty) {
      return castToType<String>(direct);
    }
    return castToType<String>(getJsonField(response, r'''$[0].imagem'''));
  }

  static String? url(dynamic response) {
    final direct = getJsonField(response, r'''$.url''');
    if (direct != null && direct.toString().isNotEmpty) {
      return castToType<String>(direct);
    }
    return castToType<String>(getJsonField(response, r'''$[0].url'''));
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

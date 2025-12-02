import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';

class LinkMetadata {
  const LinkMetadata({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.productUrl,
    required this.sourceUrl,
  });

  final String title;
  final String imageUrl;
  final double price;
  final String productUrl;
  final String sourceUrl;

  Map<String, dynamic> toFirestoreData({
    required String uid,
  }) =>
      createProdutosRecordData(
        title: title,
        imageUrl: imageUrl,
        price: price,
        productUrl: productUrl,
        uid: uid,
        createdAt: FieldValue.serverTimestamp(),
      );
}

class LinkFetchResult {
  LinkFetchResult({
    required this.metadata,
    required this.response,
  });

  final LinkMetadata metadata;
  final ApiCallResponse response;
}

class LinkIngestionService {
  LinkIngestionService._();

  static Future<LinkFetchResult> fetchMetadata(String rawUrl) async {
    final sanitizedUrl = rawUrl.trim();
    if (sanitizedUrl.isEmpty) {
      throw ArgumentError('URL is empty');
    }
    final apiResponse = await SalvarLinkCall.call(productUrl: sanitizedUrl);
    if (!(apiResponse.succeeded) || apiResponse.jsonBody == null) {
      throw Exception('API did not return metadata.');
    }

    final metadata =
        _mapResponseToMetadata(apiResponse.jsonBody, sanitizedUrl);
    return LinkFetchResult(metadata: metadata, response: apiResponse);
  }

  static Future<void> saveMetadata({
    required String uid,
    required LinkMetadata metadata,
  }) async {
    final docRef = ProdutosRecord.collection.doc();
    await docRef.set(metadata.toFirestoreData(uid: uid));
  }

  static Future<LinkMetadata> processLink({
    required String url,
    required String uid,
  }) async {
    final result = await fetchMetadata(url);
    await saveMetadata(uid: uid, metadata: result.metadata);
    return result.metadata;
  }

  static LinkMetadata _mapResponseToMetadata(
    dynamic rawResponse,
    String fallbackUrl,
  ) {
    Map<String, dynamic>? entity;
    if (rawResponse is List && rawResponse.isNotEmpty) {
      final first = rawResponse.first;
      if (first is Map<String, dynamic>) {
        entity = first;
      }
    } else if (rawResponse is Map<String, dynamic>) {
      entity = rawResponse;
    }

    entity ??= {};

    String _stringValue(List<String> keys) {
      for (final key in keys) {
        final value = entity![key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      return '';
    }

    double _parsePrice(dynamic value) {
      if (value == null) {
        return 0.0;
      }
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final cleaned = value.replaceAll(RegExp(r'[^0-9,\.]'), '');
        if (cleaned.isEmpty) {
          return 0.0;
        }
        final normalized = cleaned.replaceAll('.', '').replaceAll(',', '.');
        return double.tryParse(normalized) ?? 0.0;
      }
      return 0.0;
    }

    final priceValue = _parsePrice(
      entity['price'] ??
          entity['preco'] ??
          entity['valor'] ??
          entity['valorProduto'],
    );

    final productUrl =
        _stringValue(['productUrl', 'url']).ifEmpty(() => fallbackUrl);

    return LinkMetadata(
      title: _stringValue(['title', 'nome', 'name']),
      imageUrl: _stringValue(['imageUrl', 'image', 'imagem']),
      price: priceValue,
      productUrl: productUrl,
      sourceUrl: fallbackUrl,
    );
  }
}

extension _StringFallback on String {
  String ifEmpty(String Function() fallback) =>
      trim().isEmpty ? fallback() : this;
}

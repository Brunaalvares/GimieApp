// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ProdutosStruct extends FFFirebaseStruct {
  ProdutosStruct({
    String? title,
    String? imageUrl,
    double? price,
    String? productUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _title = title,
        _imageUrl = imageUrl,
        _price = price,
        _productUrl = productUrl,
        super(firestoreUtilData);

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;
  String get nome => title;
  set nome(String? val) => title = val;

  bool hasTitle() => _title != null;
  bool hasNome() => hasTitle();

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;
  String get imageurl => imageUrl;
  set imageurl(String? val) => imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;
  bool hasImageurl() => hasImageUrl();

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "productUrl" field.
  String? _productUrl;
  String get productUrl => _productUrl ?? '';
  set productUrl(String? val) => _productUrl = val;
  String get linkdoProduto => productUrl;
  set linkdoProduto(String? val) => productUrl = val;

  bool hasProductUrl() => _productUrl != null;
  bool hasLinkdoProduto() => hasProductUrl();

  static ProdutosStruct fromMap(Map<String, dynamic> data) => ProdutosStruct(
        title: data['title'] as String?,
        imageUrl: data['imageUrl'] as String?,
        price: castToType<double>(data['price']),
        productUrl: data['productUrl'] as String?,
      );

  static ProdutosStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProdutosStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'imageUrl': _imageUrl,
        'price': _price,
        'productUrl': _productUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'productUrl': serializeParam(
          _productUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProdutosStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProdutosStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        productUrl: deserializeParam(
          data['productUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProdutosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProdutosStruct &&
        title == other.title &&
        imageUrl == other.imageUrl &&
        price == other.price &&
        productUrl == other.productUrl;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([title, imageUrl, price, productUrl]);
}

ProdutosStruct createProdutosStruct({
  String? title,
  String? imageUrl,
  double? price,
  String? productUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProdutosStruct(
      title: title,
      imageUrl: imageUrl,
      price: price,
      productUrl: productUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ProdutosStruct? updateProdutosStruct(
  ProdutosStruct? produtos, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    produtos
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addProdutosStructData(
  Map<String, dynamic> firestoreData,
  ProdutosStruct? produtos,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (produtos == null) {
    return;
  }
  if (produtos.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && produtos.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final produtosData = getProdutosFirestoreData(produtos, forFieldValue);
  final nestedData = produtosData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = produtos.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getProdutosFirestoreData(
  ProdutosStruct? produtos, [
  bool forFieldValue = false,
]) {
  if (produtos == null) {
    return {};
  }
  final firestoreData = mapToFirestore(produtos.toMap());

  // Add any Firestore field values
  produtos.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProdutosListFirestoreData(
  List<ProdutosStruct>? produtoss,
) =>
    produtoss?.map((e) => getProdutosFirestoreData(e, true)).toList() ?? [];

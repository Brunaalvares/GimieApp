// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class ProdutosStruct extends FFFirebaseStruct {
  ProdutosStruct({
    String? nome,
    String? imageurl,
    double? price,
    String? linkdoProduto,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _nome = nome,
        _imageurl = imageurl,
        _price = price,
        _linkdoProduto = linkdoProduto,
        super(firestoreUtilData);

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "imageurl" field.
  String? _imageurl;
  String get imageurl => _imageurl ?? '';
  set imageurl(String? val) => _imageurl = val;

  bool hasImageurl() => _imageurl != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "linkdoProduto" field.
  String? _linkdoProduto;
  String get linkdoProduto => _linkdoProduto ?? '';
  set linkdoProduto(String? val) => _linkdoProduto = val;

  bool hasLinkdoProduto() => _linkdoProduto != null;

  static ProdutosStruct fromMap(Map<String, dynamic> data) => ProdutosStruct(
        nome: data['nome'] as String?,
        imageurl: data['imageurl'] as String?,
        price: castToType<double>(data['price']),
        linkdoProduto: data['linkdoProduto'] as String?,
      );

  static ProdutosStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProdutosStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'imageurl': _imageurl,
        'price': _price,
        'linkdoProduto': _linkdoProduto,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'imageurl': serializeParam(
          _imageurl,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'linkdoProduto': serializeParam(
          _linkdoProduto,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProdutosStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProdutosStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        imageurl: deserializeParam(
          data['imageurl'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        linkdoProduto: deserializeParam(
          data['linkdoProduto'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProdutosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProdutosStruct &&
        nome == other.nome &&
        imageurl == other.imageurl &&
        price == other.price &&
        linkdoProduto == other.linkdoProduto;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([nome, imageurl, price, linkdoProduto]);
}

ProdutosStruct createProdutosStruct({
  String? nome,
  String? imageurl,
  double? price,
  String? linkdoProduto,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProdutosStruct(
      nome: nome,
      imageurl: imageurl,
      price: price,
      linkdoProduto: linkdoProduto,
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

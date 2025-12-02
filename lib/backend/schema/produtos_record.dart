import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProdutosRecord extends FirestoreRecord {
  ProdutosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;
  String get nome => title;
  bool hasNome() => hasTitle();

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;
  String get imageurl => imageUrl;
  bool hasImageurl() => hasImageUrl();

  // "productUrl" field.
  String? _productUrl;
  String get productUrl => _productUrl ?? '';
  bool hasProductUrl() => _productUrl != null;
  String get linkdoProduto => productUrl;
  bool hasLinkdoProduto() => hasProductUrl();

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _imageUrl = snapshotData['imageUrl'] as String?;
    _productUrl = snapshotData['productUrl'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _uid = snapshotData['uid'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('links');

  static Stream<ProdutosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProdutosRecord.fromSnapshot(s));

  static Future<ProdutosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProdutosRecord.fromSnapshot(s));

  static ProdutosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProdutosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProdutosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProdutosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProdutosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProdutosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProdutosRecordData({
  String? title,
  double? price,
  String? imageUrl,
  String? productUrl,
  String? uid,
  dynamic createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'productUrl': productUrl,
      'createdAt': createdAt,
      'uid': uid,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProdutosRecordDocumentEquality implements Equality<ProdutosRecord> {
  const ProdutosRecordDocumentEquality();

  @override
  bool equals(ProdutosRecord? e1, ProdutosRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.price == e2?.price &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.productUrl == e2?.productUrl &&
        e1?.createdAt == e2?.createdAt &&
        e1?.uid == e2?.uid;
  }

  @override
  int hash(ProdutosRecord? e) => const ListEquality()
      .hash([
        e?.title,
        e?.price,
        e?.imageUrl,
        e?.productUrl,
        e?.createdAt,
        e?.uid
      ]);

  @override
  bool isValidKey(Object? o) => o is ProdutosRecord;
}

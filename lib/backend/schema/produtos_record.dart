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

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  bool hasNome() => _nome != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "imageurl" field.
  String? _imageurl;
  String get imageurl => _imageurl ?? '';
  bool hasImageurl() => _imageurl != null;

  // "linkdoProduto" field.
  String? _linkdoProduto;
  String get linkdoProduto => _linkdoProduto ?? '';
  bool hasLinkdoProduto() => _linkdoProduto != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  void _initializeFields() {
    _nome = snapshotData['nome'] as String?;
    // Accept numbers or numeric strings from API syncs.
    final dynamic rawPrice = snapshotData['price'];
    if (rawPrice is num) {
      _price = rawPrice.toDouble();
    } else if (rawPrice is String) {
      _price = double.tryParse(rawPrice);
    } else {
      _price = null;
    }
    _imageurl = snapshotData['imageurl'] as String?;
    _linkdoProduto = snapshotData['linkdoProduto'] as String?;
    _uid = snapshotData['uid'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('produtos');

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
  String? nome,
  double? price,
  String? imageurl,
  String? linkdoProduto,
  String? uid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nome': nome,
      'price': price,
      'imageurl': imageurl,
      'linkdoProduto': linkdoProduto,
      'uid': uid,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProdutosRecordDocumentEquality implements Equality<ProdutosRecord> {
  const ProdutosRecordDocumentEquality();

  @override
  bool equals(ProdutosRecord? e1, ProdutosRecord? e2) {
    return e1?.nome == e2?.nome &&
        e1?.price == e2?.price &&
        e1?.imageurl == e2?.imageurl &&
        e1?.linkdoProduto == e2?.linkdoProduto &&
        e1?.uid == e2?.uid;
  }

  @override
  int hash(ProdutosRecord? e) => const ListEquality()
      .hash([e?.nome, e?.price, e?.imageurl, e?.linkdoProduto, e?.uid]);

  @override
  bool isValidKey(Object? o) => o is ProdutosRecord;
}

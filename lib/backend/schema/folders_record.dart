import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoldersRecord extends FirestoreRecord {
  FoldersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "ownerUid" field.
  String? _ownerUid;
  String get ownerUid => _ownerUid ?? '';
  bool hasOwnerUid() => _ownerUid != null;

  // "isShared" field.
  bool? _isShared;
  bool get isShared => _isShared ?? false;
  bool hasIsShared() => _isShared != null;

  // "sharedWith" field (list of user uids)
  List<String>? _sharedWith;
  List<String> get sharedWith => _sharedWith ?? const [];
  bool hasSharedWith() => _sharedWith != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _ownerUid = snapshotData['ownerUid'] as String?;
    _isShared = snapshotData['isShared'] as bool?;
    _sharedWith = getDataList<String>(snapshotData['sharedWith']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('folders');

  static Stream<FoldersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoldersRecord.fromSnapshot(s));

  static Future<FoldersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoldersRecord.fromSnapshot(s));

  static FoldersRecord fromSnapshot(DocumentSnapshot snapshot) => FoldersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoldersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FoldersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoldersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoldersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoldersRecordData({
  String? name,
  String? ownerUid,
  bool? isShared,
  List<String>? sharedWith,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'ownerUid': ownerUid,
      'isShared': isShared,
      'sharedWith': sharedWith,
    }.withoutNulls,
  );

  return firestoreData;
}

class FoldersRecordDocumentEquality implements Equality<FoldersRecord> {
  const FoldersRecordDocumentEquality();

  @override
  bool equals(FoldersRecord? e1, FoldersRecord? e2) {
    const listEquality = ListEquality<String>();
    return e1?.name == e2?.name &&
        e1?.ownerUid == e2?.ownerUid &&
        e1?.isShared == e2?.isShared &&
        listEquality.equals(e1?.sharedWith, e2?.sharedWith);
  }

  @override
  int hash(FoldersRecord? e) => const ListEquality().hash([
        e?.name,
        e?.ownerUid,
        e?.isShared,
        e?.sharedWith,
      ]);

  @override
  bool isValidKey(Object? o) => o is FoldersRecord;
}

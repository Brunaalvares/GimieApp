import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FollowsRecord extends FirestoreRecord {
  FollowsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "followerUid" field.
  String? _followerUid;
  String get followerUid => _followerUid ?? '';
  bool hasFollowerUid() => _followerUid != null;

  // "followedUid" field.
  String? _followedUid;
  String get followedUid => _followedUid ?? '';
  bool hasFollowedUid() => _followedUid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _followerUid = snapshotData['followerUid'] as String?;
    _followedUid = snapshotData['followedUid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('follows');

  static Stream<FollowsRecord> getDocument(DocumentReference ref) =>
    ref.snapshots().map((s) => FollowsRecord.fromSnapshot(s));

  static Future<FollowsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FollowsRecord.fromSnapshot(s));

  static FollowsRecord fromSnapshot(DocumentSnapshot snapshot) => FollowsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FollowsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FollowsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FollowsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FollowsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFollowsRecordData({
  String? followerUid,
  String? followedUid,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'followerUid': followerUid,
      'followedUid': followedUid,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class FollowsRecordDocumentEquality implements Equality<FollowsRecord> {
  const FollowsRecordDocumentEquality();

  @override
  bool equals(FollowsRecord? e1, FollowsRecord? e2) {
    return e1?.followerUid == e2?.followerUid &&
        e1?.followedUid == e2?.followedUid &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(FollowsRecord? e) => const ListEquality().hash([
        e?.followerUid,
        e?.followedUid,
        e?.createdTime,
      ]);

  @override
  bool isValidKey(Object? o) => o is FollowsRecord;
}

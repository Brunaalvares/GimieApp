import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.targetUid});

  final String targetUid;

  Stream<bool> _isFollowing() {
    if (currentUserUid.isEmpty) return const Stream<bool>.empty();
    return queryFollowsRecord(
      queryBuilder: (q) => q
          .where('followerUid', isEqualTo: currentUserUid)
          .where('followedUid', isEqualTo: targetUid),
      singleRecord: true,
    ).map((list) => list.isNotEmpty);
  }

  Future<void> _toggle() async {
    final existing = await queryFollowsRecordOnce(
      queryBuilder: (q) => q
          .where('followerUid', isEqualTo: currentUserUid)
          .where('followedUid', isEqualTo: targetUid),
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await existing.first.reference.delete();
    } else {
      await FollowsRecord.collection.add(createFollowsRecordData(
        followerUid: currentUserUid,
        followedUid: targetUid,
        createdTime: DateTime.now(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isFollowing(),
      builder: (context, snapshot) {
        final following = snapshot.data ?? false;
        return ElevatedButton(
          onPressed: _toggle,
          child: Text(following ? 'Deixar de seguir' : 'Seguir'),
        );
      },
    );
  }
}

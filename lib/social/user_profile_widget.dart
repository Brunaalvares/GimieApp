import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import '../components/follow_button.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key, required this.userUid});

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (q) => q.where('uid', isEqualTo: userUid),
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.isEmpty) return const Center(child: Text('Usuário não encontrado'));
        final user = snapshot.data!.first;
        final canView = user.isPublic || currentUserUid == user.uid;
        return Scaffold(
          appBar: AppBar(
            title: Text(user.displayName.isNotEmpty ? user.displayName : 'Perfil'),
          ),
          body: Column(
            children: [
              if (currentUserUid != user.uid)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FollowButton(targetUid: user.uid),
                ),
              Expanded(
                child: canView
                    ? StreamBuilder<List<ProdutosRecord>>(
                        stream: queryProdutosRecord(
                          queryBuilder: (q) => q.where('uid', isEqualTo: user.uid),
                        ),
                        builder: (context, snap) {
                          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                          final items = snap.data!;
                          if (items.isEmpty) return const Center(child: Text('Nenhum item'));
                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final p = items[index];
                              return ListTile(title: Text(p.nome), subtitle: Text(p.linkdoProduto));
                            },
                          );
                        },
                      )
                    : const Center(child: Text('Perfil privado')),
              ),
            ],
          ),
        );
      },
    );
  }
}

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'folders_page_model.dart';
export 'folders_page_model.dart';

class FoldersPageWidget extends StatefulWidget {
  const FoldersPageWidget({super.key});

  static String routeName = 'FoldersPage';
  static String routePath = '/folders';

  @override
  State<FoldersPageWidget> createState() => _FoldersPageWidgetState();
}

class _FoldersPageWidgetState extends State<FoldersPageWidget> {
  late FoldersPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoldersPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _promptCreateFolder() async {
    String name = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova pasta'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nome da pasta'),
          onChanged: (v) => name = v.trim(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (name.isEmpty) return;
              await FoldersRecord.collection.add(createFoldersRecordData(
                name: name,
                ownerUid: currentUserUid,
                isShared: false,
              ));
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Future<void> _renameFolder(FoldersRecord folder) async {
    String name = folder.name;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear pasta'),
        content: TextField(
          controller: TextEditingController(text: name),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nome da pasta'),
          onChanged: (v) => name = v.trim(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (name.isEmpty) return;
              await folder.reference.update({'name': name});
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFolder(FoldersRecord folder) async {
    // Optionally: move products out or delete them; for now keep products with folderId pointing to deleted id
    await folder.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Pastas',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.raleway(
                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.create_new_folder, color: Colors.white),
              onPressed: _promptCreateFolder,
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: StreamBuilder<List<FoldersRecord>>(
            stream: queryFoldersRecord(
              queryBuilder: (q) => q.where('ownerUid', isEqualTo: currentUserUid).orderBy('name'),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final folders = snapshot.data!;
              if (folders.isEmpty) {
                return Center(
                  child: Text('Crie sua primeira pasta', style: FlutterFlowTheme.of(context).bodyMedium),
                );
              }
              return ListView.separated(
                itemCount: folders.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return ListTile(
                    title: Text(folder.name.isNotEmpty ? folder.name : 'Sem nome'),
                    subtitle: Text(folder.isShared ? 'Compartilhada' : 'Privada'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'rename') await _renameFolder(folder);
                        if (value == 'delete') await _deleteFolder(folder);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'rename', child: Text('Renomear')),
                        PopupMenuItem(value: 'delete', child: Text('Excluir')),
                      ],
                    ),
                    onTap: () async {
                      context.pushNamed(FolderPickerWidget.routeName, queryParameters: {
                        'preselectId': folder.reference.id,
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'folder_picker_model.dart';
export 'folder_picker_model.dart';

class FolderPickerWidget extends StatefulWidget {
  const FolderPickerWidget({super.key, this.preselectId});

  static String routeName = 'FolderPicker';
  static String routePath = '/folderPicker';

  final String? preselectId;

  @override
  State<FolderPickerWidget> createState() => _FolderPickerWidgetState();
}

class _FolderPickerWidgetState extends State<FolderPickerWidget> {
  late FolderPickerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FolderPickerModel());
    _model.selectedFolderId = widget.preselectId;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Escolher pasta',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.raleway(
                    fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<FoldersRecord>>(
                  stream: queryFoldersRecord(
                    queryBuilder: (q) => q.where('ownerUid', isEqualTo: currentUserUid).orderBy('name'),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final folders = snapshot.data!;
                    return ListView.builder(
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final selected = _model.selectedFolderId == folder.reference.id;
                        return ListTile(
                          title: Text(folder.name.isNotEmpty ? folder.name : 'Sem nome'),
                          trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
                          onTap: () => setState(() => _model.selectedFolderId = folder.reference.id),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.pop(context, _model.selectedFolderId);
                  },
                  text: 'Selecionar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.copyWith(color: Colors.white),
                    elevation: 0.0,
                    borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

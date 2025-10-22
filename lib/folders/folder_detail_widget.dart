import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'folder_detail_model.dart';
export 'folder_detail_model.dart';

class FolderDetailWidget extends StatefulWidget {
  const FolderDetailWidget({super.key, required this.folderId});

  static String routeName = 'FolderDetail';
  static String routePath = '/folder/:folderId';
  final String folderId;

  @override
  State<FolderDetailWidget> createState() => _FolderDetailWidgetState();
}

class _FolderDetailWidgetState extends State<FolderDetailWidget> {
  late FolderDetailModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FolderDetailModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _promptCreateFolderAndMove() async {
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
              final doc = await FoldersRecord.collection.add(createFoldersRecordData(
                name: name,
                ownerUid: currentUserUid,
                isShared: false,
              ));
              if (mounted) Navigator.pop(context, doc.id);
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: StreamBuilder<FoldersRecord>(
          stream: FoldersRecord.getDocument(FoldersRecord.collection.doc(widget.folderId)),
          builder: (context, snapshot) {
            final name = snapshot.data?.name ?? 'Pasta';
            return Text(name, style: FlutterFlowTheme.of(context).headlineMedium.override(
              font: GoogleFonts.raleway(
                fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
              ),
              color: Colors.white,
            ));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder, color: Colors.white),
            onPressed: () async {
              final newId = await _promptCreateFolderAndMove();
            },
          )
        ],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<ProdutosRecord>>(
          stream: queryProdutosRecord(
            queryBuilder: (q) => q
                .where('uid', isEqualTo: currentUserUid)
                .where('folderId', isEqualTo: widget.folderId),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              return Center(child: Text('Sem itens nessa pasta', style: FlutterFlowTheme.of(context).bodyMedium));
            }
            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [BoxShadow(blurRadius: 8.0, color: Color(0x1A000000), offset: Offset(0,2))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: valueOrDefault<String>(product.imageurl, 'https://via.placeholder.com/300x200.png?text=Sem+imagem'),
                            width: double.infinity,
                            height: 120.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          valueOrDefault<String>(product.nome, 'Produto sem nome'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FlutterFlowTheme.of(context).titleMedium.copyWith(fontSize: 12.0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'R$ ' + formatNumber(product.price, formatType: FormatType.decimal, decimalType: DecimalType.commaDecimal),
                          style: FlutterFlowTheme.of(context).bodyLarge.copyWith(color: FlutterFlowTheme.of(context).primary, fontSize: 13.0),
                        ),
                        const Spacer(),
                        FFButtonWidget(
                          onPressed: () async {
                            final url = product.linkdoProduto;
                            if (url.isNotEmpty) await launchURL(url);
                          },
                          text: 'Shop now',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 34.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                            elevation: 0.0,
                            borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

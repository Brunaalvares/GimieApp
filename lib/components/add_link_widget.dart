import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_link_model.dart';
export 'add_link_model.dart';

/// Crie um card que contenha um campo de texto e um botão de salvar e que
/// apareça quando houver um clique no FloatingActionButton
class AddLinkWidget extends StatefulWidget {
  const AddLinkWidget({super.key});

  @override
  State<AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends State<AddLinkWidget> {
  late AddLinkModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddLinkModel());

    _model.urlaquiTextController ??=
        TextEditingController(text: FFAppState().link);
    _model.urlaquiFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 8.0,
                color: Color(0x33000000),
                offset: Offset(
                  0.0,
                  2.0,
                ),
                spreadRadius: 0.0,
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText(
                    'eubta4ig' /* Adicione novo link */,
                  ),
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.raleway(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
                TextFormField(
                  controller: _model.urlaquiTextController,
                  focusNode: _model.urlaquiFocusNode,
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText(
                      'epzfzvkh' /* Enter your text here */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.roboto(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.roboto(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  validator: _model.urlaquiTextControllerValidator
                      .asValidator(context),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    final urlInput = _model.urlaquiTextController.text.trim();
                    if (urlInput.isEmpty) {
                      showSnackbar(context, 'Informe um link válido');
                      return;
                    }

                    final apiResp = await SalvarLinkCall.call(
                      productUrl: urlInput,
                    );

                    if (!(apiResp.succeeded) || apiResp.jsonBody == null) {
                      showSnackbar(context, 'Falha ao extrair informações');
                      return;
                    }

                    final nome = SalvarLinkCall.nome(apiResp.jsonBody) ?? '';
                    final precoStr =
                        SalvarLinkCall.price(apiResp.jsonBody) ?? '';
                    final imageUrl =
                        SalvarLinkCall.imagem(apiResp.jsonBody) ?? '';
                    final productUrl =
                        SalvarLinkCall.url(apiResp.jsonBody) ?? urlInput;

                    String normalized =
                        precoStr.replaceAll(RegExp(r'[^0-9,\.]'), '');
                    normalized =
                        normalized.replaceAll('.', '').replaceAll(',', '.');
                    final priceDouble = double.tryParse(normalized) ?? 0.0;

                    await ProdutosRecord.collection.doc().set(
                      createProdutosRecordData(
                        price: priceDouble,
                        nome: nome,
                        imageurl: imageUrl,
                        linkdoProduto: productUrl,
                        uid: currentUserUid,
                      ),
                    );

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  text: FFLocalizations.of(context).getText(
                    '80xsetnc' /* Salvar */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.raleway(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontStyle,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart';
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
                FutureBuilder<ApiCallResponse>(
                  future: SalvarLinkCall.call(),
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }
                    final buttonSalvarLinkResponse = snapshot.data!;

                    return FFButtonWidget(
                      onPressed: () async {
                        // Get the URL from the text field instead of hardcoded value
                        final inputUrl = _model.urlaquiTextController.text.trim();
                        
                        if (inputUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Por favor, insira uma URL válida')),
                          );
                          return;
                        }

                        _model.apiResult = await SalvarLinkCall.call(
                          productUrl: inputUrl,
                        );

                        if ((_model.apiResult?.succeeded ?? false)) {
                          // Extract data from API response
                          final scrapedNome = SalvarLinkCall.nome(_model.apiResult?.jsonBody) ?? '';
                          final scrapedPriceStr = SalvarLinkCall.price(_model.apiResult?.jsonBody) ?? '0';
                          final scrapedImageUrl = SalvarLinkCall.imagem(_model.apiResult?.jsonBody) ?? '';
                          final scrapedProductUrl = SalvarLinkCall.url(_model.apiResult?.jsonBody) ?? inputUrl;
                          
                          // Convert price string to double
                          double scrapedPrice = 0.0;
                          try {
                            // Remove currency symbols and parse
                            final cleanPriceStr = scrapedPriceStr.replaceAll(RegExp(r'[^\d.,]'), '');
                            scrapedPrice = double.tryParse(cleanPriceStr.replaceAll(',', '.')) ?? 0.0;
                          } catch (e) {
                            if (kDebugMode) {
                              debugPrint('Error parsing price: $e');
                            }
                          }

                          // Update FFAppState with scraped data
                          FFAppState().update(() {
                            FFAppState().nome = scrapedNome;
                            FFAppState().price = scrapedPrice;
                            FFAppState().imageurl = scrapedImageUrl;
                            FFAppState().linkdoProduto = scrapedProductUrl;
                          });

                          // Save to Firebase with scraped data and current user UID
                          await ProdutosRecord.collection
                              .doc()
                              .set(createProdutosRecordData(
                                price: scrapedPrice,
                                nome: scrapedNome,
                                imageurl: scrapedImageUrl,
                                linkdoProduto: scrapedProductUrl,
                                uid: currentUserUid, // Use authenticated user UID
                              ));
                              
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Produto salvo com sucesso!')),
                          );
                          
                          // Close the dialog/modal
                          Navigator.of(context).pop();
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao processar a URL. Tente novamente.')),
                          );
                        }

                        safeSetState(() {});
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
                    );
                  },
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}

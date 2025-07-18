import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nome_create_model.dart';
export 'nome_create_model.dart';

class NomeCreateWidget extends StatefulWidget {
  const NomeCreateWidget({super.key});

  @override
  State<NomeCreateWidget> createState() => _NomeCreateWidgetState();
}

class _NomeCreateWidgetState extends State<NomeCreateWidget> {
  late NomeCreateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NomeCreateModel());

    _model.nomeCreateTextController ??= TextEditingController();
    _model.nomeCreateFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {
          _model.nomeCreateTextController?.text =
              FFLocalizations.of(context).getText(
            'ajqmmgt7' /* Nome */,
          );
        }));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: 200.0,
          child: TextFormField(
            controller: _model.nomeCreateTextController,
            focusNode: _model.nomeCreateFocusNode,
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
              isDense: true,
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
              hintText: FFLocalizations.of(context).getText(
                'cp11c1oy' /* TextField */,
              ),
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    font: GoogleFonts.roboto(
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).labelMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).labelMedium.fontStyle,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(40.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: EdgeInsets.all(16.0),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
            cursorColor: FlutterFlowTheme.of(context).primaryText,
            validator:
                _model.nomeCreateTextControllerValidator.asValidator(context),
          ),
        ),
      ),
    );
  }
}

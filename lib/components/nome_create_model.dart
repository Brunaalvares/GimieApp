import '/flutter_flow/flutter_flow_util.dart';
import 'nome_create_widget.dart' show NomeCreateWidget;
import 'package:flutter/material.dart';

class NomeCreateModel extends FlutterFlowModel<NomeCreateWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Nome_Create widget.
  FocusNode? nomeCreateFocusNode;
  TextEditingController? nomeCreateTextController;
  String? Function(BuildContext, String?)? nomeCreateTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomeCreateFocusNode?.dispose();
    nomeCreateTextController?.dispose();
  }
}

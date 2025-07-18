import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'add_link_widget.dart' show AddLinkWidget;
import 'package:flutter/material.dart';

class AddLinkModel extends FlutterFlowModel<AddLinkWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for urlaqui widget.
  FocusNode? urlaquiFocusNode;
  TextEditingController? urlaquiTextController;
  String? Function(BuildContext, String?)? urlaquiTextControllerValidator;
  // Stores action output result for [Backend Call - API (salvar link)] action in Button widget.
  ApiCallResponse? apiResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    urlaquiFocusNode?.dispose();
    urlaquiTextController?.dispose();
  }
}

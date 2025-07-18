import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'alteraremail_widget.dart' show AlteraremailWidget;
import 'package:flutter/material.dart';

class AlteraremailModel extends FlutterFlowModel<AlteraremailWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for e-mail widget.
  FocusNode? eMailFocusNode;
  TextEditingController? eMailTextController;
  String? Function(BuildContext, String?)? eMailTextControllerValidator;
  // State field(s) for confirmare-mail widget.
  FocusNode? confirmareMailFocusNode;
  TextEditingController? confirmareMailTextController;
  String? Function(BuildContext, String?)?
      confirmareMailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    eMailFocusNode?.dispose();
    eMailTextController?.dispose();

    confirmareMailFocusNode?.dispose();
    confirmareMailTextController?.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'alterarsenhaup_widget.dart' show AlterarsenhaupWidget;
import 'package:flutter/material.dart';

class AlterarsenhaupModel extends FlutterFlowModel<AlterarsenhaupWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for senhanova widget.
  FocusNode? senhanovaFocusNode;
  TextEditingController? senhanovaTextController;
  late bool senhanovaVisibility;
  String? Function(BuildContext, String?)? senhanovaTextControllerValidator;
  // State field(s) for confirmarsenhanova widget.
  FocusNode? confirmarsenhanovaFocusNode;
  TextEditingController? confirmarsenhanovaTextController;
  late bool confirmarsenhanovaVisibility;
  String? Function(BuildContext, String?)?
      confirmarsenhanovaTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    senhanovaVisibility = false;
    confirmarsenhanovaVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    senhanovaFocusNode?.dispose();
    senhanovaTextController?.dispose();

    confirmarsenhanovaFocusNode?.dispose();
    confirmarsenhanovaTextController?.dispose();
  }
}

import '/components/nome_create_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cadastrese_widget.dart' show CadastreseWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastreseModel extends FlutterFlowModel<CadastreseWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for Nome_create component.
  late NomeCreateModel nomeCreateModel;
  // State field(s) for DatadeNascimento widget.
  FocusNode? datadeNascimentoFocusNode;
  TextEditingController? datadeNascimentoTextController;
  late MaskTextInputFormatter datadeNascimentoMask;
  String? Function(BuildContext, String?)?
      datadeNascimentoTextControllerValidator;
  // State field(s) for emailAddress_Create widget.
  FocusNode? emailAddressCreateFocusNode;
  TextEditingController? emailAddressCreateTextController;
  String? Function(BuildContext, String?)?
      emailAddressCreateTextControllerValidator;
  // State field(s) for password_Create widget.
  FocusNode? passwordCreateFocusNode;
  TextEditingController? passwordCreateTextController;
  late bool passwordCreateVisibility;
  String? Function(BuildContext, String?)?
      passwordCreateTextControllerValidator;

  @override
  void initState(BuildContext context) {
    nomeCreateModel = createModel(context, () => NomeCreateModel());
    passwordCreateVisibility = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    nomeCreateModel.dispose();
    datadeNascimentoFocusNode?.dispose();
    datadeNascimentoTextController?.dispose();

    emailAddressCreateFocusNode?.dispose();
    emailAddressCreateTextController?.dispose();

    passwordCreateFocusNode?.dispose();
    passwordCreateTextController?.dispose();
  }
}

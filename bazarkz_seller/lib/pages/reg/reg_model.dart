import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reg_widget.dart' show RegWidget;
import 'package:flutter/material.dart';

class RegModel extends FlutterFlowModel<RegWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for scrollingContainer widget.
  ScrollController? scrollingContainerScrollController;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<UsersRecord>? admin;

  @override
  void initState(BuildContext context) {
    scrollingContainerScrollController = ScrollController();
    columnController = ScrollController();
  }

  @override
  void dispose() {
    scrollingContainerScrollController?.dispose();
    columnController?.dispose();
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode2?.dispose();
    textController1?.dispose();

    textFieldFocusNode3?.dispose();
    textController2?.dispose();

    textFieldFocusNode4?.dispose();
    textController3?.dispose();
  }
}

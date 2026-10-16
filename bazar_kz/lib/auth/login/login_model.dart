import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for scrollingContainer widget.
  ScrollController? scrollingContainerScrollController;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  late MaskTextInputFormatter textFieldMask;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (token)] action in Button widget.
  ApiCallResponse? token;

  @override
  void initState(BuildContext context) {
    scrollingContainerScrollController = ScrollController();
    columnController = ScrollController();
  }

  @override
  void dispose() {
    scrollingContainerScrollController?.dispose();
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

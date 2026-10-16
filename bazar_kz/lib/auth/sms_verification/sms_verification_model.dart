import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sms_verification_widget.dart' show SmsVerificationWidget;
import 'package:flutter/material.dart';

class SmsVerificationModel extends FlutterFlowModel<SmsVerificationWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Backend Call - API (token)] action in Button widget.
  ApiCallResponse? apiResultinn;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    columnController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}

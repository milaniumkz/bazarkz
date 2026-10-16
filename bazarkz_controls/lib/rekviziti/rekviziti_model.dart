import '/flutter_flow/flutter_flow_util.dart';
import 'rekviziti_widget.dart' show RekvizitiWidget;
import 'package:flutter/material.dart';

class RekvizitiModel extends FlutterFlowModel<RekvizitiWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

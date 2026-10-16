import '/flutter_flow/flutter_flow_util.dart';
import 'lang_widget.dart' show LangWidget;
import 'package:flutter/material.dart';

class LangModel extends FlutterFlowModel<LangWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    columnController?.dispose();
  }
}

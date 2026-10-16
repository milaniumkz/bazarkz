import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'select_lang_widget.dart' show SelectLangWidget;
import 'package:flutter/material.dart';

class SelectLangModel extends FlutterFlowModel<SelectLangWidget> {
  ///  State fields for stateful widgets in this page.

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

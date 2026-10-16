import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'oj_page_widget.dart' show OjPageWidget;
import 'package:flutter/material.dart';

class OjPageModel extends FlutterFlowModel<OjPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for scrollingContainer widget.
  ScrollController? scrollingContainerScrollController;
  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    scrollingContainerScrollController = ScrollController();
    columnController = ScrollController();
  }

  @override
  void dispose() {
    scrollingContainerScrollController?.dispose();
    columnController?.dispose();
  }
}

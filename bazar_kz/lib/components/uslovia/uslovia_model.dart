import '/flutter_flow/flutter_flow_util.dart';
import 'uslovia_widget.dart' show UsloviaWidget;
import 'package:flutter/material.dart';

class UsloviaModel extends FlutterFlowModel<UsloviaWidget> {
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

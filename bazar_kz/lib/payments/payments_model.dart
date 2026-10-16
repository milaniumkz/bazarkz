import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'payments_widget.dart' show PaymentsWidget;
import 'package:flutter/material.dart';

class PaymentsModel extends FlutterFlowModel<PaymentsWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - Read Document] action in payments widget.
  OrderRecord? document;
  // State field(s) for Column widget.
  ScrollController? columnController;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
  }

  @override
  void dispose() {
    instantTimer?.cancel();
    columnController?.dispose();
  }
}

import '/backend/backend.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'order_widget.dart' show OrderWidget;
import 'package:flutter/material.dart';

class OrderModel extends FlutterFlowModel<OrderWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<CartRecord>? cartsOrder;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  OrderRecord? idOrder;
  // Stores action output result for [Custom Action - waitForOrderStatusChange] action in Button widget.
  bool? prov;
  InstantTimer? instantTimer;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    columnController2?.dispose();
    instantTimer?.cancel();
    navbarModel.dispose();
  }
}

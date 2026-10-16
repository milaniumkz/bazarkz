import '/components/counter_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'cart_widget.dart' show CartWidget;
import 'package:flutter/material.dart';

class CartModel extends FlutterFlowModel<CartWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // Models for counter dynamic component.
  late FlutterFlowDynamicModels<CounterModel> counterModels;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    counterModels = FlutterFlowDynamicModels(() => CounterModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    columnController2?.dispose();
    counterModels.dispose();
    navbarModel.dispose();
  }
}

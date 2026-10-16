import '/backend/backend.dart';
import '/components/counter_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pod_sale_widget.dart' show PodSaleWidget;
import 'package:flutter/material.dart';

class PodSaleModel extends FlutterFlowModel<PodSaleWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 0;

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for Column widget.
  ScrollController? columnController3;
  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // Models for counter dynamic component.
  late FlutterFlowDynamicModels<CounterModel> counterModels;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  CartRecord? idCart;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    columnController2 = ScrollController();
    columnController3 = ScrollController();
    counterModels = FlutterFlowDynamicModels(() => CounterModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController1?.dispose();
    tabBarController?.dispose();
    columnController2?.dispose();
    columnController3?.dispose();
    counterModels.dispose();
    navbarModel.dispose();
  }
}

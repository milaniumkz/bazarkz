import '/backend/backend.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<ShopSkidkiRecord> simpleSearchResults = [];
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for Row widget.
  ScrollController? rowController;
  // State field(s) for all widget.

  PagingController<DocumentSnapshot?, ShopSkidkiRecord>? allPagingController;
  Query? allPagingQuery;

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    rowController = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    columnController?.dispose();
    rowController?.dispose();

    allPagingController?.dispose();

    navbarModel.dispose();
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, ShopSkidkiRecord> setAllController(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    allPagingController ??= _createAllController(query, parent);
    if (allPagingQuery != query) {
      allPagingQuery = query;
      allPagingController?.refresh();
    }
    return allPagingController!;
  }

  PagingController<DocumentSnapshot?, ShopSkidkiRecord> _createAllController(
    Query query,
    DocumentReference<Object?>? parent,
  ) {
    final controller = PagingController<DocumentSnapshot?, ShopSkidkiRecord>(
        firstPageKey: null);
    return controller
      ..addPageRequestListener(
        (nextPageMarker) => queryShopSkidkiRecordPage(
          queryBuilder: (_) => allPagingQuery ??= query,
          nextPageMarker: nextPageMarker,
          controller: controller,
          pageSize: 2,
          isStream: false,
        ),
      );
  }
}

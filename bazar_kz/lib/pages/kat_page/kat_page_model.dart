import '/backend/backend.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'kat_page_widget.dart' show KatPageWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class KatPageModel extends FlutterFlowModel<KatPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in katPage widget.
  List<CityRecord>? city;
  // State field(s) for Column widget.
  ScrollController? columnController;
  // State field(s) for all widget.

  PagingController<DocumentSnapshot?, ShopSkidkiRecord>? allPagingController;
  Query? allPagingQuery;

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    columnController = ScrollController();
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    columnController?.dispose();

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
          pageSize: 4,
          isStream: false,
        ),
      );
  }
}

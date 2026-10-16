import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/akcii/akcii_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'sale_model.dart';
export 'sale_model.dart';

class SaleWidget extends StatefulWidget {
  const SaleWidget({
    super.key,
    required this.idPartner,
  });

  final DocumentReference? idPartner;

  static String routeName = 'Sale';
  static String routePath = '/sale';

  @override
  State<SaleWidget> createState() => _SaleWidgetState();
}

class _SaleWidgetState extends State<SaleWidget> {
  late SaleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SaleModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                primary: false,
                controller: _model.columnController,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
                      child: AuthUserStreamWidget(
                        builder: (context) => PagedListView<
                            DocumentSnapshot<Object?>?, ShopSkidkiRecord>(
                          pagingController: _model.setListViewController(
                            ShopSkidkiRecord.collection
                                .where(
                                  'city',
                                  isEqualTo: valueOrDefault(
                                      currentUserDocument?.city, ''),
                                )
                                .where(
                                  'idPartner',
                                  isEqualTo: widget.idPartner,
                                ),
                          ),
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          reverse: false,
                          scrollDirection: Axis.vertical,
                          builderDelegate:
                              PagedChildBuilderDelegate<ShopSkidkiRecord>(
                            // Customize what your widget looks like when it's loading the first page.
                            firstPageProgressIndicatorBuilder: (_) => Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 400.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: SpinKitWanderingCubes(
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ),
                            // Customize what your widget looks like when it's loading another page.
                            newPageProgressIndicatorBuilder: (_) => Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 400.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: SpinKitWanderingCubes(
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ),

                            itemBuilder: (context, _, listViewIndex) {
                              final listViewShopSkidkiRecord = _model
                                  .listViewPagingController!
                                  .itemList![listViewIndex];
                              return AkciiWidget(
                                key: Key(
                                    'Keygkp_${listViewIndex}_of_${_model.listViewPagingController!.itemList!.length}'),
                                image:
                                    listViewShopSkidkiRecord.images.firstOrNull,
                                sale: listViewShopSkidkiRecord.procent,
                                favorit: false,
                                title: listViewShopSkidkiRecord.title,
                                adres: listViewShopSkidkiRecord.adres,
                                insta: listViewShopSkidkiRecord.inst,
                                wh: listViewShopSkidkiRecord.wh,
                                navigator: listViewShopSkidkiRecord.adres,
                                id: listViewShopSkidkiRecord.reference,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

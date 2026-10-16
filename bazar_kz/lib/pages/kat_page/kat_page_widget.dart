import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/akcii/akcii_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/components/select_city/select_city_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'kat_page_model.dart';
export 'kat_page_model.dart';

class KatPageWidget extends StatefulWidget {
  const KatPageWidget({
    super.key,
    required this.title,
  });

  final String? title;

  static String routeName = 'katPage';
  static String routePath = '/katPage';

  @override
  State<KatPageWidget> createState() => _KatPageWidgetState();
}

class _KatPageWidgetState extends State<KatPageWidget> {
  late KatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KatPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (loggedIn != false) {
        if (valueOrDefault(currentUserDocument?.city, '') == '') {
          _model.city = await queryCityRecordOnce();
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            builder: (context) {
              return WebViewAware(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      child: SelectCityWidget(
                        parameter1: _model.city?.map((e) => e.title).toList(),
                        parameter2: FFLocalizations.of(context).getText(
                          'hbbobp7h' /* Выберите город */,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).then((value) => safeSetState(() {}));
        }
      }
    });

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Color(0xFFD9D9D9),
                    borderRadius: 40.0,
                    borderWidth: 2.0,
                    buttonSize: 40.0,
                    fillColor: Colors.white,
                    icon: Icon(
                      Icons.chevron_left,
                      color: Color(0xFFD9D9D9),
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.safePop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.title!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
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
                      child: PagedListView<DocumentSnapshot<Object?>?,
                          ShopSkidkiRecord>(
                        pagingController: _model.setAllController(
                          ShopSkidkiRecord.collection.where(
                            'kat',
                            isEqualTo: widget.title,
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

                          itemBuilder: (context, _, allIndex) {
                            final allShopSkidkiRecord =
                                _model.allPagingController!.itemList![allIndex];
                            return AkciiWidget(
                              key: Key(
                                  'Key2ff_${allIndex}_of_${_model.allPagingController!.itemList!.length}'),
                              image: allShopSkidkiRecord.images.firstOrNull,
                              sale: allShopSkidkiRecord.procent,
                              favorit: false,
                              title: allShopSkidkiRecord.title,
                              adres: allShopSkidkiRecord.adres,
                              insta: allShopSkidkiRecord.inst,
                              wh: allShopSkidkiRecord.wh,
                              navigator: allShopSkidkiRecord.adres,
                              id: allShopSkidkiRecord.reference,
                            );
                          },
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

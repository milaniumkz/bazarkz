import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/akcii/akcii_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/pages/offer_planner/offer_planner_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:octo_image/octo_image.dart';
import 'package:text_search/text_search.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'home';
  static String routePath = '/home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController',
                            Duration(milliseconds: 2000),
                            () async {
                              if (_model.textController.text != '') {
                                await queryShopSkidkiRecordOnce()
                                    .then(
                                      (records) => _model
                                          .simpleSearchResults = TextSearch(
                                        records
                                            .map(
                                              (record) =>
                                                  TextSearchItem.fromTerms(
                                                      record, [
                                                record.title,
                                                record.adres,
                                                record.tel,
                                                record.text,
                                                record.uslovia,
                                                record.osob
                                              ]),
                                            )
                                            .toList(),
                                      )
                                          .search(_model.textController.text)
                                          .map((r) => r.object)
                                          .take(20)
                                          .toList(),
                                    )
                                    .onError((_, __) =>
                                        _model.simpleSearchResults = [])
                                    .whenComplete(() => safeSetState(() {}));
                              }
                            },
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                            hintText: FFLocalizations.of(context).getText(
                              '9z5txsuv' /* Поиск */,
                            ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: Color(0xFFD3D3D3),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD3D3D3),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD3D3D3),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD3D3D3),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD3D3D3),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: _model.textController!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.textController?.clear();
                                      if (_model.textController.text != '') {
                                        await queryShopSkidkiRecordOnce()
                                            .then(
                                              (records) =>
                                                  _model.simpleSearchResults =
                                                      TextSearch(
                                                records
                                                    .map(
                                                      (record) => TextSearchItem
                                                          .fromTerms(record, [
                                                        record.title,
                                                        record.adres,
                                                        record.tel,
                                                        record.text,
                                                        record.uslovia,
                                                        record.osob
                                                      ]),
                                                    )
                                                    .toList(),
                                              )
                                                          .search(_model
                                                              .textController
                                                              .text)
                                                          .map((r) => r.object)
                                                          .take(20)
                                                          .toList(),
                                            )
                                            .onError((_, __) =>
                                                _model.simpleSearchResults = [])
                                            .whenComplete(
                                                () => safeSetState(() {}));
                                      }
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  )
                                : null,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: Colors.black,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                      Icons.filter_alt,
                      color: Color(0xFFD9D9D9),
                      size: 24.0,
                    ),
                    onPressed: () {
                      context.pushNamed(OfferPlannerWidget.routeName);
                    },
                  ),
                ],
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
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Card(
                        color: const Color(0xFFE5F2EC),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.compare_arrows,
                              color: Color(0xFF12664F)),
                          title: Text(
                              FFLocalizations.of(context).getVariableText(
                                ruText: 'План покупок BazarKz',
                                kkText: 'BazarKz сатып алу жоспары',
                                enText: 'BazarKz shopping planner',
                              ),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle:
                              Text(FFLocalizations.of(context).getVariableText(
                            ruText:
                                'Сравните магазины, условия и экономию в своём городе',
                            kkText:
                                'Өз қалаңыздағы дүкендерді, шарттар мен үнемді салыстырыңыз',
                            enText:
                                'Compare local shops, conditions and potential savings',
                          )),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              context.pushNamed(OfferPlannerWidget.routeName),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _model.rowController,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: StreamBuilder<List<KatRecord>>(
                                stream: queryKatRecord(),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: SpinKitWanderingCubes(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 50.0,
                                        ),
                                      ),
                                    );
                                  }
                                  List<KatRecord> listViewKatRecordList =
                                      snapshot.data!;

                                  return ListView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                      5.0,
                                      0,
                                      20.0,
                                      0,
                                    ),
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listViewKatRecordList.length,
                                    itemBuilder: (context, listViewIndex) {
                                      final listViewKatRecord =
                                          listViewKatRecordList[listViewIndex];
                                      return Container(
                                        width: 150.0,
                                        height: 150.0,
                                        constraints: BoxConstraints(
                                          minWidth: 100.0,
                                          minHeight: 100.0,
                                          maxWidth: 300.0,
                                          maxHeight: 300.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              KatPageWidget.routeName,
                                              queryParameters: {
                                                'title': serializeParam(
                                                  listViewKatRecord.title,
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            elevation: 4.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: OctoImage(
                                                    placeholderBuilder: (_) =>
                                                        SizedBox.expand(
                                                      child: Image(
                                                        image: BlurHashImage(
                                                            listViewKatRecord
                                                                .blu),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      listViewKatRecord.image,
                                                    ),
                                                    width: 80.0,
                                                    height: 80.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: AutoSizeText(
                                                      listViewKatRecord.title,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      minFontSize: 8.0,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_model.textController.text == '')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 100.0),
                        child: AuthUserStreamWidget(
                          builder: (context) => PagedListView<
                              DocumentSnapshot<Object?>?, ShopSkidkiRecord>(
                            pagingController: _model.setAllController(
                              ShopSkidkiRecord.collection.where(
                                'city',
                                isEqualTo: valueOrDefault(
                                    currentUserDocument?.city, ''),
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                              ),

                              itemBuilder: (context, _, allIndex) {
                                final allShopSkidkiRecord = _model
                                    .allPagingController!.itemList![allIndex];
                                return AkciiWidget(
                                  key: Key(
                                      'Keygmv_${allIndex}_of_${_model.allPagingController!.itemList!.length}'),
                                  image: valueOrDefault<String>(
                                    allShopSkidkiRecord.images.firstOrNull,
                                    'https://ba-za-r-k-z-np0vyz.web.app/icons/Icon-512.png',
                                  ),
                                  id: allShopSkidkiRecord.reference,
                                  sale: allShopSkidkiRecord.procent,
                                  favorit: allShopSkidkiRecord.fovaritUsers
                                      .contains(currentUserReference),
                                  title: allShopSkidkiRecord.title,
                                  adres: allShopSkidkiRecord.adres,
                                  insta: allShopSkidkiRecord.inst,
                                  wh: allShopSkidkiRecord.wh,
                                  navigator: allShopSkidkiRecord.adres,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    if (_model.textController.text != '')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 100.0),
                        child: Builder(
                          builder: (context) {
                            final results = _model.simpleSearchResults
                                .map((e) => e)
                                .toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: results.length,
                              itemBuilder: (context, resultsIndex) {
                                final resultsItem = results[resultsIndex];
                                return AkciiWidget(
                                  key: Key(
                                      'Keyu1b_${resultsIndex}_of_${results.length}'),
                                  image: resultsItem.images.firstOrNull,
                                  id: resultsItem.reference,
                                  sale: resultsItem.procent,
                                  favorit: true,
                                  title: resultsItem.title,
                                  adres: resultsItem.adres,
                                  insta: resultsItem.inst,
                                  wh: resultsItem.wh,
                                  navigator: resultsItem.adres,
                                );
                              },
                            );
                          },
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

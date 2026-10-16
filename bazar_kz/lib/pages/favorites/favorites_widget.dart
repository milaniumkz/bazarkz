import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/akcii/akcii_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'favorites_model.dart';
export 'favorites_model.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  static String routeName = 'favorites';
  static String routePath = '/favorites';

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  late FavoritesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavoritesModel());

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
                      FFLocalizations.of(context).getText(
                        '3uyr5c1d' /* Избранные */,
                      ),
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
          child: Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Stack(
              alignment: AlignmentDirectional(0.0, 1.0),
              children: [
                SingleChildScrollView(
                  primary: false,
                  controller: _model.columnController1,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 100.0),
                        child: AuthUserStreamWidget(
                          builder: (context) => Builder(
                            builder: (context) {
                              final results =
                                  (currentUserDocument?.favorites.toList() ??
                                          [])
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
                                  return StreamBuilder<ShopSkidkiRecord>(
                                    stream: ShopSkidkiRecord.getDocument(
                                        resultsItem),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: SpinKitWanderingCubes(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              size: 50.0,
                                            ),
                                          ),
                                        );
                                      }

                                      final columnShopSkidkiRecord =
                                          snapshot.data!;

                                      return SingleChildScrollView(
                                        primary: false,
                                        controller: _model.columnController2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            AkciiWidget(
                                              key: Key(
                                                  'Keywm8_${resultsIndex}_of_${results.length}'),
                                              image: columnShopSkidkiRecord
                                                  .images.firstOrNull,
                                              sale: columnShopSkidkiRecord
                                                  .reting
                                                  .toString(),
                                              favorit: false,
                                              title:
                                                  columnShopSkidkiRecord.title,
                                              adres:
                                                  columnShopSkidkiRecord.adres,
                                              id: columnShopSkidkiRecord
                                                  .reference,
                                              insta:
                                                  columnShopSkidkiRecord.inst,
                                              wh: columnShopSkidkiRecord.wh,
                                              navigator:
                                                  columnShopSkidkiRecord.adres,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

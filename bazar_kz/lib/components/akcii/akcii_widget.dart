import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'akcii_model.dart';
export 'akcii_model.dart';

class AkciiWidget extends StatefulWidget {
  const AkciiWidget({
    super.key,
    this.image,
    this.id,
    this.sale,
    required this.favorit,
    this.title,
    this.adres,
    required this.insta,
    required this.wh,
    required this.navigator,
  });

  final String? image;
  final DocumentReference? id;
  final String? sale;
  final bool? favorit;
  final String? title;
  final String? adres;
  final String? insta;
  final String? wh;
  final String? navigator;

  @override
  State<AkciiWidget> createState() => _AkciiWidgetState();
}

class _AkciiWidgetState extends State<AkciiWidget> {
  late AkciiModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AkciiModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          PodSaleWidget.routeName,
                          queryParameters: {
                            'idSale': serializeParam(
                              widget.id,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: Image.network(
                          widget.image!,
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: MediaQuery.sizeOf(context).width * 0.9,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
                      child: ToggleIcon(
                        onPressed: () async {
                          safeSetState(
                            () => FFAppState().favorites.contains(widget.id)
                                ? FFAppState().removeFromFavorites(widget.id!)
                                : FFAppState().addToFavorites(widget.id!),
                          );
                          if (FFAppState().favorites.contains(widget.id) ==
                              true) {
                            await Future.delayed(
                              Duration(
                                milliseconds: 1000,
                              ),
                            );
                            FFAppState().removeFromFavorites(widget.id!);
                            safeSetState(() {});
                          } else {
                            await Future.delayed(
                              Duration(
                                milliseconds: 1000,
                              ),
                            );
                            FFAppState().addToFavorites(widget.id!);
                            safeSetState(() {});
                          }
                        },
                        value: FFAppState().favorites.contains(widget.id),
                        onIcon: Icon(
                          Icons.favorite_sharp,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 25.0,
                        ),
                        offIcon: Icon(
                          Icons.favorite_border,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          widget.title!,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          widget.adres,
                          'Не указан',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .bodyMediumIsCustom,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

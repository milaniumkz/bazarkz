import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'payments_model.dart';
export 'payments_model.dart';

class PaymentsWidget extends StatefulWidget {
  const PaymentsWidget({
    super.key,
    this.id,
  });

  final DocumentReference? id;

  static String routeName = 'payments';
  static String routePath = '/payments';

  @override
  State<PaymentsWidget> createState() => _PaymentsWidgetState();
}

class _PaymentsWidgetState extends State<PaymentsWidget> {
  late PaymentsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 1000),
        callback: (timer) async {
          _model.document = await OrderRecord.getDocumentOnce(widget.id!);
          if (_model.document?.status == 1) {
            await actions.deleteCartByUserId(
              currentUserReference!.id,
            );

            await currentUserReference!.update({
              ...mapToFirestore(
                {
                  'cart': FieldValue.delete(),
                },
              ),
            });
            FFAppState().summa = 0.0;
            safeSetState(() {});

            context.goNamed(HistoryWidget.routeName);

            _model.instantTimer?.cancel();
          }
        },
        startImmediately: true,
      );
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
    context.watch<FFAppState>();

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
          child: SingleChildScrollView(
            primary: false,
            controller: _model.columnController,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlutterFlowWebView(
                  content:
                      'https://milanium.kz/ApiPay/payPayless.html?id=${widget.id?.id}',
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  verticalScroll: false,
                  horizontalScroll: false,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      '4wo69zw1' /* Перенаправление в магазин........ */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          fontSize: 17.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

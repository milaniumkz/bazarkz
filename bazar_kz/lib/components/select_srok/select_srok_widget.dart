import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'select_srok_model.dart';
export 'select_srok_model.dart';

class SelectSrokWidget extends StatefulWidget {
  const SelectSrokWidget({super.key});

  @override
  State<SelectSrokWidget> createState() => _SelectSrokWidgetState();
}

class _SelectSrokWidgetState extends State<SelectSrokWidget> {
  late SelectSrokModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectSrokModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: AuthUserStreamWidget(
        builder: (context) => FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController ??=
              FormFieldController<String>(
            _model.dropDownValue ??= '',
          ),
          options: List<String>.from(['1', '3', '6', '12']),
          optionLabels: [
            FFLocalizations.of(context).getText(
              '5ci46023' /* 1 месяц */,
            ),
            FFLocalizations.of(context).getText(
              'r3n8k7xs' /* 3 месяца */,
            ),
            FFLocalizations.of(context).getText(
              'jjfii7mm' /* 6 месяцев */,
            ),
            FFLocalizations.of(context).getText(
              'cv7xbivc' /* 1 год */,
            )
          ],
          onChanged: (val) async {
            safeSetState(() => _model.dropDownValue = val);
            await currentUserReference!.update(createUsersRecordData(
              city: _model.dropDownValue,
            ));
            Navigator.pop(context);
          },
          width: 300.0,
          height: 50.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                letterSpacing: 0.0,
                useGoogleFonts:
                    !FlutterFlowTheme.of(context).bodyMediumIsCustom,
              ),
          hintText: FFLocalizations.of(context).getText(
            'w0n7asse' /* Выберите срок */,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isOverButton: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      ),
    );
  }
}

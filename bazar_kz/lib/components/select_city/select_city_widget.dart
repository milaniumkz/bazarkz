import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'select_city_model.dart';
export 'select_city_model.dart';

class SelectCityWidget extends StatefulWidget {
  const SelectCityWidget({
    super.key,
    this.parameter1,
    this.parameter2,
  });

  final List<String>? parameter1;
  final String? parameter2;

  @override
  State<SelectCityWidget> createState() => _SelectCityWidgetState();
}

class _SelectCityWidgetState extends State<SelectCityWidget> {
  late SelectCityModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectCityModel());

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
        builder: (context) => StreamBuilder<List<CityRecord>>(
          stream: queryCityRecord(),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: SpinKitWanderingCubes(
                    color: FlutterFlowTheme.of(context).primary,
                    size: 50.0,
                  ),
                ),
              );
            }
            List<CityRecord> dropDownCityRecordList = snapshot.data!;

            return FlutterFlowDropDown<String>(
              controller: _model.dropDownValueController ??=
                  FormFieldController<String>(
                _model.dropDownValue ??=
                    valueOrDefault(currentUserDocument?.city, ''),
              ),
              options: dropDownCityRecordList.map((e) => e.title).toList(),
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
                'eeay1ft9' /* Выберите город */,
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
            );
          },
        ),
      ),
    );
  }
}

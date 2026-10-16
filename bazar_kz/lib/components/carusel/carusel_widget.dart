import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'carusel_model.dart';
export 'carusel_model.dart';

class CaruselWidget extends StatefulWidget {
  const CaruselWidget({
    super.key,
    this.parameter1,
    this.parameter2,
    this.parameter3,
    this.parameter4,
    this.parameter5,
  });

  final String? parameter1;
  final String? parameter2;
  final String? parameter3;
  final String? parameter4;
  final String? parameter5;

  @override
  State<CaruselWidget> createState() => _CaruselWidgetState();
}

class _CaruselWidgetState extends State<CaruselWidget> {
  late CaruselModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CaruselModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 200.0,
      child: CarouselSlider(
        items: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: FlutterFlowExpandedImageView(
                    image: Image.network(
                      widget.parameter1!,
                      fit: BoxFit.contain,
                    ),
                    allowRotation: false,
                    tag: widget.parameter1!,
                    useHeroAnimation: true,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.parameter1!,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.parameter1!,
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: FlutterFlowExpandedImageView(
                    image: Image.network(
                      widget.parameter2!,
                      fit: BoxFit.contain,
                    ),
                    allowRotation: false,
                    tag: widget.parameter2!,
                    useHeroAnimation: true,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.parameter2!,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.parameter2!,
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: FlutterFlowExpandedImageView(
                    image: Image.network(
                      widget.parameter3!,
                      fit: BoxFit.contain,
                    ),
                    allowRotation: false,
                    tag: widget.parameter3!,
                    useHeroAnimation: true,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.parameter3!,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.parameter3!,
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: FlutterFlowExpandedImageView(
                    image: Image.network(
                      widget.parameter4!,
                      fit: BoxFit.contain,
                    ),
                    allowRotation: false,
                    tag: widget.parameter4!,
                    useHeroAnimation: true,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.parameter4!,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.parameter4!,
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: FlutterFlowExpandedImageView(
                    image: Image.network(
                      widget.parameter5!,
                      fit: BoxFit.contain,
                    ),
                    allowRotation: false,
                    tag: widget.parameter5!,
                    useHeroAnimation: true,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.parameter5!,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.parameter5!,
                  width: 300.0,
                  height: 200.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
        carouselController: _model.carouselController ??=
            CarouselSliderController(),
        options: CarouselOptions(
          initialPage: 1,
          viewportFraction: 1.0,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          enableInfiniteScroll: true,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayInterval: Duration(milliseconds: (800 + 4000)),
          autoPlayCurve: Curves.linear,
          pauseAutoPlayInFiniteScroll: true,
          onPageChanged: (index, _) => _model.carouselCurrentIndex = index,
        ),
      ),
    );
  }
}

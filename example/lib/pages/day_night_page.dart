import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/utils/celestial.dart';
import 'package:example/utils/twilight.dart';
import 'package:example/utils/twilight_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class DayNightPage extends StatefulWidget {
  const DayNightPage({Key? key}) : super(key: key);

  @override
  DayNightPageState createState() => DayNightPageState();
}

class DayNightPageState extends State<DayNightPage> {
  final controller = MapController(
    location: LatLng(35.68, 51.41),
    zoom: 4,
  );

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  void _gotoDefault() {
    controller.center = LatLng(35.68, 51.41);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var civil = Twilight.civil(DateTime.now().toUtc());
    var sun = getSunLocation(DateTime.now().toUtc());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day & Night Map'),
      ),
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          var big = transformer.constraints.biggest;
          final sunPosition = transformer.toOffset(sun);

          var polyline =
              civil.polyline.map((e) => transformer.toOffset(e)).toList();

          if (civil.delta < 0) {
            var p1 = transformer.toOffset(LatLng(90, -180));
            var p2 = transformer.toOffset(LatLng(90, 180));

            polyline.insert(0, p1);
            polyline.add(p2);
          } else {
            var p1 = transformer.toOffset(LatLng(-90, -180));
            var p2 = transformer.toOffset(LatLng(-90, 180));

            if (p1.dy > big.height) {
              p1 = Offset(p1.dx, big.height);
            }
            if (p2.dy > big.height) {
              p2 = Offset(p2.dx, big.height);
            }

            polyline.insert(0, p1);
            polyline.add(p2);
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  CustomPaint(painter: TwilightPainter(polyline)),
                  Positioned(
                    left: sunPosition.dx - 24,
                    top: sunPosition.dy - 24,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.sunny,
                      color: Colors.amber,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

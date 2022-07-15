import 'dart:ui';

import 'package:latlng/latlng.dart';

class Polyline {
  const Polyline({
    required this.data,
    required this.paint,
    this.offset,
    this.onPaint,
  });

  /// The points which make the polyline.
  final List<LatLng> data;

  /// Style of the polyline.
  final Paint paint;

  /// Offset of the polyline in pixels when rendered on screen.
  final double? offset;

  final Function(
    Canvas canvas,
    Polyline polyline,
    List<Offset> points,
  )? onPaint;
}

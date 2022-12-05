import 'dart:ui';

import 'package:latlng/latlng.dart';

/// Defines a polyline to draw on the map.
class Polyline {
  /// Creates an instance of [Polyline].
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

  /// Used to draw the polyline in custom mode. E.g. drawing a color gradient.
  ///
  /// If this function callback is provided, the default rendering will be disabled.
  final Function(
    Canvas canvas,
    Polyline polyline,
    List<Offset> points,
  )? onPaint;
}

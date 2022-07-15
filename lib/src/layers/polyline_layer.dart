import 'package:flutter/widgets.dart';
import 'package:map/src/polyline.dart';
import 'package:map/src/transformer.dart';
import 'package:map/src/map_layout.dart';

/// Draws a layer of polylines on the [MapLayout].
class PolylineLayer extends StatelessWidget {
  /// Default constructor,
  const PolylineLayer({
    Key? key,
    required this.transformer,
    required this.polylines,
  }) : super(key: key);

  /// The transformer from parent.
  final MapTransformer transformer;

  /// Polylines to display on the map.
  final List<Polyline> polylines;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PolylinesCustomPainter(
        transformer: transformer,
        polylines: polylines,
      ),
    );
  }
}

class _PolylinesCustomPainter extends CustomPainter {
  const _PolylinesCustomPainter({
    required this.transformer,
    required this.polylines,
  });

  final MapTransformer transformer;
  final List<Polyline> polylines;

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in polylines) {
      final paint = p.paint;
      final points = transformer.toOffsetMany(p.data).toList();

      final onPaint = p.onPaint;
      if (onPaint != null) {
        onPaint.call(canvas, p, points);
      } else {
        for (int i = 0; i < points.length - 1; i++) {
          final a = points[i];
          final b = points[i + 1];

          canvas.drawLine(
            a,
            b,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

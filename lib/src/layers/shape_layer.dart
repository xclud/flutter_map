part of '../../map.dart';

/// Raster or Vector data for a specific [z, x, y] coordinate.
///
/// This class must be a child of [MapLayout].
class ShapeLayer extends StatefulWidget {
  /// Main constructor.
  const ShapeLayer({
    Key? key,
    required this.transformer,
    required this.shapes,
  }) : super(key: key);

  /// The transformer from parent.
  final MapTransformer transformer;

  /// Shapes to display on the Map.
  final List<Shape> shapes;

  @override
  State<StatefulWidget> createState() => _ShapeLayerState();
}

/// Represents a polygon.
class Shape {
  /// Constructor.
  const Shape({
    required this.points,
    required this.painter,
    this.metadata,
  });

  /// Geo coordinates.
  final List<LatLng> points;

  /// Optional metadata that comes with the shape.
  final Object? metadata;

  /// Painter.
  final void Function(Canvas canvas, List<Offset> points, Object? metadata)
      painter;
}

class _ShapeLayerState extends State<ShapeLayer> {
  @override
  void didChangeDependencies() {
    final map = context.findAncestorWidgetOfExactType<MapLayout>();

    if (map == null) {
      throw Exception('TileLayer must be used inside a MapLayout.');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShapePainter(
        transformer: widget.transformer,
        shapes: widget.shapes,
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  const _ShapePainter({
    required this.transformer,
    required this.shapes,
  });

  final MapTransformer transformer;
  final List<Shape> shapes;

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final points = transformer.toOffsetMany(shape.points).toList();

      shape.painter(canvas, points, shape.metadata);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

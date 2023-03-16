part of map;

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
      var points = transformer.toOffsetMany(p.data).toList();

      if (p.offset != null && p.offset != 0) {
        points = _offsetPoints(points, p.offset!);
      }

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

void _forEachPair<T>(List<T> list, Function(T a, T b) callback) {
  if (list.isEmpty) {
    return;
  }
  for (var i = 1, l = list.length; i < l; i++) {
    callback(list[i - 1], list[i]);
  }
}

/// Find the coefficients (a,b) of a line of equation y = a.x + b,
/// or the constant x for vertical lines
/// Return null if there's no equation possible
class _LineEquation {
  const _LineEquation({this.x, this.a, this.b});

  final double? x;
  final double? a;
  final double? b;
}

class _OffsetSegment {
  const _OffsetSegment({
    required this.offsetAngle,
    required this.original,
    required this.offset,
  });
  final double offsetAngle;
  final List<Offset> original;
  final List<Offset> offset;
}

_LineEquation? _lineEquation(Offset pt1, Offset pt2) {
  if (pt1.dx == pt2.dx) {
    return pt1.dy == pt2.dy ? null : _LineEquation(x: pt1.dx);
  }

  var a = (pt2.dy - pt1.dy) / (pt2.dx - pt1.dx);
  return _LineEquation(
    a: a,
    b: pt1.dy - a * pt1.dx,
  );
}

/// Return the intersection point of two lines defined by two points each
/// Return null when there's no unique intersection
Offset? _intersection(Offset l1a, Offset l1b, Offset l2a, Offset l2b) {
  var line1 = _lineEquation(l1a, l1b);
  var line2 = _lineEquation(l2a, l2b);

  if (line1 == null || line2 == null) {
    return null;
  }

  if (line1.x != null) {
    return line2.x != null
        ? null
        : Offset(
            line1.x!,
            line2.a! * line1.x! + line2.b!,
          );
  }
  if (line2.x != null) {
    return Offset(
      line2.x!,
      line1.a! * line2.x! + line1.b!,
    );
  }

  if (line1.a == line2.a) {
    return null;
  }

  var x = (line2.b! - line1.b!) / (line1.a! - line2.a!);
  return Offset(
    x,
    line1.a! * x + line1.b!,
  );
}

Offset _translatePoint(Offset pt, double dist, double heading) {
  return Offset(
    pt.dx + dist * cos(heading),
    pt.dy + dist * sin(heading),
  );
}

List<_OffsetSegment> _offsetPointLine(List<Offset> points, double distance) {
  var offsetSegments = <_OffsetSegment>[];

  _forEachPair<Offset>(points, (a, b) {
    if (a.dx == b.dx && a.dy == b.dy) {
      return;
    }

    // angles in (-PI, PI]
    var segmentAngle = atan2(a.dy - b.dy, a.dx - b.dx);
    var offsetAngle = segmentAngle - pi / 2;

    offsetSegments.add(_OffsetSegment(offsetAngle: offsetAngle, original: [
      a,
      b
    ], offset: [
      _translatePoint(a, distance, offsetAngle),
      _translatePoint(b, distance, offsetAngle)
    ]));
  });

  return offsetSegments;
}

List<Offset> _offsetPoints(List<Offset> points, double offset) {
  var offsetSegments = _offsetPointLine(points, offset);
  return _joinLineSegments(offsetSegments, offset);
}

/// Join 2 line segments defined by 2 points each with a circular arc

List<Offset> _joinSegments(
  _OffsetSegment s1,
  _OffsetSegment s2,
  double offset,
) {
  // TO DO: different join styles
  return _circularArc(s1, s2, offset)
      .where((x) {
        return x != null;
      })
      .map((e) => e!)
      .toList();
}

List<Offset> _joinLineSegments(List<_OffsetSegment> segments, double offset) {
  var joinedPoints = <Offset>[];

  if (segments.isNotEmpty) {
    var first = segments.first;
    var last = segments.last;

    joinedPoints.add(first.offset[0]);
    _forEachPair<_OffsetSegment>(segments, (s1, s2) {
      joinedPoints = [...joinedPoints, ..._joinSegments(s1, s2, offset)];
    });
    joinedPoints.add(last.offset[1]);
  }

  return joinedPoints;
}

Offset _segmentAsVector(List<Offset> s) {
  return Offset(
    s[1].dx - s[0].dx,
    s[1].dy - s[0].dy,
  );
}

double _getSignedAngle(List<Offset> s1, List<Offset> s2) {
  final a = _segmentAsVector(s1);
  final b = _segmentAsVector(s2);
  return atan2(a.dx * b.dy - a.dy * b.dx, a.dx * b.dx + a.dy * b.dy);
}

/// Interpolates points between two offset segments in a circular form
List<Offset?> _circularArc(
    _OffsetSegment s1, _OffsetSegment s2, double distance) {
  // if the segments are the same angle,
  // there should be a single join point
  if (s1.offsetAngle == s2.offsetAngle) {
    return [s1.offset[1]];
  }

  final signedAngle = _getSignedAngle(s1.offset, s2.offset);
  // for inner angles, just find the offset segments intersection
  if ((signedAngle * distance > 0) &&
      (signedAngle * _getSignedAngle(s1.offset, [s1.offset[0], s2.offset[1]]) >
          0)) {
    return [
      _intersection(s1.offset[0], s1.offset[1], s2.offset[0], s2.offset[1])
    ];
  }

  // draws a circular arc with R = offset distance, C = original meeting point
  var points = <Offset>[];
  var center = s1.original[1];
  // ensure angles go in the anti-clockwise direction
  var rightOffset = distance > 0;
  var startAngle = rightOffset ? s2.offsetAngle : s1.offsetAngle;
  var endAngle = rightOffset ? s1.offsetAngle : s2.offsetAngle;
  // and that the end angle is bigger than the start angle
  if (endAngle < startAngle) {
    endAngle += pi * 2;
  }
  var step = pi / 8;
  for (var alpha = startAngle; alpha < endAngle; alpha += step) {
    points.add(_translatePoint(center, distance, alpha));
  }
  points.add(_translatePoint(center, distance, endAngle));

  return rightOffset ? points.reversed.toList() : points;
}

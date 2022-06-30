@Deprecated(
    'Please visit https://pub.dev/packages/vt and https://pub.dev/packages/cartography')
enum GeometryType {
  point,
  lineString,
  polygon,
  multiPoint,
  multiLineString,
  multiPolygon,
  unknown,
}
@Deprecated(
    'Please visit https://pub.dev/packages/vt and https://pub.dev/packages/cartography')

abstract class Geometry {
  factory Geometry.point({required List<double> coordinates}) = PointGeometry;
  factory Geometry.multiPoint({required List<List<double>> coordinates}) =
      MultiPointGeometry;
  factory Geometry.lineString({required List<List<double>> coordinates}) =
      LineStringGeometry;
  factory Geometry.multiLineString({
    required List<List<List<double>>> coordinates,
  }) = MultiLineStringGeometry;
  factory Geometry.polygon({required List<List<List<double>>> coordinates}) =
      PolygonGeometry;
  factory Geometry.multiPolygon({
    required List<List<List<List<double>>>> coordinates,
  }) = MultiPolygonGeometry;

  Geometry._();
}

/// Point Geometry.
@Deprecated(
    'Please visit https://pub.dev/packages/vt and https://pub.dev/packages/cartography')
class PointGeometry extends Geometry {
  PointGeometry({
    required this.coordinates,
  }) : super._();
  List<double> coordinates;
}

class MultiPointGeometry extends Geometry {
  MultiPointGeometry({
    required this.coordinates,
  }) : super._();
  List<List<double>> coordinates;
}

class LineStringGeometry extends Geometry {
  LineStringGeometry({
    required this.coordinates,
  }) : super._();
  List<List<double>> coordinates;
}

class MultiLineStringGeometry extends Geometry {
  MultiLineStringGeometry({
    required this.coordinates,
  }) : super._();
  List<List<List<double>>> coordinates;
}

class PolygonGeometry extends Geometry {
  PolygonGeometry({
    required this.coordinates,
  }) : super._();
  List<List<List<double>>> coordinates;
}

class MultiPolygonGeometry extends Geometry {
  MultiPolygonGeometry({
    required this.coordinates,
  }) : super._();
  List<List<List<List<double>>>>? coordinates;
}

enum GeometryType {
  point,
  lineString,
  polygon,
  multiPoint,
  multiLineString,
  multiPolygon,
  unknown,
}

abstract class Geometry {
  factory Geometry.point({required List<double> coordinates}) = PointGeometry;
  factory Geometry.multiPoint({required List<List<double>> coordinates}) =
      MultiPointGeometry;
  factory Geometry.lineString({required List<List<double>> coordinates}) =
      LineStringGeometry;
  factory Geometry.multiLineString(
          {required List<List<List<double>>> coordinates}) =
      MultiLineStringGeometry;
  factory Geometry.polygon({required List<List<List<double>>> coordinates}) =
      PolygonGeometry;
  factory Geometry.multiPolygon(
          {required List<List<List<List<double>>>> coordinates}) =
      MultiPolygonGeometry;

  Geometry._();
}

/// Point Geometry.
class PointGeometry extends Geometry {
  List<double> coordinates;

  PointGeometry({
    required this.coordinates,
  }) : super._();
}

class MultiPointGeometry extends Geometry {
  List<List<double>> coordinates;

  MultiPointGeometry({
    required this.coordinates,
  }) : super._();
}

class LineStringGeometry extends Geometry {
  List<List<double>> coordinates;

  LineStringGeometry({
    required this.coordinates,
  }) : super._();
}

class MultiLineStringGeometry extends Geometry {
  List<List<List<double>>> coordinates;

  MultiLineStringGeometry({
    required this.coordinates,
  }) : super._();
}

class PolygonGeometry extends Geometry {
  List<List<List<double>>> coordinates;

  PolygonGeometry({
    required this.coordinates,
  }) : super._();
}

class MultiPolygonGeometry extends Geometry {
  List<List<List<List<double>>>>? coordinates;

  MultiPolygonGeometry({
    required this.coordinates,
  }) : super._();
}

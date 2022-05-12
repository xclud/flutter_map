import 'package:map/src/vt/geometry.dart';
import 'package:map/src/vt/value.dart';

class Feature {
  const Feature({
    required this.id,
    required this.geometry,
    required this.properties,
  });

  final int id;

  final Geometry geometry;
  final Map<String, Value> properties;
}

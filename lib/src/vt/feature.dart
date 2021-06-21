import 'geometry.dart';
import 'value.dart';

class Feature {
  final int id;

  final Geometry geometry;
  final Map<String, Value> properties;

  const Feature({
    required this.id,
    required this.geometry,
    required this.properties,
  });
}

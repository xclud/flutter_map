import 'geometry.dart';
import 'value.dart';

class Feature {
  final int id;
  final int extent;

  final Geometry geometry;
  final List<Map<String, Value>> properties;

  const Feature({
    required this.id,
    required this.extent,
    required this.geometry,
    required this.properties,
  });
}

import 'feature.dart';
import 'value.dart';

class Layer {
  final String name;
  final int extent;
  final int version;
  final List<String> keys;
  final List<Value> values;
  final List<Feature> features;

  const Layer({
    required this.name,
    required this.extent,
    required this.version,
    required this.keys,
    required this.values,
    required this.features,
  });
}

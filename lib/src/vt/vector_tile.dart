import 'dart:typed_data';

import 'generated/vector_tile.pb.dart' as raw;
import 'feature.dart';
import 'geometry.dart';
import 'layer.dart';
import 'value.dart';

export 'feature.dart';
export 'geometry.dart';
export 'layer.dart';
export 'value.dart';

class VectorTile {
  final List<Layer> layers;

  const VectorTile({
    required this.layers,
  });

  /// decodes the given bytes (`.mvt`/`.pbf`) to a [VectorTile]
  factory VectorTile.fromBytes({required Uint8List bytes}) {
    final tile = raw.VectorTile.fromBuffer(bytes);
    List<Layer> layers = tile.layers.map(_createLayer).toList();
    return VectorTile(layers: layers);
  }
}

Layer _createLayer(raw.Layer layer) {
  List<Value> values = layer.values.map((value) {
    return Value(
      stringValue: value.hasStringValue() ? value.stringValue : null,
      floatValue: value.hasFloatValue() ? value.floatValue : null,
      doubleValue: value.hasDoubleValue() ? value.doubleValue : null,
      intValue: value.hasIntValue() ? value.intValue : null,
      uintValue: value.hasUintValue() ? value.uintValue : null,
      sintValue: value.hasSintValue() ? value.sintValue : null,
      boolValue: value.hasBoolValue() ? value.boolValue : null,
    );
  }).toList();
  List<Feature> features = layer.features.map((feature) {
    return Feature(
      id: feature.id,
      tags: feature.tags,
      type: _convertGeomType(feature.type),
      geometries: feature.geometry,
      keys: layer.keys,
      values: values,
    );
  }).toList();

  return Layer(
    name: layer.name,
    extent: layer.extent,
    version: layer.version,
    keys: layer.keys,
    values: values,
    features: features,
  );
}

GeometryType _convertGeomType(raw.GeomType rawGeomType) {
  switch (rawGeomType) {
    case raw.GeomType.POINT:
      return GeometryType.point;
    case raw.GeomType.LINESTRING:
      return GeometryType.lineString;
    case raw.GeomType.POLYGON:
      return GeometryType.polygon;
    default:
      return GeometryType.unknown;
  }
}

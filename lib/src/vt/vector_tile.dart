import 'dart:typed_data';

import 'package:map/src/vt/generated/vector_tile.pb.dart' as raw;
import 'package:map/src/vt/feature.dart';
import 'package:map/src/vt/geometry.dart';
import 'package:map/src/vt/layer.dart';
import 'package:map/src/vt/value.dart';

export 'feature.dart';
export 'geometry.dart';
export 'layer.dart';
export 'value.dart';

//const int _moveTo = 1;
const int _lineTo = 2;
const int _closePath = 7;

@Deprecated(
    'Please visit https://pub.dev/packages/vt and https://pub.dev/packages/cartography')
class VectorTile {
  const VectorTile({
    required this.layers,
  });

  /// decodes the given bytes (`.mvt`/`.pbf`) to a [VectorTile]
  factory VectorTile.fromBytes({required Uint8List bytes}) {
    final tile = raw.VectorTile.fromBuffer(bytes);
    List<Layer> layers = tile.layers.map(_decodeLayer).toList();
    return VectorTile(layers: layers);
  }

  final List<Layer> layers;
}

Layer _decodeLayer(raw.Layer layer) {
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
    final type = _convertGeomType(feature.type);
    final geometry =
        _decodeGeometry(feature.geometry, type, layer.extent.toDouble());
    final properties = _decodeProperties(layer.keys, values, feature.tags);

    return Feature(
      id: feature.id.toInt(),
      geometry: geometry!,
      properties: properties,
    );
  }).toList();

  return Layer(
    name: layer.name,
    extent: layer.extent,
    version: layer.version,
    keys: layer.keys.toList(),
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

Geometry? _decodeGeometry(
  List<int> geometries,
  GeometryType type,
  double extent,
) {
  switch (type) {
    case GeometryType.point:
      List<List<int>> coords = _decodePoint(geometries);

      if (coords.length == 1) {
        return Geometry.point(
          coordinates: coords[0].map((intVal) => intVal / extent).toList(),
        );
      }

      return Geometry.multiPoint(
        coordinates:
            coords.map((coord) => coord.map((intVal) => intVal / extent))
                as List<List<double>>,
      );

    case GeometryType.lineString:
      List<List<List<int>>> coords = _decodeLineString(geometries);

      if (coords.length == 1) {
        return Geometry.lineString(
          coordinates: coords[0]
              .map(
                (point) => point.map((intVal) => intVal / extent).toList(),
              )
              .toList(),
        );
      }

      return Geometry.multiLineString(
        coordinates: coords
            .map(
              (line) => line
                  .map(
                    (point) => point.map((intVal) => intVal / extent).toList(),
                  )
                  .toList(),
            )
            .toList(),
      );

    case GeometryType.polygon:
      List<List<List<List<int>>>> coords = _decodePolygon(geometries);

      if (coords.length == 1) {
        return Geometry.polygon(
          coordinates: coords[0]
              .map(
                (ring) => ring
                    .map(
                      (point) =>
                          point.map((intVal) => intVal / extent).toList(),
                    )
                    .toList(),
              )
              .toList(),
        );
      }

      return Geometry.multiPolygon(
        coordinates: coords
            .map(
              (polygon) => polygon
                  .map(
                    (ring) => ring
                        .map(
                          (point) =>
                              point.map((intVal) => intVal / extent).toList(),
                        )
                        .toList(),
                  )
                  .toList(),
            )
            .toList(),
      );
    default:
      return null;
  }
}

/// Decode Point geometry
///
/// @docs: https://github.com/mapbox/vector-tile-spec/tree/master/2.1#4342-point-geometry-type
List<List<int>> _decodePoint(List<int> geometries) {
  int length = 0;
  int commandId = 0;
  int x = 0;
  int y = 0;
  bool isX = true;
  List<List<int>> coords = [];
  List<int> point = [];

  for (var commandInt in geometries) {
    if (length <= 0) {
      _Command command = _Command.fromInt(commandInt);

      commandId = command.id;
      length = command.count;
    } else if (commandId != _closePath) {
      if (isX) {
        x += _Command.zigZagDecode(commandInt);
        point.add(x);
        isX = false;
      } else {
        y += _Command.zigZagDecode(commandInt);
        point.add(y);
        length -= 1;
        isX = true;
      }
    }

    if (length <= 0) {
      coords.add(point);
      point = [];
    }
  }

  return coords;
}

/// Decode LineString geometry
///
/// @docs: https://github.com/mapbox/vector-tile-spec/tree/master/2.1#4343-linestring-geometry-type
List<List<List<int>>> _decodeLineString(List<int> geometries) {
  int length = 0;
  int commandId = 0;
  int x = 0;
  int y = 0;
  bool isX = true;
  List<List<List<int>>> coords = [];
  List<List<int>> ring = [];

  for (var commandInt in geometries) {
    if (length <= 0) {
      _Command command = _Command.fromInt(commandInt);

      commandId = command.id;
      length = command.count;
    } else if (commandId != _closePath) {
      if (isX) {
        x += _Command.zigZagDecode(commandInt);
        isX = false;
      } else {
        y += _Command.zigZagDecode(commandInt);
        ring.add([x, y]);
        length -= 1;
        isX = true;
      }
    }

    if (length <= 0 && commandId == _lineTo) {
      coords.add(ring);
      ring = [];
    }
  }

  return coords;
}

/// Decode polygon geometry
///
/// @docs: https://github.com/mapbox/vector-tile-spec/tree/master/2.1#4344-polygon-geometry-type
List<List<List<List<int>>>> _decodePolygon(List<int> geometries) {
  int length = 0;
  int commandId = 0;
  int x = 0;
  int y = 0;
  bool isX = true;
  List<List<List<List<int>>>> polygons = [];
  List<List<List<int>>> coords = [];
  List<List<int>> ring = [];

  for (var commandInt in geometries) {
    if (length <= 0 || commandId == _closePath) {
      _Command command = _Command.fromInt(commandInt);

      commandId = command.id;
      length = command.count;

      if (commandId == _closePath) {
        coords.add(ring.reversed.toList());
        ring = [];
      }
    } else if (commandId != _closePath) {
      if (isX) {
        x += _Command.zigZagDecode(commandInt);
        isX = false;
      } else {
        y += _Command.zigZagDecode(commandInt);
        ring.add([x, y]);
        length -= 1;
        isX = true;
      }
    }

    if (length <= 0 && commandId == _lineTo) {
      if (coords.isNotEmpty && _isCCW(ring)) {
        polygons.add(coords);
        coords = [];
      }
    }
  }

  polygons.add(coords);
  return polygons;
}

/// Gets properties from feature tags and key/value pairs got from parent layer
Map<String, Value> _decodeProperties(
  List<String> keys,
  List<Value> values,
  List<int> tags,
) {
  int length = tags.length;
  Map<String, Value> properties = {};

  for (int i = 0; i < length; i = i + 2) {
    final keyIndex = tags[i];
    final valueIndex = tags[i + 1];

    final key = keys[keyIndex];
    final value = values[valueIndex];

    properties[key] = value;
  }

  return properties;
}

/// Command and its utils
class _Command {
  const _Command({required this.id, required this.count});

  const _Command.fromInt(int command)
      : this(
          id: command & 0x7,
          count: command >> 3,
        );

  final int id;
  final int count;

  // static int zigZagEncode(int val) {
  //   return (val << 1) ^ (val >> 31);
  // }

  static int zigZagDecode(int parameterInteger) {
    return ((parameterInteger >> 1) ^ (-(parameterInteger & 1)));
  }
}

/// Implements https://en.wikipedia.org/wiki/Shoelace_formula
bool _isCCW(List<List<int>> ring) {
  int i = -1;
  int ccw = ring.sublist(1, ring.length - 1).fold(0, (sum, point) {
    i++;
    return sum + (point[0] - ring[i][0]) * (point[1] + ring[i][1]);
  });

  return ccw < 0;
}

import 'package:fixnum/fixnum.dart';
import 'geometry.dart';
import 'value.dart';

//const int _moveTo = 1;
const int _lineTo = 2;
const int _closePath = 7;

class Feature {
  Int64 id;
  List<int> tags;
  GeometryType? type;
  List<int>? geometries;

  // Decoded properties
  Geometry? _geometry;
  List<Map<String, Value>>? _properties;

  // Additional
  List<String>? keys;
  List<Value>? values;

  Feature({
    required this.id,
    required this.tags,
    this.type,
    this.geometries,
    this.keys,
    this.values,
  });

  /// [Feature] geometry data.
  ///
  /// You must explicit cast Geometry type after got returned data:
  ///    ```
  ///     var geometry = feature.geometry;
  ///     var coordinates = (geometry as GeometryPoint).coordinates;
  ///    ```
  Geometry? get geometry {
    if (this._geometry != null) {
      return this._geometry;
    }

    final _ = this.properties;

    switch (this.type) {
      case GeometryType.point:
        List<List<int>> coords = _decodePoint(this.geometries!);

        if (coords.length <= 1) {
          this._geometry = Geometry.point(
              coordinates:
                  coords[0].map((intVal) => intVal.toDouble()).toList());
          break;
        }

        this._geometry = Geometry.multiPoint(
            coordinates:
                coords.map((coord) => coord.map((intVal) => intVal.toDouble()))
                    as List<List<double>>);
        break;
      case GeometryType.lineString:
        List<List<List<int>>> coords = _decodeLineString(this.geometries!);

        if (coords.length <= 1) {
          this._geometry = Geometry.lineString(
              coordinates: coords[0]
                  .map(
                    (point) =>
                        point.map((intVal) => intVal.toDouble()).toList(),
                  )
                  .toList());
          break;
        }

        this._geometry = Geometry.multiLineString(
            coordinates: coords
                .map((line) => line
                    .map(
                      (point) =>
                          point.map((intVal) => intVal.toDouble()).toList(),
                    )
                    .toList())
                .toList());
        break;
      case GeometryType.polygon:
        List<List<List<List<int>>>> coords = _decodePolygon(this.geometries!);

        if (coords.length <= 1) {
          this._geometry = Geometry.polygon(
              coordinates: coords[0]
                  .map((ring) => ring
                      .map(
                        (point) =>
                            point.map((intVal) => intVal.toDouble()).toList(),
                      )
                      .toList())
                  .toList());
          break;
        }

        this._geometry = Geometry.multiPolygon(
            coordinates: coords
                .map((polygon) => polygon
                    .map((ring) => ring
                        .map(
                          (point) =>
                              point.map((intVal) => intVal.toDouble()).toList(),
                        )
                        .toList())
                    .toList())
                .toList());
        break;
      default:
        print('only implement point type');
    }

    return this._geometry;
  }

  /// Gets properties from feature tags and key/value pairs got from parent layer
  List<Map<String, Value>> get properties {
    if (this._properties != null) {
      return this._properties!;
    }
    int length = this.tags.length;
    List<Map<String, Value>> properties = [];

    for (int i = 0; i < length;) {
      int keyIndex = this.tags[i];
      int valueIndex = this.tags[i + 1];

      properties.add({
        this.keys![keyIndex]: this.values![valueIndex],
      });
      i = i + 2;
    }

    this._properties = properties;
    return _properties!;
  }
}

/// Command and its utils
class _Command {
  final int id;
  final int count;

  const _Command({required this.id, required this.count});

  const _Command.fromInt(int command)
      : this(
          id: command & 0x7,
          count: command >> 3,
        );

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

  geometries.forEach((commandInt) {
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
  });

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

  geometries.forEach((commandInt) {
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
  });

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

  geometries.forEach((commandInt) {
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
  });

  polygons.add(coords);
  return polygons;
}

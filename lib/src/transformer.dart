import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:latlng/latlng.dart';
import 'package:map/src/controller.dart';

/// Helps with converting map coordinates to XY coordinates and vice-versa.
class MapTransformer {
  MapTransformer._internal({
    required this.controller,
    required this.constraints,
    required this.tileSize,
  })  : _centerX = constraints.biggest.width / 2.0,
        _centerY = constraints.biggest.height / 2.0;

  /// Map controller which is used in [MapLayoutBuilder].
  final MapController controller;

  /// The size of the tiles. This is usually equal to the size of the .png file taken from the server. E.g. 256 for a 256x256 pixels or 512 for a 512x512 pixels.
  final int tileSize;

  /// Constraints of the current widget.
  final BoxConstraints constraints;

  final double _centerX;
  final double _centerY;

  /// Converts XY coordinates to [LatLng].
  LatLng toLatLng(Offset position) {
    final scale = pow(2.0, controller.zoom);
    final norm = controller.projection.toTileIndex(controller.center);

    final dx = _centerX - position.dx;
    final dy = _centerY - position.dy;

    final x = norm.x - (dx / tileSize) / scale;
    final y = norm.y - (dy / tileSize) / scale;

    final mon = TileIndex(x, y);
    final location = controller.projection.toLatLng(mon);

    return location;
  }

  /// Converts [LatLng] coordinates to XY [Offset].
  Offset toOffset(LatLng location) {
    final scale = pow(2.0, controller.zoom);

    final norm = controller.projection.toTileIndex(controller.center);

    final l = controller.projection.toTileIndex(location);

    final dx = l.x - norm.x;
    final dy = l.y - norm.y;

    final s = tileSize * scale;

    return Offset(_centerX + dx * s, _centerY + dy * s);
  }

  /// Converts many XY coordinates to [LatLng].
  Iterable<LatLng> toLatLngMany(Iterable<Offset> positions) {
    return positions.map((e) => toLatLng(e));
  }

  /// Converts many [LatLng] coordinates to XY [Offset].
  Iterable<Offset> toOffsetMany(Iterable<LatLng> locations) {
    return locations.map((e) => toOffset(e));
  }

  /// In-place zoom.
  void setZoomInPlace(double zoom, Offset position) {
    final before = toLatLng(position);

    controller.zoom = zoom;

    final after = toOffset(before);

    final diffx = position.dx - after.dx;
    final diffy = position.dy - after.dy;

    drag(diffx, diffy);
  }

  /// Drags the map by [dx], [dy] pixels.
  void drag(double dx, double dy) {
    var scale = pow(2.0, controller.zoom);
    final norm = controller.projection.toTileIndex(controller.center);

    final x = norm.x - (dx / tileSize) / scale;
    final y = norm.y - (dy / tileSize) / scale;

    final mon = TileIndex(x, y);

    controller.center = controller.projection.toLatLng(mon);
  }

  /// Gets the current viewport in pixels.
  Rect getViewport() {
    final scale = pow(2.0, controller.zoom).toDouble();
    final size = scale * tileSize;
    final centerPixels = toOffset(const LatLng(0, 0));

    return Rect.fromCenter(center: centerPixels, width: size, height: size);
  }
}

/// For internal use.
MapTransformer createMapTransformer({
  required MapController controller,
  required BoxConstraints constraints,
  required int tileSize,
}) {
  return MapTransformer._internal(
    controller: controller,
    constraints: constraints,
    tileSize: tileSize,
  );
}

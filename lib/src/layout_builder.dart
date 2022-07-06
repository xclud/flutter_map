import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

/// Builds a widget tree that can depend on the parent widget's size and
/// providers a map coordinates transfom helper to its children.
///
/// Similar to the [LayoutBuilder] widget.
class MapLayoutBuilder extends InheritedWidget {
  /// The default constructor.
  MapLayoutBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.tileSize = 256,
  }) : super(
            key: key,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final transformer = MapTransformer._internal(
                controller: controller,
                constraints: constraints,
                tileSize: tileSize,
              );
              return builder.call(context, transformer);
            }));

  /// The data from the closest [MapLayoutBuilder] instance that encloses the given context.
  static MapLayoutBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MapLayoutBuilder>();
  }

  /// Size of each tile in pixels. Most tile servers provide tiles of 256 pixels.
  final double tileSize;

  /// Map controller which is used in [MapLayoutBuilder].
  final MapController controller;

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must not return null.
  final Widget Function(
    BuildContext context,
    MapTransformer transformer,
  ) builder;

  @override
  bool updateShouldNotify(covariant MapLayoutBuilder oldWidget) {
    return oldWidget.tileSize != tileSize ||
        oldWidget.controller != controller ||
        oldWidget.builder != builder;
  }
}

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

  final double tileSize;

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

  Iterable<LatLng> toLatLngMany(Iterable<Offset> positions) {
    return positions.map((e) => toLatLng(e));
  }

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

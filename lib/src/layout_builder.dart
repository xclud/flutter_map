import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

/// Builds a widget tree that can depend on the parent widget's size and
/// providers a map coordinates transfom helper to its children.
///
/// Similar to the [LayoutBuilder] widget.
class MapLayoutBuilder extends StatelessWidget {
  /// The default constructor.
  const MapLayoutBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.tileSize = 256,
  }) : super(key: key);

  final double tileSize;

  /// Map controller which is used in [Map].
  final MapController controller;

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must not return null.
  final Widget Function(
    BuildContext context,
    MapTransformer transformer,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final transformer = MapTransformer._internal(
      controller: controller,
      constraints: constraints,
      tileSize: tileSize,
    );
    return builder.call(context, transformer);
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

  /// Map controller which is used in [Map].
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
    final mon = TileIndex(norm.x, norm.y);

    final dx = _centerX - position.dx;
    final dy = _centerY - position.dy;

    mon.x -= (dx / tileSize) / scale;
    mon.y -= (dy / tileSize) / scale;

    final location = controller.projection.toLatLng(mon);

    return location;
  }

  /// Converts [LatLng] coordinates to XY [Offset].
  Offset toOffset(LatLng location) {
    final scale = pow(2.0, controller.zoom);

    final norm = controller.projection.toTileIndex(controller.center);
    final mon = TileIndex(norm.x, norm.y);

    final l = controller.projection.toTileIndex(location);

    final dx = l.x - mon.x;
    final dy = l.y - mon.y;

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
    final mon = controller.projection.toTileIndex(controller.center);

    mon.x -= (dx / tileSize) / scale;
    mon.y -= (dy / tileSize) / scale;

    controller.center = controller.projection.toLatLng(mon);
  }
}

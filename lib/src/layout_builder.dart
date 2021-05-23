import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapLayoutBuilder extends StatelessWidget {
  MapLayoutBuilder({required this.controller, required this.builder});

  final MapController controller;
  final MapLayoutWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final transformer = MapTransformer._internal(
      controller: controller,
      constraints: constraints,
    );
    return builder.call(context, transformer);
  }
}

class MapTransformer {
  MapTransformer._internal({
    required this.controller,
    required this.constraints,
  })  : _width = constraints.biggest.width,
        _height = constraints.biggest.height;

  final MapController controller;
  final BoxConstraints constraints;
  final double _width;
  final double _height;

  LatLng fromXYCoordsToLatLng(Offset position) {
    final norm = controller.projection.fromLngLatToTileIndex(controller.center);
    final mon = TileIndex(norm.x, norm.y);

    final centerX = _width / 2.0;
    final centerY = _height / 2.0;

    final dx = centerX - position.dx;
    final dy = centerY - position.dy;

    final scale = pow(2.0, controller.zoom);

    mon.x -= (dx / controller.tileSize) / scale;
    mon.y -= (dy / controller.tileSize) / scale;

    final location = controller.projection.fromTileIndexToLngLat(mon);

    return location;
  }
}

typedef MapLayoutWidgetBuilder = Widget Function(
    BuildContext context, MapTransformer transformer);

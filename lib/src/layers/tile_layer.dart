import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:latlng/latlng.dart';
import 'package:map/src/layout_builder.dart';
import 'package:map/src/map.dart';

/// Raster or Vector data for a specific [z, x, y] coordinate.
///
/// This class must be a child of [MapLayoutBuilder].
class TileLayer extends StatefulWidget {
  /// Main constructor.
  const TileLayer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Map tile widget builder.
  final Widget Function(BuildContext context, int x, int y, int z) builder;

  @override
  State<StatefulWidget> createState() => _TileLayerState();
}

class _TileLayerState extends State<TileLayer> {
  late double _tileSize;
  late MapController _controller;

  @override
  void didChangeDependencies() {
    final map = context.findAncestorWidgetOfExactType<MapLayoutBuilder>();

    if (map == null) {
      throw Exception('TileLayer must be used inside a MapLayoutBuilder.');
    }

    _tileSize = map.tileSize;
    _controller = map.controller;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final size = constraints.biggest;
    final projection = _controller.projection;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final centerX = screenWidth / 2.0;
    final centerY = screenHeight / 2.0;

    final scale = pow(2.0, _controller.zoom);

    final norm = projection.toTileIndex(_controller.center);
    final ttl =
        TileIndex(norm.x * _tileSize * scale, norm.y * _tileSize * scale);

    final fixedZoom = (_controller.zoom + 0.0000001).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (_controller.zoom % 1));
    final tileSizeScaled = _tileSize * scaleValue;

    final numTilesX = (screenWidth / _tileSize / 2.0).ceil();
    final numTilesY = (screenHeight / _tileSize / 2.0).ceil();

    final children = <Widget>[];

    for (int i = centerTileIndexX - numTilesX;
        i <= centerTileIndexX + numTilesX;
        i++) {
      for (int j = centerTileIndexY - numTilesY;
          j <= centerTileIndexY + numTilesY;
          j++) {
        final ox = (i * tileSizeScaled) + centerX - ttl.x;
        final oy = (j * tileSizeScaled) + centerY - ttl.y;

        final child = Positioned(
          width: tileSizeScaled.ceilToDouble(),
          height: tileSizeScaled.ceilToDouble(),
          left: ox.floorToDouble(),
          top: oy.floorToDouble(),
          child: widget.builder
              .call(context, i, j, (_controller.zoom + 0.0000001).floor()),
        );

        children.add(child);
      }
    }

    final stack = Stack(children: children);

    return stack;
  }
}

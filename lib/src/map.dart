part of '../map.dart';

/// Raster or Vector data for a specific [z, x, y] coordinate.
///
/// This class must be a child of [MapLayout].
@Deprecated('Please use [TileLayer] instead')
class Map extends StatefulWidget {
  /// Main constructor.
  const Map({
    Key? key,
    required this.builder,
    required this.controller,
    this.tileSize = 256,
  }) : super(key: key);

  /// Map controller.
  final MapController controller;

  /// Map tile widget builder.
  final Widget Function(BuildContext context, int x, int y, int z) builder;

  /// Size of each tile in pixels. Most tile servers provide tiles of 256 pixels.
  final double tileSize;

  @override
  State<StatefulWidget> createState() => _MapState();
}

@Deprecated('Please use [TileLayer] instead')
class _MapState extends State<Map> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final controller = widget.controller;
    final tileSize = widget.tileSize;
    final size = constraints.biggest;
    final projection = controller.projection;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final centerX = screenWidth / 2.0;
    final centerY = screenHeight / 2.0;

    final scale = pow(2.0, controller.zoom);

    final norm = projection.toTileIndex(controller.center);
    final ttl = TileIndex(norm.x * tileSize * scale, norm.y * tileSize * scale);

    final fixedZoom = (controller.zoom + 0.0000001).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (controller.zoom % 1));
    final tileSizeScaled = tileSize * scaleValue;
    //final numGrids = pow(2.0, controller._zoom).floor();

    final numTilesX = (screenWidth / tileSize / 2.0).ceil();
    final numTilesY = (screenHeight / tileSize / 2.0).ceil();

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
              .call(context, i, j, (controller.zoom + 0.0000001).floor()),
        );

        children.add(child);
      }
    }

    final stack = Stack(children: children);

    return stack;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'provider.dart';

class Map extends StatefulWidget {
  final MapProvider provider;
  final MapController controller;
  final void Function() onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function(TapUpDetails) onTapUp;
  final void Function() onLongPress;
  final void Function() onLongPressUp;

  Map(
      {Key key,
      this.provider: const GoogleMapProvider(),
      @required this.controller,
      this.onTap,
      this.onTapDown,
      this.onTapUp,
      this.onLongPress,
      this.onLongPressUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final controller = widget.controller;
    final tileSize = controller.tileSize;
    final size = constraints.biggest;
    final projection = controller._projection;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final centerX = screenWidth / 2.0;
    final centerY = screenHeight / 2.0;

    final scale = pow(2.0, controller._zoom);

    final norm = projection.fromLngLatToTileIndex(controller._location);
    final ttl = TileIndex(norm.x * tileSize * scale, norm.y * tileSize * scale);

    final fixedZoom = (controller._zoom + 0.0000001).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (controller._zoom % 1));
    final tileSizeScaled = tileSize * scaleValue;
    final numGrids = pow(2.0, controller._zoom).floor();

    final numTilesX = (screenWidth / tileSize / 2.0).ceil();
    final numTilesY = (screenHeight / tileSize / 2.0).ceil();

    final children = <Widget>[];

    for (int i = centerTileIndexX - numTilesX;
        i <= centerTileIndexX + numTilesX;
        i++) {
      for (int j = centerTileIndexY - numTilesY;
          j <= centerTileIndexY + numTilesY;
          j++) {
        if (i < 0 || i >= numGrids || j < 0 || j >= numGrids) {
          continue;
        }

        final ox = (i * tileSizeScaled) + centerX - ttl.x;
        final oy = (j * tileSizeScaled) + centerY - ttl.y;

        final tile = widget.provider
            .getTile(i, j, (controller._zoom + 0.0000001).floor());

        final child = Positioned(
          width: tileSizeScaled.ceilToDouble(),
          height: tileSizeScaled.ceilToDouble(),
          left: ox.floorToDouble(),
          top: oy.floorToDouble(),
          child: Container(
            color: Colors.grey,
            child: Image(
              image: tile,
              fit: BoxFit.fill,
            ),
          ),
        );

        children.add(child);
      }
    }

    final stack = Stack(children: children);

    final gesture = GestureDetector(
      child: stack,
      onDoubleTap: _onDoubleTap,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onTap: widget.onTap,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      onLongPress: widget.onLongPress,
      onLongPressUp: widget.onLongPressUp,
    );

    return gesture;
  }

  void _onDoubleTap() {
    widget.controller.zoom += 0.5;
  }

  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      widget.controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      widget.controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      widget.controller.drag(diff.dx, diff.dy);
    }
  }
}

class MapController extends ChangeNotifier {
  LatLng _location;
  double _zoom;
  double tileSize;

  final _projection = EPSG4326();

  MapController({
    @required LatLng location,
    double zoom: 14,
    this.tileSize: 256,
  }) {
    _location = location;
    _zoom = zoom;
  }

  void drag(double dx, double dy) {
    var scale = pow(2.0, _zoom);
    final mon = _projection.fromLngLatToTileIndex(_location);

    mon.x -= (dx / tileSize) / scale;
    mon.y -= (dy / tileSize) / scale;

    location = _projection.fromTileIndexToLngLat(mon);
  }

  LatLng get location {
    return _location;
  }

  set location(LatLng location) {
    _location = location;
    notifyListeners();
  }

  double get zoom {
    return _zoom;
  }

  set zoom(double zoom) {
    _zoom = zoom;
    notifyListeners();
  }
}

// class _MapPainter extends CustomPainter
// {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // TODO: implement paint
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'projection.dart';
import 'provider.dart';
import 'tile_index.dart';

class Map extends StatefulWidget {
  final LatLng initialLocation;
  final double inititialZoom;
  final Projection projection;
  final MapProvider provider;
  final int tileSize;
  final void Function() onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function(TapUpDetails) onTapUp;
  final void Function() onLongPress;
  final void Function() onLongPressUp;

  Map(
      {Key key,
      @required this.initialLocation,
      this.inititialZoom: 14.0,
      this.projection: const EPSG4326(),
      this.provider: const GoogleMapProvider(),
      this.tileSize: 256,
      this.onTap,
      this.onTapDown,
      this.onTapUp,
      this.onLongPress,
      this.onLongPressUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new MapState();
}

class MapState extends State<Map> {
  LatLng _location;
  double _zoom = 14.0;

  @override
  void initState() {
    _location = widget.initialLocation;
    _zoom = widget.inititialZoom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: _build);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final tileSize = widget.tileSize;
    final size = constraints.biggest;

    final screenWidth = size.width;
    final screenHeight = size.height;

    final centerX = screenWidth / 2.0;
    final centerY = screenHeight / 2.0;

    final scale = pow(2.0, _zoom);

    final norm = widget.projection.fromLngLatToTileIndex(_location);
    final ttl =
        new TileIndex(norm.x * tileSize * scale, norm.y * tileSize * scale);

    final fixedZoom = (_zoom + 0.0000001).toInt();
    final fixedPowZoom = pow(2, fixedZoom);

    final centerTileIndexX = (norm.x * fixedPowZoom).floor();
    final centerTileIndexY = (norm.y * fixedPowZoom).floor();

    final scaleValue = pow(2.0, (_zoom % 1));
    final tileSizeScaled = tileSize * scaleValue;
    final numGrids = pow(2.0, _zoom).floor();

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

        final tile = widget.provider.getTile(i, j, (_zoom + 0.0000001).floor());

        final child = new Positioned(
          width: tileSizeScaled,
          height: tileSizeScaled,
          left: ox,
          top: oy,
          child: new Container(
            color: Colors.grey,
            child: new Image(
              image: tile,
              fit: BoxFit.fill,
            ),
          ),
        );

        children.add(child);
      }
    }

    final stack = new Stack(children: children);

    final gesture = new GestureDetector(
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
    setState(() {
      _zoom += 0.5;
    });
  }

  Offset dragStart;
  double scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    dragStart = details.focalPoint;
    scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - scaleStart;
    scaleStart = details.scale;

    if (scaleDiff > 0) {
      setState(() {
        _zoom += 0.02;
      });
    } else if (scaleDiff < 0) {
      setState(() {
        _zoom -= 0.02;
      });
    } else {
      final now = details.focalPoint;
      final diff = now - dragStart;
      dragStart = now;
      drag(diff.dx, diff.dy);
    }
  }

  void drag(double dx, double dy) {
    var tileSize = widget.tileSize;

    var scale = pow(2.0, _zoom);
    final mon = widget.projection.fromLngLatToTileIndex(_location);

    mon.x -= (dx / tileSize) / scale;
    mon.y -= (dy / tileSize) / scale;

    setState(() {
      _location = widget.projection.fromTileIndexToLngLat(mon);
    });
  }

  LatLng get location {
    return _location;
  }

  set location(LatLng location) {
    setState(() {
      _location = location;
    });
  }

  double get zoom {
    return _zoom;
  }

  set zoom(double zoom) {
    setState(() {
      _zoom = zoom;
    });
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

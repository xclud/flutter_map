import 'dart:math';

import 'package:latlong/latlong.dart';
import 'tile_index.dart';

abstract class Projection {
  const Projection();

  TileIndex fromLngLatToTileIndex(LatLng location);
  LatLng fromTileIndexToLngLat(TileIndex tile);

  TileIndex fromLngLatToTileIndexWithZoom(LatLng location, double zoom) {
    var ret = fromLngLatToTileIndex(location);

    var mapSize = pow(2.0, zoom);

    return new TileIndex(ret.x * mapSize, ret.y * mapSize);
  }

  LatLng fromTileIndexToLngLatWithZoom(TileIndex tile, double zoom) {
    var mapSize = pow(2, zoom);

    final x = tile.x / mapSize;
    final y = tile.y / mapSize;

    final normalTile = new TileIndex(x, y);

    return fromTileIndexToLngLat(normalTile);
  }
}

class EPSG4326 extends Projection {
  static final EPSG4326 instance = EPSG4326();

  const EPSG4326();

  @override
  TileIndex fromLngLatToTileIndex(LatLng location) {
    final lng = location.longitude;
    final lat = location.latitude;

    double x = (lng + 180.0) / 360.0;
    double sinLatitude = sin(lat * pi / 180.0);
    double y =
        0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);

    return new TileIndex(x, y);
  }

  @override
  LatLng fromTileIndexToLngLat(TileIndex tile) {
    final x = tile.x;
    final y = tile.y;

    final xx = x - 0.5;
    final yy = 0.5 - y;

    final lat = 90.0 - 360.0 * atan(exp(-yy * 2.0 * pi)) / pi;
    final lng = 360.0 * xx;

    return LatLng(lat, lng);
  }
}

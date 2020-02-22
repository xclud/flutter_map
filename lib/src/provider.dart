import 'package:flutter/material.dart';

abstract class MapProvider {
  const MapProvider();

  ImageProvider getTile(int x, int y, int z);
}

class OsmProvider extends MapProvider {
  const OsmProvider();

  @override
  ImageProvider getTile(int x, int y, int z) {
    return NetworkImage('http://a.tile.osm.org/$z/$x/$y.png');
  }
}

class GoogleMapProvider extends MapProvider {
  const GoogleMapProvider();

  @override
  ImageProvider getTile(int x, int y, int z) {
    return NetworkImage(
        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425');
  }
}

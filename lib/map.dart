/// [![pub package](https://img.shields.io/pub/v/map)](https://pub.dartlang.org/packages/map)
/// [![likes](https://img.shields.io/pub/likes/map)](https://pub.dartlang.org/packages/map/score)
/// [![points](https://img.shields.io/pub/points/map)](https://pub.dartlang.org/packages/map/score)
/// [![popularity](https://img.shields.io/pub/popularity/map)](https://pub.dartlang.org/packages/map/score)
/// [![license](https://img.shields.io/github/license/xclud/flutter_map)](https://pub.dartlang.org/packages/map)
/// [![stars](https://img.shields.io/github/stars/xclud/flutter_map)](https://github.com/xclud/flutter_map/stargazers)
/// [![forks](https://img.shields.io/github/forks/xclud/flutter_map)](https://github.com/xclud/flutter_map/network/members)
/// [![sdk version](https://badgen.net/pub/sdk-version/map)](https://pub.dartlang.org/packages/map)
///
/// Lightweight `Map` widget for flutter supporting different projections including EPSG4326/Mercator/WGS1984.
///
/// * Written entirely in Dart. No plugins, No platform code, No native code.
///
/// * Map is vendor-free. Meaning that you can choose any tile provider of your choice. Google Maps, Mapbox, OSM Maps and Yandex Maps are a few to name. You can also use this package with your own custom tiles, your own server, your own [sub]domain.
///
/// * Support for vector tiles is under development in [vt](https://pub.dev/packages/vt) and [cartography](https://pub.dev/packages/cartography) packages. Please checkout these packages to know more about the progress and open issues/tasks.
///
/// * This package supports **caching** out of the box through [cached_network_image](https://pub.dev/packages/cached_network_image) and [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) packages.
library map;

import 'dart:math';

import 'package:latlng/latlng.dart';
import 'package:flutter/widgets.dart';

part 'src/map_layout.dart';
part 'src/transformer.dart';
part 'src/controller.dart';
part 'src/polyline.dart';
part 'src/layers/tile_layer.dart';
part 'src/layers/polyline_layer.dart';

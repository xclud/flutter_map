[![pub package](https://img.shields.io/pub/v/map)](https://pub.dartlang.org/packages/map)
[![likes](https://img.shields.io/pub/likes/map)](https://pub.dartlang.org/packages/map/score)
[![points](https://img.shields.io/pub/points/map)](https://pub.dartlang.org/packages/map/score)
[![popularity](https://img.shields.io/pub/popularity/map)](https://pub.dartlang.org/packages/map/score)
[![license](https://img.shields.io/github/license/xclud/flutter_map)](https://pub.dartlang.org/packages/map)
[![stars](https://img.shields.io/github/stars/xclud/flutter_map)](https://github.com/xclud/flutter_map/stargazers)
[![forks](https://img.shields.io/github/forks/xclud/flutter_map)](https://github.com/xclud/flutter_map/network/members)
[![sdk version](https://badgen.net/pub/sdk-version/map)](https://pub.dartlang.org/packages/map)


Lightweight `Map` widget for flutter supporting different projections including EPSG4326/Mercator/WGS1984.

* Written entirely in Dart. No plugins, No platform code, No native code.

* Map is vendor-free. Meaning that you can choose any tile provider of your choice. Google Maps, Mapbox, OSM Maps and Yandex Maps are a few to name. You can also use this package with your own custom tiles, your own server, your own [sub]domain.

* Support for vector tiles is under development in [vt](https://pub.dev/packages/vt) and [cartography](https://pub.dev/packages/cartography) packages. Please checkout these packages to know more about the progress and open issues/tasks.

* This package supports **caching** out of the box through [cached_network_image](https://pub.dev/packages/cached_network_image) and [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) packages.

## Demo

[Web Demo](https://xclud.github.io/flutter_map/)

The source code of the demo app is available in the `./example` project.

## Contributing

I welcome contributions in all forms. One lightweight way you can contribute is to [tell me that you're using Map](https://github.com/xclud/flutter_map/discussions/41), which will give me warm fuzzy feelings 🤩.

## Supported platforms

* [✓] Android
* [✓] iOS
* [✓] Web
* [✓] Windows
* [✓] Linux
* [✓] macOS
* [✓] Flutter 3 is supported.

## Getting Started

In your `pubspec.yaml` file add:

```dart
dependencies:
  map: any
```

Then, in your code import:

```dart
import 'package:map/map.dart';
```

```dart
final controller = MapController(
  location: const LatLng(0, 0),
  zoom: 2,
);
```

```dart
MapLayout(
  controller: controller,
  builder: (context, transformer) {
    return TileLayer(
      builder: (context, x, y, z) {
        final tilesInZoom = pow(2.0, z).floor();

        while (x < 0) {
          x += tilesInZoom;
        }
        while (y < 0) {
          y += tilesInZoom;
        }

        x %= tilesInZoom;
        y %= tilesInZoom;

        //Google Maps
        final url =
            'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        );
      },
    );
  },
);
```

Please check out the example project/tab for a working sample.

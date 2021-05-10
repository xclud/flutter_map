# map
[![pub package](https://img.shields.io/pub/v/map.svg)](https://pub.dartlang.org/packages/map)

A flutter package to view a `Map` widget in Flutter apps.

Map supports variety of raster tile providers including but not limited to Google Maps, OSM Maps and Yandex Maps. In version `0.2.0` of the package i made some changes in the package which opens possibility of displaying vector tile maps (e.g. MBTiles/MVT/GeoJSON).

As of version `0.2.0`, this package supports **caching** out of the box.

## Supported platforms

* [x] Flutter Android
* [x] Flutter iOS
* [x] Flutter Web
* [x] Flutter Desktop


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

Please check out the example project/tab for a working sample.

## Features

Currently these basic features are implemented:

- Drag panning
- Pinch-zoom
- Double click zoom

More features are yet to come.


## Screenshot

![Map Screenshot](screenshots/map01.png)

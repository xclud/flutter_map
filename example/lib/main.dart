import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Map Demo"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            final controller = MapController(
              location: LatLng(35.68, 51.41),
              tileSize: 256 / devicePixelRatio,
            );

            return Map(
              controller: controller,
              provider: const CachedGoogleMapProvider(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {},
        ),
      ),
    );
  }
}

class CachedGoogleMapProvider extends MapProvider {
  const CachedGoogleMapProvider();

  @override
  ImageProvider getTile(int x, int y, int z) {
    return NetworkImage(
        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425');
  }
}

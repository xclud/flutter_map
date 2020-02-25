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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = MapController(
    location: LatLng(35.68, 51.41),
  );

  void _incrementCounter() {
    controller.location = LatLng(35.68, 51.41);
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    controller.tileSize = 256 / devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Map Demo'),
      ),
      body: Map(
        controller: controller,
        provider: const CachedGoogleMapProvider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'My Location',
        child: Icon(Icons.my_location),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// You can enable caching by using [CachedNetworkImageProvider] from cached_network_image package.
class CachedGoogleMapProvider extends MapProvider {
  const CachedGoogleMapProvider();

  @override
  ImageProvider getTile(int x, int y, int z) {
    //Can also use CachedNetworkImageProvider.
    return NetworkImage(
        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425');
  }
}

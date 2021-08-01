import 'package:example/pages/custom_tile_page.dart';
import 'package:example/pages/day_night_page.dart';
import 'package:example/pages/interactive_page.dart';
import 'package:example/pages/markers_page.dart';
import 'package:example/pages/metro_lines_page.dart';
import 'package:example/pages/raster_map_page.dart';
import 'package:example/pages/vector_map_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MapApp());

class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Examples',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Raster Map'),
            subtitle: Text('Raster tiles from Google, OSM and etc.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(RasterMapPage()),
          ),
          ListTile(
            title: Text('Vector Map'),
            subtitle: Text('OSM light-themed vector maps.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(VectorMapPage()),
            enabled: false,
          ),
          ListTile(
            title: Text('Markers'),
            subtitle:
                Text('Drop multiple fixed and centered markers on the map.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(MarkersPage()),
          ),
          ListTile(
            title: Text('Interactive'),
            subtitle: Text('Say where on the earth user has clicked.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(InteractiveMapPage()),
          ),
          ListTile(
            title: Text('Custom Tiles'),
            subtitle: Text('Use any Widget as map tiles.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(CustomTilePage()),
          ),
          ListTile(
            title: Text('Metro Lines (Work in Progress)'),
            subtitle: Text('Draw polyline overlays (Tehran Metro).'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(MetroLinesPage()),
          ),
          ListTile(
            title: Text('Custom Projection'),
            subtitle: Text('How we convert LatLng to XY. Useful for games.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: _showNotImplemented,
            enabled: false,
          ),
          ListTile(
            title: Text('Day & Night Map'),
            subtitle: Text('Shows a map for day and night.'),
            trailing: Icon(Icons.chevron_right_sharp),
            onTap: () => _push(DayNightPage()),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented() {
    final snackBar =
        SnackBar(content: Text('This demo is not implemented yet.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _push(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

void main() => runApp(const MapApp());

class MapApp extends StatelessWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Map Examples',
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text('Map Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Basic Map'),
            subtitle: const Text('Raster tiles from Google, OSM and etc.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('basic'),
          ),
          ListTile(
            title: const Text('Vector Map'),
            subtitle: const Text('OSM light-themed vector maps.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _showNotImplemented,
            enabled: false,
          ),
          ListTile(
            title: const Text('Markers'),
            subtitle: const Text(
                'Drop multiple fixed and centered markers on the map.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('markers'),
          ),
          ListTile(
            title: const Text('Interactive'),
            subtitle: const Text('Say where on the earth user has clicked.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('interactive'),
          ),
          ListTile(
            title: const Text('Shapes'),
            subtitle: const Text('Display Polylines on the map.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('shapes'),
          ),
          ListTile(
            title: const Text('Custom Tiles'),
            subtitle: const Text('Use any Widget as map tiles.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('custom-tiles'),
          ),
          ListTile(
            title: const Text('Metro Lines (Work in Progress)'),
            subtitle: const Text('Draw polyline overlays (Tehran Metro).'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('tehran-metro'),
          ),
          ListTile(
            title: const Text('Custom Projection'),
            subtitle:
                const Text('How we convert LatLng to XY. Useful for games.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: _showNotImplemented,
            enabled: false,
          ),
          ListTile(
            title: const Text('Twilight'),
            subtitle: const Text('Day and night map, sun and moon position.'),
            trailing: const Icon(Icons.chevron_right_sharp),
            onTap: () => _go('twilight'),
          ),
        ],
      ),
    );
  }

  void _showNotImplemented() {
    const snackBar =
        SnackBar(content: Text('This demo is not implemented yet.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _go(String name) {
    GoRouter.of(context).goNamed(name);
  }
}

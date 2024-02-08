import 'package:example/main.dart';
import 'package:example/pages/custom_tile_page.dart';
import 'package:example/pages/interactive_page.dart';
import 'package:example/pages/metro_lines_page.dart';
import 'package:example/pages/raster_map_page.dart';
import 'package:example/pages/shapes_page.dart';
import 'package:example/pages/twilight_page.dart';
import 'package:go_router/go_router.dart';

/// This handles '/' and '/details'.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, rs) => const HomePage(),
      routes: [
        GoRoute(
          path: 'custom-tiles',
          name: 'custom-tiles',
          builder: (_, __) => const CustomTilePage(),
        ),
        GoRoute(
          path: 'interactive',
          name: 'interactive',
          builder: (_, __) => const InteractiveMapPage(),
        ),
        GoRoute(
          path: 'markers',
          name: 'markers',
          builder: (_, __) => const InteractiveMapPage(),
        ),
        GoRoute(
          path: 'tehran-metro',
          name: 'tehran-metro',
          builder: (_, __) => const MetroLinesPage(),
        ),
        GoRoute(
          path: 'basic',
          name: 'basic',
          builder: (_, __) => const RasterMapPage(),
        ),
        GoRoute(
          path: 'shapes',
          name: 'shapes',
          builder: (_, __) => const ShapesPage(),
        ),
        GoRoute(
          path: 'twilight',
          name: 'twilight',
          builder: (_, __) => const TwilightPage(),
        ),
      ],
    ),
  ],
);

part of '../map.dart';

/// Builds a widget tree that can depend on the parent widget's size and
/// providers a map coordinates transfom helper to its children.
///
/// Similar to the [LayoutBuilder] widget.
@Deprecated('Please use [MapLayout] instead')
class MapLayoutBuilder extends InheritedWidget {
  /// The default constructor.
  MapLayoutBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.tileSize = 256,
  }) : super(
            key: key,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final transformer = MapTransformer._internal(
                controller: controller,
                constraints: constraints,
                tileSize: tileSize,
              );
              return builder.call(context, transformer);
            }));

  /// The data from the closest [MapLayoutBuilder] instance that encloses the given context.
  static MapLayoutBuilder? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MapLayoutBuilder>();
  }

  /// Size of each tile in pixels. Most tile servers provide tiles of 256 pixels.
  final int tileSize;

  /// Map controller which is used in [MapLayoutBuilder].
  final MapController controller;

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must not return null.
  final Widget Function(
    BuildContext context,
    MapTransformer transformer,
  ) builder;

  @override
  bool updateShouldNotify(covariant MapLayoutBuilder oldWidget) {
    return oldWidget.tileSize != tileSize ||
        oldWidget.controller != controller ||
        oldWidget.builder != builder;
  }
}

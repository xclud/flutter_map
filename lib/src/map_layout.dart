part of map;

/// Builds a widget tree that can depend on the parent widget's size and
/// providers a map coordinates transfom helper to its children.
///
/// Similar to the [LayoutBuilder] widget.
class MapLayout extends InheritedWidget {
  /// The default constructor.
  MapLayout({
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

  /// The data from the closest [MapLayout] instance that encloses the given context.
  static MapLayout? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MapLayout>();
  }

  /// Size of each tile in pixels. Most tile servers provide tiles of 256 pixels.
  final int tileSize;

  /// Map controller which is used in [MapLayout].
  final MapController controller;

  /// Called at layout time to construct the widget tree.
  ///
  /// The builder must not return null.
  final Widget Function(
    BuildContext context,
    MapTransformer transformer,
  ) builder;

  /// Whether the framework should notify widgets that inherit from this widget.
  @override
  bool updateShouldNotify(covariant MapLayout oldWidget) {
    return oldWidget.tileSize != tileSize ||
        oldWidget.controller != controller ||
        oldWidget.builder != builder;
  }
}

import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/src/map.dart';

/// Signature for when a tap has occurred.
///
/// See also:
///
///  * [Map.onTap], which matches this signature.
///  * [TapGestureRecognizer], which uses this signature in one of its callbacks.
typedef MapTapCallback = void Function(MapTapDetails details);
typedef MapTapUpCallback = void Function(MapTapDetails details);

class MapTapDetails {
  MapTapDetails(this.details, this.location, this.tileIndex);

  final TapUpDetails details;
  final LatLng location;
  final TileIndex tileIndex;
}

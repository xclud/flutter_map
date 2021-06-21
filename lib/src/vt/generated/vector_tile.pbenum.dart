///
//  Generated code. Do not modify.
//  source: vector_tile.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class GeomType extends $pb.ProtobufEnum {
  static const GeomType UNKNOWN = GeomType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'UNKNOWN');
  static const GeomType POINT = GeomType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'POINT');
  static const GeomType LINESTRING = GeomType._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'LINESTRING');
  static const GeomType POLYGON = GeomType._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'POLYGON');

  static const $core.List<GeomType> values = <GeomType>[
    UNKNOWN,
    POINT,
    LINESTRING,
    POLYGON,
  ];

  static final $core.Map<$core.int, GeomType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GeomType? valueOf($core.int value) => _byValue[value];

  const GeomType._($core.int v, $core.String n) : super(v, n);
}

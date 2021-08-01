///
//  Generated code. Do not modify.
//  source: vector_tile.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package, constant_identifier_names

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use geomTypeDescriptor instead')
const GeomType$json = const {
  '1': 'GeomType',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'POINT', '2': 1},
    const {'1': 'LINESTRING', '2': 2},
    const {'1': 'POLYGON', '2': 3},
  ],
};

/// Descriptor for `GeomType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List geomTypeDescriptor = $convert.base64Decode(
    'CghHZW9tVHlwZRILCgdVTktOT1dOEAASCQoFUE9JTlQQARIOCgpMSU5FU1RSSU5HEAISCwoHUE9MWUdPThAD');
@$core.Deprecated('Use valueDescriptor instead')
const Value$json = const {
  '1': 'Value',
  '2': const [
    const {
      '1': 'string_value',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'stringValue',
      '17': true
    },
    const {
      '1': 'float_value',
      '3': 2,
      '4': 1,
      '5': 2,
      '9': 1,
      '10': 'floatValue',
      '17': true
    },
    const {
      '1': 'double_value',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'doubleValue',
      '17': true
    },
    const {
      '1': 'int_value',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'intValue',
      '17': true
    },
    const {
      '1': 'uint_value',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 4,
      '10': 'uintValue',
      '17': true
    },
    const {
      '1': 'sint_value',
      '3': 6,
      '4': 1,
      '5': 18,
      '9': 5,
      '10': 'sintValue',
      '17': true
    },
    const {
      '1': 'bool_value',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 6,
      '10': 'boolValue',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_string_value'},
    const {'1': '_float_value'},
    const {'1': '_double_value'},
    const {'1': '_int_value'},
    const {'1': '_uint_value'},
    const {'1': '_sint_value'},
    const {'1': '_bool_value'},
  ],
};

/// Descriptor for `Value`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List valueDescriptor = $convert.base64Decode(
    'CgVWYWx1ZRImCgxzdHJpbmdfdmFsdWUYASABKAlIAFILc3RyaW5nVmFsdWWIAQESJAoLZmxvYXRfdmFsdWUYAiABKAJIAVIKZmxvYXRWYWx1ZYgBARImCgxkb3VibGVfdmFsdWUYAyABKAFIAlILZG91YmxlVmFsdWWIAQESIAoJaW50X3ZhbHVlGAQgASgDSANSCGludFZhbHVliAEBEiIKCnVpbnRfdmFsdWUYBSABKARIBFIJdWludFZhbHVliAEBEiIKCnNpbnRfdmFsdWUYBiABKBJIBVIJc2ludFZhbHVliAEBEiIKCmJvb2xfdmFsdWUYByABKAhIBlIJYm9vbFZhbHVliAEBQg8KDV9zdHJpbmdfdmFsdWVCDgoMX2Zsb2F0X3ZhbHVlQg8KDV9kb3VibGVfdmFsdWVCDAoKX2ludF92YWx1ZUINCgtfdWludF92YWx1ZUINCgtfc2ludF92YWx1ZUINCgtfYm9vbF92YWx1ZQ==');
@$core.Deprecated('Use featureDescriptor instead')
const Feature$json = const {
  '1': 'Feature',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 4, '9': 0, '10': 'id', '17': true},
    const {
      '1': 'tags',
      '3': 2,
      '4': 3,
      '5': 13,
      '8': const {'2': true},
      '10': 'tags',
    },
    const {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.map.GeomType',
      '9': 1,
      '10': 'type',
      '17': true
    },
    const {
      '1': 'geometry',
      '3': 4,
      '4': 3,
      '5': 13,
      '8': const {'2': true},
      '10': 'geometry',
    },
  ],
  '8': const [
    const {'1': '_id'},
    const {'1': '_type'},
  ],
};

/// Descriptor for `Feature`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureDescriptor = $convert.base64Decode(
    'CgdGZWF0dXJlEhMKAmlkGAEgASgESABSAmlkiAEBEhYKBHRhZ3MYAiADKA1CAhABUgR0YWdzEiYKBHR5cGUYAyABKA4yDS5tYXAuR2VvbVR5cGVIAVIEdHlwZYgBARIeCghnZW9tZXRyeRgEIAMoDUICEAFSCGdlb21ldHJ5QgUKA19pZEIHCgVfdHlwZQ==');
@$core.Deprecated('Use layerDescriptor instead')
const Layer$json = const {
  '1': 'Layer',
  '2': const [
    const {'1': 'version', '3': 15, '4': 1, '5': 13, '10': 'version'},
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {
      '1': 'features',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.map.Feature',
      '10': 'features'
    },
    const {'1': 'keys', '3': 3, '4': 3, '5': 9, '10': 'keys'},
    const {
      '1': 'values',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.map.Value',
      '10': 'values'
    },
    const {
      '1': 'extent',
      '3': 5,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'extent',
      '17': true
    },
  ],
  '8': const [
    const {'1': '_extent'},
  ],
};

/// Descriptor for `Layer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layerDescriptor = $convert.base64Decode(
    'CgVMYXllchIYCgd2ZXJzaW9uGA8gASgNUgd2ZXJzaW9uEhIKBG5hbWUYASABKAlSBG5hbWUSKAoIZmVhdHVyZXMYAiADKAsyDC5tYXAuRmVhdHVyZVIIZmVhdHVyZXMSEgoEa2V5cxgDIAMoCVIEa2V5cxIiCgZ2YWx1ZXMYBCADKAsyCi5tYXAuVmFsdWVSBnZhbHVlcxIbCgZleHRlbnQYBSABKA1IAFIGZXh0ZW50iAEBQgkKB19leHRlbnQ=');
@$core.Deprecated('Use vectorTileDescriptor instead')
const VectorTile$json = const {
  '1': 'VectorTile',
  '2': const [
    const {
      '1': 'layers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.map.Layer',
      '10': 'layers'
    },
  ],
};

/// Descriptor for `VectorTile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vectorTileDescriptor = $convert.base64Decode(
    'CgpWZWN0b3JUaWxlEiIKBmxheWVycxgDIAMoCzIKLm1hcC5MYXllclIGbGF5ZXJz');

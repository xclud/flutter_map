///
//  Generated code. Do not modify.
//  source: vector_tile.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'vector_tile.pbenum.dart';

export 'vector_tile.pbenum.dart';

class Value extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Value',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'map'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'stringValue')
    ..a<$core.double>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'floatValue',
        $pb.PbFieldType.OF)
    ..a<$core.double>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'doubleValue',
        $pb.PbFieldType.OD)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'intValue')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uintValue', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sintValue', $pb.PbFieldType.OS6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boolValue')
    ..hasRequiredFields = false;

  Value._() : super();
  factory Value({
    $core.String? stringValue,
    $core.double? floatValue,
    $core.double? doubleValue,
    $fixnum.Int64? intValue,
    $fixnum.Int64? uintValue,
    $fixnum.Int64? sintValue,
    $core.bool? boolValue,
  }) {
    final _result = create();
    if (stringValue != null) {
      _result.stringValue = stringValue;
    }
    if (floatValue != null) {
      _result.floatValue = floatValue;
    }
    if (doubleValue != null) {
      _result.doubleValue = doubleValue;
    }
    if (intValue != null) {
      _result.intValue = intValue;
    }
    if (uintValue != null) {
      _result.uintValue = uintValue;
    }
    if (sintValue != null) {
      _result.sintValue = sintValue;
    }
    if (boolValue != null) {
      _result.boolValue = boolValue;
    }
    return _result;
  }
  factory Value.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Value.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Value clone() => Value()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Value copyWith(void Function(Value) updates) =>
      super.copyWith((message) => updates(message as Value))
          as Value; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Value create() => Value._();
  Value createEmptyInstance() => create();
  static $pb.PbList<Value> createRepeated() => $pb.PbList<Value>();
  @$core.pragma('dart2js:noInline')
  static Value getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Value>(create);
  static Value? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stringValue => $_getSZ(0);
  @$pb.TagNumber(1)
  set stringValue($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStringValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearStringValue() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get floatValue => $_getN(1);
  @$pb.TagNumber(2)
  set floatValue($core.double v) {
    $_setFloat(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFloatValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearFloatValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get doubleValue => $_getN(2);
  @$pb.TagNumber(3)
  set doubleValue($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDoubleValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDoubleValue() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get intValue => $_getI64(3);
  @$pb.TagNumber(4)
  set intValue($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIntValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntValue() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get uintValue => $_getI64(4);
  @$pb.TagNumber(5)
  set uintValue($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasUintValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearUintValue() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sintValue => $_getI64(5);
  @$pb.TagNumber(6)
  set sintValue($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSintValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearSintValue() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get boolValue => $_getBF(6);
  @$pb.TagNumber(7)
  set boolValue($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasBoolValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearBoolValue() => clearField(7);
}

class Feature extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Feature',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'map'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..p<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'tags',
        $pb.PbFieldType.KU3)
    ..e<GeomType>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type',
        $pb.PbFieldType.OE,
        defaultOrMaker: GeomType.UNKNOWN,
        valueOf: GeomType.valueOf,
        enumValues: GeomType.values)
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'geometry', $pb.PbFieldType.KU3)
    ..hasRequiredFields = false;

  Feature._() : super();
  factory Feature({
    $fixnum.Int64? id,
    $core.Iterable<$core.int>? tags,
    GeomType? type,
    $core.Iterable<$core.int>? geometry,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (tags != null) {
      _result.tags.addAll(tags);
    }
    if (type != null) {
      _result.type = type;
    }
    if (geometry != null) {
      _result.geometry.addAll(geometry);
    }
    return _result;
  }
  factory Feature.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Feature.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Feature clone() => Feature()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Feature copyWith(void Function(Feature) updates) =>
      super.copyWith((message) => updates(message as Feature))
          as Feature; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Feature create() => Feature._();
  Feature createEmptyInstance() => create();
  static $pb.PbList<Feature> createRepeated() => $pb.PbList<Feature>();
  @$core.pragma('dart2js:noInline')
  static Feature getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Feature>(create);
  static Feature? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get tags => $_getList(1);

  @$pb.TagNumber(3)
  GeomType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(GeomType v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get geometry => $_getList(3);
}

class Layer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Layer',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'map'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..pc<Feature>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'features',
        $pb.PbFieldType.PM,
        subBuilder: Feature.create)
    ..pPS(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keys')
    ..pc<Value>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'values', $pb.PbFieldType.PM, subBuilder: Value.create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extent', $pb.PbFieldType.OU3)
    ..a<$core.int>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  Layer._() : super();
  factory Layer({
    $core.String? name,
    $core.Iterable<Feature>? features,
    $core.Iterable<$core.String>? keys,
    $core.Iterable<Value>? values,
    $core.int? extent,
    $core.int? version,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (features != null) {
      _result.features.addAll(features);
    }
    if (keys != null) {
      _result.keys.addAll(keys);
    }
    if (values != null) {
      _result.values.addAll(values);
    }
    if (extent != null) {
      _result.extent = extent;
    }
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory Layer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Layer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Layer clone() => Layer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Layer copyWith(void Function(Layer) updates) =>
      super.copyWith((message) => updates(message as Layer))
          as Layer; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Layer create() => Layer._();
  Layer createEmptyInstance() => create();
  static $pb.PbList<Layer> createRepeated() => $pb.PbList<Layer>();
  @$core.pragma('dart2js:noInline')
  static Layer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Layer>(create);
  static Layer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Feature> get features => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get keys => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<Value> get values => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get extent => $_getIZ(4);
  @$pb.TagNumber(5)
  set extent($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasExtent() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtent() => clearField(5);

  @$pb.TagNumber(15)
  $core.int get version => $_getIZ(5);
  @$pb.TagNumber(15)
  set version($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(15)
  void clearVersion() => clearField(15);
}

class VectorTile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'VectorTile',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'map'),
      createEmptyInstance: create)
    ..pc<Layer>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'layers',
        $pb.PbFieldType.PM,
        subBuilder: Layer.create)
    ..hasRequiredFields = false;

  VectorTile._() : super();
  factory VectorTile({
    $core.Iterable<Layer>? layers,
  }) {
    final _result = create();
    if (layers != null) {
      _result.layers.addAll(layers);
    }
    return _result;
  }
  factory VectorTile.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory VectorTile.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  VectorTile clone() => VectorTile()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  VectorTile copyWith(void Function(VectorTile) updates) =>
      super.copyWith((message) => updates(message as VectorTile))
          as VectorTile; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VectorTile create() => VectorTile._();
  VectorTile createEmptyInstance() => create();
  static $pb.PbList<VectorTile> createRepeated() => $pb.PbList<VectorTile>();
  @$core.pragma('dart2js:noInline')
  static VectorTile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VectorTile>(create);
  static VectorTile? _defaultInstance;

  @$pb.TagNumber(3)
  $core.List<Layer> get layers => $_getList(0);
}

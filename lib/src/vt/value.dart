import 'package:fixnum/fixnum.dart';

class Value {
  final String? stringValue;
  final double? floatValue;
  final double? doubleValue;
  final Int64? intValue;
  final Int64? uintValue;
  final Int64? sintValue;
  final bool? boolValue;

  const Value({
    this.stringValue,
    this.floatValue,
    this.doubleValue,
    this.intValue,
    this.uintValue,
    this.sintValue,
    this.boolValue,
  });
}

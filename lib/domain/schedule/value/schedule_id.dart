import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ScheduleId {
  ScheduleId(this.value) {
    if (value.isEmpty) {
      throw Exception('ScheduleId must not be empty.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ScheduleId && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

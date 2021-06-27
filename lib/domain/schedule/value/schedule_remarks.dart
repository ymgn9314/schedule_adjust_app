import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ScheduleRemarks {
  ScheduleRemarks(this.value) {
    if (value.length > 300) {
      throw Exception('Schedule remarks length must be <=300.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRemarks && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

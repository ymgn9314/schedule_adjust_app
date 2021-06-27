import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ScheduleTitle {
  ScheduleTitle(this.value) {
    if (value.length > 15) {
      throw Exception('Schedule title length must be <=15.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleTitle && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

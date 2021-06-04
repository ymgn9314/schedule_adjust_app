import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ScheduleTitle {
  ScheduleTitle(this.value) {
    if (value.isEmpty) {
      throw Exception('Schedule title must not be empty.');
    }
    if (value.length < 3 || value.length > 10) {
      throw Exception('Schedule title length must be 3<= and <=10.');
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

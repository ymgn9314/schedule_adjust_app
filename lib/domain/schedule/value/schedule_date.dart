import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ScheduleDate {
  ScheduleDate(this.value) {
    // 今日の日付より前だったら
    if (value.isAfter(DateTime.now())) {
      throw Exception('Schedule date must be before now.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ScheduleDate && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final DateTime value;
}

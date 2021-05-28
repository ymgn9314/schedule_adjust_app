import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';

@immutable
class ScheduleDates {
  ScheduleDates(this.value) {
    if (value.length < 2 || value.length > 14) {
      throw Exception('Schedule date length must be 2 <= and <= 14.');
    }
  }

  ScheduleDates add(ScheduleDate date) {
    final dateList = List<ScheduleDate>.from(value)..add(date);
    return ScheduleDates(dateList);
  }

  final List<ScheduleDate> value;
}

import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';

enum Answer {
  ok, // ◯
  either, // △
  ng, // ×
}

@immutable
class AnswerToDate {
  const AnswerToDate(this.value);

  final Map<ScheduleDate, Answer> value;
}

import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';

import 'answer.dart';

@immutable
class AnswersToSchedule {
  const AnswersToSchedule(this.value);

  final Map<ScheduleId, AnswerToDate> value;
}

import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_dates.dart';
import 'package:high_hat/domain/schedule/value/schedule_remarks.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

/// Scheduleのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class ScheduleFactoryBase {
  Schedule create({
    required ScheduleTitle title,
    required ScheduleRemarks remarks,
    required ScheduleDates scheduleDates,
    required List<UserId> participants,
  });
}

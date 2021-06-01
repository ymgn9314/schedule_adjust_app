import 'package:high_hat/domain/schedule/schedule.dart';

/// Scheduleのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class ScheduleFactoryBase {
  Schedule create({
    required String title,
    required String remarks,
    required List<DateTime> scheduleDates,
    required List<String> userIds,
  });
}

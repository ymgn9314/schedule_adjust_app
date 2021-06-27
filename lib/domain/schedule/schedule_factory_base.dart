import 'package:high_hat/domain/schedule/schedule.dart';

/// Scheduleのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class ScheduleFactoryBase {
  Schedule create({
    required String id,
    required String ownerUrl,
    required String title,
    required String remarks,
    required List<DateTime> scheduleList,
    required List<String> userList,
    required List<String> answerUserList,
  });
}

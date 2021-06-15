import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/user/value/answer.dart';

abstract class ScheduleRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Schedule?> find(ScheduleId id);
  Future<Schedule?> findByTitle(ScheduleTitle title);
  Future<List<Schedule>> findAll();
  Future<void> saveSchedule(Schedule schedule);
  Future<void> saveScheduleAnswer(
      ScheduleId id, Map<ScheduleDate, Answer> answer);
  Future<void> remove(Schedule schedule);
}

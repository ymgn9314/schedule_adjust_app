import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';

abstract class ScheduleRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Schedule?> fetch(ScheduleId id);
  Future<Schedule?> fetchByTitle(ScheduleTitle title);
  Future<List<Schedule>> fetchAll();
  Future<void> saveSchedule(Schedule schedule);
  Future<void> remove(Schedule schedule);

  Stream<List<ScheduleId>> fetchScheduleIdListStream();
  Stream<Schedule?> fetchScheduleStream(ScheduleId id);
}

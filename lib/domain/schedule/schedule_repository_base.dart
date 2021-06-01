import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';

abstract class ScheduleRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<Schedule?> find(ScheduleId id);
  Future<Schedule?> findByTitle(ScheduleTitle title);
  Future<List<Schedule>> findAll();
  Future<void> save(Schedule schedule);
  Future<void> remove(Schedule schedule);
}

import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/schedule_factory_base.dart';
import 'package:high_hat/domain/schedule/schedule_repository_base.dart';
import 'package:high_hat/domain/schedule/schedule_service.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';

class ScheduleAppService {
  ScheduleAppService({
    required ScheduleService scheduleService,
    required ScheduleRepositoryBase scheduleRepository,
    required ScheduleFactoryBase scheduleFactory,
    required UserRepositoryBase userRepository,
  })  : _scheduleService = scheduleService,
        _scheduleRepository = scheduleRepository,
        _scheduleFactory = scheduleFactory,
        _userRepository = userRepository;

  final ScheduleService _scheduleService;
  final ScheduleRepositoryBase _scheduleRepository;
  final ScheduleFactoryBase _scheduleFactory;

  final UserRepositoryBase _userRepository;

  // スケジュールを作成
  Future<void> create({
    required String title,
    required String remarks,
    required List<DateTime> scheduleDates,
    required List<String> userIds,
  }) async {
    final schedule = _scheduleFactory.create(
        title: title,
        remarks: remarks,
        scheduleDates: scheduleDates,
        userIds: userIds);
    await _scheduleRepository.save(schedule);
  }

  // スケジュールを削除
  Future<void> delete(ScheduleId id) async {
    final target = await _scheduleRepository.find(id);
    if (target == null) {
      throw Exception('Not found delete target.');
    }
    await _scheduleRepository.remove(target);
  }

  // スケジュール一覧を取得
  Future<List<Schedule>> getScheduleList() async {
    final schedules = await _scheduleRepository.findAll();
    return schedules;
  }

  // スケジュールに回答する
  Future<void> answerToSchedule(ScheduleId id) async {
    throw Exception('Not implemented.');
  }
}

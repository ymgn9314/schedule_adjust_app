import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/schedule_factory_base.dart';
import 'package:high_hat/domain/schedule/schedule_repository_base.dart';
import 'package:high_hat/domain/schedule/schedule_service.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/value/answer.dart';

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
    required String ownerUrl,
    required String remarks,
    required List<DateTime> scheduleList,
    required List<String> userList,
  }) async {
    // スケジュールを作成したユーザーID + 時間をスケジュールのIDにする
    final scheduleId = '${Helpers.userId ?? ''}${Helpers.ntpTime}';
    final schedule = _scheduleFactory.create(
        id: scheduleId,
        ownerUrl: ownerUrl,
        title: title,
        remarks: remarks,
        scheduleList: scheduleList,
        userList: userList);
    await _scheduleRepository.saveSchedule(schedule);
  }

  // スケジュールを削除
  Future<void> delete(String id) async {
    final target = await _scheduleRepository.find(ScheduleId(id));
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
  Future<void> answerToSchedule(String id, Map<DateTime, Answer> answer) async {
    final answerData = <ScheduleDate, Answer>{};
    for (final e in answer.entries) {
      answerData[ScheduleDate(e.key)] = e.value;
    }
    await _scheduleRepository.saveScheduleAnswer(ScheduleId(id), answerData);
  }
}

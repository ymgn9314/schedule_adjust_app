import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/schedule_factory_base.dart';
import 'package:high_hat/domain/schedule/schedule_repository_base.dart';
import 'package:high_hat/domain/schedule/schedule_service.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/infrastructure/schedule/schedule_repository.dart';

class ScheduleAppService {
  ScheduleAppService({
    required ScheduleRepositoryBase scheduleRepository,
    required ScheduleFactoryBase scheduleFactory,
    required UserRepositoryBase userRepository,
  })  : _scheduleService = ScheduleService(scheduleRepository),
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
    required List<String> answerUserList,
  }) async {
    // スケジュールを作成したユーザーID + 時間をスケジュールのIDにする
    final ntpTime = await Helpers.ntpTime;
    final scheduleId =
        '${Helpers.userId ?? ''}${Helpers.dateFormatForId.format(ntpTime!)}';
    final schedule = _scheduleFactory.create(
      id: scheduleId,
      ownerUrl: ownerUrl,
      title: title,
      remarks: remarks,
      scheduleList: scheduleList,
      userList: userList,
      answerUserList: answerUserList,
    );
    await _scheduleRepository.saveSchedule(schedule);
  }

  // スケジュールを削除
  Future<void> delete(String id) async {
    final target = await _scheduleRepository.fetch(ScheduleId(id));
    if (target == null) {
      throw Exception('Not found delete target.');
    }
    await _scheduleRepository.remove(target);
  }

  // スケジュール一覧を取得
  Future<List<Schedule>> getScheduleList() async {
    final schedules = await _scheduleRepository.fetchAll();
    return schedules;
  }

  Future<List<Map<Answer, int>>?> getAnswerNumberList(String scheduleId) async {
    final schedule = await _scheduleRepository.fetch(ScheduleId(scheduleId));
    // スケジュールが見つからなかった
    if (schedule == null) {
      return null;
    }

    // まだ誰も回答していない
    if (schedule.answerUserList.isEmpty) {
      return null;
    }

    // 回答ごとの人数を格納する
    var totalAnswerList = List<Map<Answer, int>>.generate(
      schedule.scheduleList.length,
      (index) => <Answer, int>{
        Answer.ng: 0,
        Answer.either: 0,
        Answer.ok: 0,
      },
    );

    // ユーザーごとの回答を取得する
    int validAnswerNumber = 0;
    for (var ui = 0; ui < schedule.answerUserList.length; ++ui) {
      final userId = schedule.answerUserList[ui];
      final user = await _userRepository.findByUserId(userId);
      if (user == null) {
        continue;
      }

      final userAnswerList = user.answerToSchedule[ScheduleId(scheduleId)];
      if (userAnswerList == null) {
        continue;
      }

      ++validAnswerNumber;

      // 回答を集計する
      for (var si = 0; si < schedule.scheduleList.length; ++si) {
        totalAnswerList[si][userAnswerList[si]] =
            (totalAnswerList[si][userAnswerList[si]] ?? 0) + 1;
      }
    }

    // 有効な回答数が0のとき(ユーザーが退会した等)
    if (validAnswerNumber == 0) {
      return null;
    }

    return totalAnswerList;
  }

  Future<List<User>?> getUserListInSchedule(String scheduleId) async {
    final schedule = await _scheduleRepository.fetch(ScheduleId(scheduleId));
    // スケジュールが見つからなかった
    if (schedule == null) {
      return null;
    }

    // まだ誰も回答していない
    if (schedule.answerUserList.isEmpty) {
      return null;
    }

    final userList = <User>[];
    for (final userId in schedule.answerUserList) {
      final user = await _userRepository.findByUserId(userId);
      if (user != null) {
        userList.add(user);
      }
    }
    return userList;
  }

  Stream<List<ScheduleId>> fetchScheduleIdListStream() {
    return _scheduleRepository.fetchScheduleIdListStream();
  }

  Stream<Schedule?> fetchScheduleStream(String id) {
    return _scheduleRepository.fetchScheduleStream(ScheduleId(id));
  }
}

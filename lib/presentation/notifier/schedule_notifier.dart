import 'package:flutter/material.dart';
import 'package:high_hat/application/schedule_app_service.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/answer.dart';

class ScheduleNotifier with ChangeNotifier {
  ScheduleNotifier({
    required ScheduleAppService service,
  }) : _service = service;

  final ScheduleAppService _service;

  Future<void> createSchedule({
    required String title,
    required String ownerUrl,
    required String remarks,
    required List<DateTime> scheduleList,
    required List<String> userList,
    required List<String> answerUserList,
  }) async {
    await _service.create(
      title: title,
      ownerUrl: ownerUrl,
      remarks: remarks,
      scheduleList: scheduleList,
      userList: userList,
      answerUserList: answerUserList,
    );
  }

  Future<void> deleteSchedule(String id) async {
    await _service.delete(id);
    notifyListeners();
  }

  Future<List<Schedule>> getScheduleList() async {
    return _service.getScheduleList();
  }

  Future<List<Map<Answer, int>>?> getAnswerNumberList(String scheduleId) async {
    return _service.getAnswerNumberList(scheduleId);
  }

  Future<List<User>?> getUserListInSchedule(String scheduleId) async {
    return _service.getUserListInSchedule(scheduleId);
  }

  Stream<List<ScheduleId>> fetchScheduleIdListStream() {
    return _service.fetchScheduleIdListStream();
  }

  Stream<Schedule?> fetchScheduleStream(String id) {
    return _service.fetchScheduleStream(id);
  }
}

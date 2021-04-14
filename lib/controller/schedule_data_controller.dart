import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:high_hat/util/schedule_data.dart';

class ScheduleDataController extends ChangeNotifier {
  List<ScheduleData> scheduleList = [];

  void add({
    // タイトル
    required String title,
    // 備考欄
    required String remarks,
    // 予定作成者(オーナー)の情報
    required UserData owner,
    // 参加者(オーナーも含む)
    required LinkedHashSet<FriendAnswerData> participants,
  }) {
    print('AppDataController#add()');
    scheduleList.add(
      ScheduleData(
        title: title,
        remarks: remarks,
        owner: owner,
        participants: participants,
      ),
    );
    notifyListeners();
  }
}

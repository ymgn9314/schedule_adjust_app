import 'dart:collection';
import 'package:high_hat/util/friend_data.dart';

// 予定に対する回答
enum Answer {
  ok, // ◯
  either, // △
  ng, // ×
}

class FriendAnswerData {
  FriendAnswerData({
    required this.person,
    required this.isAnswer,
    required this.answerMap,
  });

  // 参加者
  FriendData person;
  // 回答したか
  bool isAnswer;
  // 日付ごとの回答
  LinkedHashMap<DateTime, Answer> answerMap;
}

class ScheduleData {
  ScheduleData({
    required this.title,
    required this.remarks,
    required this.owner,
    required this.participants,
  });

  // タイトル
  String title;
  // 備考欄
  String remarks;
  // 予定作成者(オーナー)の情報
  FriendData owner;
  // 参加者(オーナーも含む)
  LinkedHashSet<FriendAnswerData> participants;
}

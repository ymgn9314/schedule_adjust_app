import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_remarks.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

class Schedule {
  Schedule({
    required this.id,
    required AvatarUrl ownerUrl,
    required ScheduleTitle title,
    required ScheduleRemarks remarks,
    required List<ScheduleDate> scheduleList,
    required List<UserId> userList,
    required List<UserId> answerUserList,
  })  : _ownerUrl = ownerUrl,
        _title = title,
        _remarks = remarks,
        _scheduleList = scheduleList,
        _userList = userList,
        _answerUserList = answerUserList;

  // 識別子
  final ScheduleId id;
  // スケジュールのオーナーPhotoUrl
  AvatarUrl _ownerUrl;
  // タイトル
  ScheduleTitle _title;
  // 備考欄
  ScheduleRemarks _remarks;
  // 候補日
  List<ScheduleDate> _scheduleList;
  // 参加者
  List<UserId> _userList;
  // 回答済み参加者
  List<UserId> _answerUserList;

  AvatarUrl get ownerUrl => _ownerUrl;
  ScheduleTitle get title => _title;
  ScheduleRemarks get remarks => _remarks;
  List<ScheduleDate> get scheduleList => _scheduleList;
  List<UserId> get userList => _userList;
  List<UserId> get answerUserList => _answerUserList;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Schedule && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  // TODO(ymgn9314): タイトル変更等のメソッドを追加？(仕様にはないので保留中)
}

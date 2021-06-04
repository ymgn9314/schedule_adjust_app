import 'package:high_hat/domain/schedule/value/schedule_dates.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_remarks.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

class Schedule {
  Schedule({
    required this.id,
    required ScheduleTitle title,
    required ScheduleRemarks remarks,
    required ScheduleDates scheduleDates,
    required List<UserId> participants,
  })  : _title = title,
        _remarks = remarks,
        _scheduleDates = scheduleDates,
        _participants = participants;

  // 識別子
  final ScheduleId id;
  // タイトル
  ScheduleTitle _title;
  // 備考欄
  ScheduleRemarks _remarks;
  // 候補日
  ScheduleDates _scheduleDates;
  // 参加者
  List<UserId> _participants;

  ScheduleTitle get title => _title;
  ScheduleRemarks get remarks => _remarks;
  ScheduleDates get scheduleDates => _scheduleDates;
  List<UserId> get participants => _participants;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Schedule && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;

  // TODO(ymgn9314): タイトル変更等のメソッドを追加？(仕様にはないので保留中)
}

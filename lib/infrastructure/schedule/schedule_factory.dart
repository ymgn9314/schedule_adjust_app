import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/schedule_factory_base.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/schedule/value/schedule_remarks.dart';
import 'package:high_hat/domain/schedule/value/schedule_title.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

class ScheduleFactory implements ScheduleFactoryBase {
  @override
  Schedule create({
    required String id,
    required String ownerUrl,
    required String title,
    required String remarks,
    required List<DateTime> scheduleList,
    required List<String> userList,
    required List<String> answerUserList,
  }) {
    return Schedule(
      id: ScheduleId(id),
      ownerUrl: AvatarUrl(ownerUrl),
      title: ScheduleTitle(title),
      remarks: ScheduleRemarks(remarks),
      scheduleList: scheduleList.map((e) => ScheduleDate(e)).toList(),
      userList: userList.map((e) => UserId(e)).toList(),
      answerUserList: answerUserList.map((e) => UserId(e)).toList(),
    );
  }
}

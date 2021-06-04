import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

// Userクラスのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class UserFactoryBase {
  User create({
    required UserName userName,
    required UserProfileId userProfileId,
    required AvatarUrl avatarUrl,
    required List<UserId> userFriend,
    required Map<ScheduleId, Map<ScheduleDate, Answer>> answersToSchedule,
  });
}

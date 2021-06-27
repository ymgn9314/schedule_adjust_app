import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_factory_base.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_comment.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

class UserFactory implements UserFactoryBase {
  @override
  User create({
    required String userId,
    required String userName,
    required String userProfileId,
    required String avatarUrl,
    required List<String> userFriend,
    required Map<String, List<int>> answersToSchedule,
    required Map<String, String> scheduleComment,
  }) {
    return User(
      id: UserId(userId),
      userName: UserName(userName),
      userProfileId: UserProfileId(userProfileId),
      avatarUrl: AvatarUrl(avatarUrl),
      userFriend: userFriend.map((e) => UserId(e)).toList(),
      answersToSchedule: answersToSchedule.map(
        (key, value) => MapEntry(
          ScheduleId(key),
          value.map((e) => Answer.values[e]).toList(),
        ),
      ),
      scheduleComment: scheduleComment.map(
        (key, value) => MapEntry(
          ScheduleId(key),
          UserComment(value),
        ),
      ),
    );
  }
}

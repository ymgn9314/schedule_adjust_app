import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

class User {
  User({
    required this.id,
    required UserName userName,
    required UserProfileId userProfileId,
    required AvatarUrl avatarUrl,
    required List<UserId> userFriend,
    required Map<ScheduleId, Map<ScheduleDate, Answer>> answersToSchedule,
  })  : _userName = userName,
        _userProfileId = userProfileId,
        _avatarUrl = avatarUrl,
        _userFriend = userFriend,
        _answersToSchedule = answersToSchedule;

  // 識別子
  final UserId id;
  // ユーザー名
  UserName _userName;
  // ユーザーID
  UserProfileId _userProfileId;
  // アバターurl
  AvatarUrl _avatarUrl;
  // 友達
  List<UserId> _userFriend;
  // スケジュールに対する回答
  Map<ScheduleId, Map<ScheduleDate, Answer>> _answersToSchedule;
}

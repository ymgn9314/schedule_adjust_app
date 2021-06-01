import 'package:high_hat/domain/user/value/answers.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_friend.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

class User {
  User({
    required this.id,
    required UserName userName,
    required UserProfileId userProfileId,
    required AvatarUrl avatarUrl,
    required UserFriend userFriend,
    required AnswersToSchedule answersToSchedule,
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

  // TODO(ymgn9314): 削除する
  /// Deprecated: Userクラスでは友達の情報を持たないようにし、今後はrepositoryから取得するようにする
  @deprecated
  UserFriend _userFriend;
  // スケジュールに対する回答
  AnswersToSchedule _answersToSchedule;
}

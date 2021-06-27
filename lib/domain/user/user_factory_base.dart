import 'package:high_hat/domain/user/user.dart';

// Userクラスのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class UserFactoryBase {
  User create({
    required String userId,
    required String userName,
    required String userProfileId,
    required String avatarUrl,
    required List<String> userFriend,
    required Map<String, List<int>> answersToSchedule,
    required Map<String, String> scheduleComment,
  });
}

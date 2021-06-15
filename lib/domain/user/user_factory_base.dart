import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/answer.dart';

// Userクラスのファクトリ抽象クラス
// ignore: one_member_abstracts
abstract class UserFactoryBase {
  User create({
    required String userName,
    required String userProfileId,
    required String avatarUrl,
    required List<String> userFriend,
    required Map<String, Map<DateTime, Answer>> answersToSchedule,
  });
}

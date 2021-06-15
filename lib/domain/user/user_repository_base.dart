import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

abstract class UserRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  // ユーザーを探す(UserProfileIdは重複を許可)
  Future<List<User>> findByUserProfileId(UserProfileId id);

  // ユーザーを探す(UserIdはユニーク)
  Future<User?> findByUserId(UserId id);

  // Firestoreからユーザー追加/削除(ユーザー登録、退会時)
  Future<void> create(User user);
  Future<void> delete(UserId userId);

  // 自分の友達の追加/削除
  Future<void> addToFriend(UserId userid);
  Future<void> deleteFromFriend(UserId userId);

  // 自分の友達一覧を取得
  Future<List<User>> getFriendList();
}

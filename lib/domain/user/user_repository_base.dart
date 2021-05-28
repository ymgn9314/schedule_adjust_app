import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

abstract class UserRepositoryBase {
  Future<T> transaction<T>(Future<T> Function() f);
  Future<User> find(UserProfileId id);
  Future<void> save(User user);
  Future<void> remove(User user);
}

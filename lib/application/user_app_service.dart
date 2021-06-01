import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_factory_base.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/user_service.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

class UserAppService {
  UserAppService({
    required UserService userService,
    required UserRepositoryBase userRepository,
    required UserFactoryBase userFactory,
  })  : _userService = userService,
        _userRepository = userRepository,
        _userFactory = userFactory;

  final UserService _userService;
  final UserRepositoryBase _userRepository;
  final UserFactoryBase _userFactory;

  // ユーザーを作成(Firestoreに登録)
  Future<void> create({
    required String userName,
    required String userProfileId,
    required String avatarUrl,
  }) async {
    final user = _userFactory.create(
        userName: userName, userProfileId: userProfileId, avatarUrl: avatarUrl);
    await _userRepository.create(user);
  }

  // ユーザーを退会(Firestoreから削除)
  Future<void> delete(UserId id) async {
    final user = await _userRepository.findByUserId(id);
    if (user == null) {
      throw Exception('User(findByUserId) not found');
    }
    await _userRepository.delete(user);
  }

  // ユーザーを検索(プロフィールIDによる検索、重複あり)
  Future<List<User>> search(UserProfileId id) async {
    final user = await _userRepository.findByUserProfileId(id);
    return user;
  }

  // ユーザーを友達に追加
  Future<void> addToFriend(UserId id) async {
    final user = await _userRepository.findByUserId(id);
    if (user == null) {
      throw Exception('User(findByUserId) not found');
    }
    await _userRepository.addToFriend(user);
  }

  // ユーザーを友達から削除
  Future<void> deleteFromFriend(UserId id) async {
    final user = await _userRepository.findByUserId(id);
    if (user == null) {
      throw Exception('User(findByUserId) not found');
    }
    await _userRepository.deleteFromFriend(user);
  }

  // 友達一覧を取得
  Future<List<User>> getFriendList() async {
    final users = await _userRepository.getFriendList();
    return users;
  }
}

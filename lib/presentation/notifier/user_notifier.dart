import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:high_hat/application/user_app_service.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';

class UserNotifier with ChangeNotifier {
  UserNotifier({
    required UserAppService service,
  }) : _service = service {
    _updateLoggedInUser();
  }

  final UserAppService _service;
  User? _loggedInUser;

  bool get loggedIn => FirebaseAuth.instance.currentUser != null;
  User? get loggedInUser => _loggedInUser;

  Future<void> _updateLoggedInUser() async {
    if (loggedIn) {
      final _id = FirebaseAuth.instance.currentUser!.uid;
      _loggedInUser = await _service.searchByUserId(UserId(_id));

      // TODO(ymgn9314): 前バージョンで既に使っているユーザー用
      // 新バージョンはFirestoreのデータ構造が変わっているため、
      // ユーザー情報がそっちに作成されていなければ作成する
      if (_loggedInUser == null) {
        // ユーザーを作成
        await createMyAccount();
        _loggedInUser = await _service.searchByUserId(UserId(_id));
      }

      notifyListeners();
    }
  }

  Future<void> createMyAccount() async {
    final userId = Helpers.userId ?? '';
    final user = await searchByUserId(userId);

    // ユーザー情報がFirestore上に存在したら作成しない
    if (user != null) {
      return;
    }

    await _service.create(
      userId: userId,
      userName: Helpers.userName ?? Helpers.generateRandomString(8),
      userProfileId: Helpers.generateRandomString(8),
      avatarUrl: Helpers.photoUrl ?? '',
    );
    notifyListeners();
  }

  Future<void> deleteMyAccount() async {
    final userId = Helpers.userId;
    if (userId != null) {
      await _service.delete(UserId(userId));
      notifyListeners();
    }
  }

  Future<void> updateMyAccount({
    required String userId,
    required String name,
    required String userProfileId,
  }) async {
    await _service.update(
      UserId(userId),
      UserName(name),
      UserProfileId(userProfileId),
    );
    await _updateLoggedInUser();
    notifyListeners();
  }

  Future<void> notifySignIn() async {
    final _id = FirebaseAuth.instance.currentUser!.uid;
    _loggedInUser = await _service.searchByUserId(UserId(_id));
    notifyListeners();
  }

  void notifySignOut() {
    FirebaseAuth.instance.signOut();
    // _loggedInUser = null;
    notifyListeners();
  }

  Future<User?> searchByUserId(String id) async {
    return _service.searchByUserId(UserId(id));
  }

  Future<List<User>> searchByUserProfileId(UserProfileId id) async {
    return _service.searchByUserProfileId(id);
  }

  Future<bool> isAlwaysFriend(UserId id) async {
    final isFriend = await _service.isAlwaysFriend(id);
    return isFriend;
  }

  Future<void> addToFriend(UserId id) async {
    await _service.addToFriend(id);
    notifyListeners();
  }

  Future<void> deleteFromFriend(UserId id) async {
    await _service.deleteFromFriend(id);
    notifyListeners();
  }

  Future<List<User>> getFriendList() async {
    return _service.getFriendList();
  }

  Stream<List<User>> getFriendListStream() {
    return _service.getFriendListStream();
  }

  Future<UserCredential?> signInWithGoogle() async {
    return _service.signInWithGoogle();
  }

  Future<UserCredential?> signInWithApple() async {
    return _service.signInWithApple();
  }

  Future<UserCredential?> signInWithTwitter() async {
    return _service.signInWithTwitter();
  }

  Future<void> answerToSchedule(
    String id,
    List<Answer> answerList,
    String comment,
  ) async {
    await _service.answerToSchedule(id, answerList, comment);
    notifyListeners();
  }

  Future<List<Answer>?> getAnswer(String userId, String scheduleId) async {
    final user = await _service.searchByUserId(UserId(userId));
    if (user == null) {
      return null;
    }
    return user.answerToSchedule[ScheduleId(scheduleId)];
  }
}

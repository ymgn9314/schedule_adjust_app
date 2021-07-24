import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_factory_base.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/user_service.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/user_comment.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class UserAppService {
  UserAppService({
    required UserRepositoryBase userRepository,
    required UserFactoryBase userFactory,
  })  : _userService = UserService(userRepository),
        _userRepository = userRepository,
        _userFactory = userFactory;

  final UserService _userService;
  final UserRepositoryBase _userRepository;
  final UserFactoryBase _userFactory;

  // ユーザーを作成(Firestoreに登録)
  Future<void> create({
    required String userId,
    required String userName,
    required String userProfileId,
    required String avatarUrl,
  }) async {
    final user = _userFactory.create(
      userId: userId,
      userName: userName,
      userProfileId: userProfileId,
      avatarUrl: avatarUrl,
      userFriend: [],
      answersToSchedule: {},
      scheduleComment: {},
    );
    await _userRepository.create(user);
  }

  // ユーザーを退会(Firestoreから削除)
  Future<void> delete(UserId id) async {
    await _userRepository.delete(id);
  }

  // ユーザー情報を更新(UserName, UserProfileIdのみ)
  Future<void> update(UserId userId, UserName name, UserProfileId id) async {
    await _userRepository.update(userId, name, id);
  }

  // ユーザーを検索(ユーザーIDによる検索、重複なし)
  Future<User?> searchByUserId(UserId id) async {
    final user = await _userRepository.findByUserId(id);
    return user;
  }

  // ユーザーを検索(プロフィールIDによる検索、重複あり)
  Future<List<User>> searchByUserProfileId(UserProfileId id) async {
    final user = await _userRepository.findByUserProfileId(id);
    return user;
  }

  // ユーザーと既に友達かを返す
  Future<bool> isAlwaysFriend(UserId id) async {
    // 友達一覧を取得
    final friendList = await getFriendList();
    return friendList.where((user) => user.id == id).isNotEmpty;
  }

  // ユーザーを友達に追加
  Future<void> addToFriend(UserId id) async {
    await _userRepository.addToFriend(id);
  }

  // ユーザーを友達から削除
  Future<void> deleteFromFriend(UserId id) async {
    await _userRepository.deleteFromFriend(id);
  }

  // 友達一覧を取得
  Future<List<User>> getFriendList() async {
    final users = await _userRepository.getFriendList();
    return users;
  }

  // 友達一覧を取得(Stream)
  Stream<List<User>> getFriendListStream() {
    return _userRepository.getFriendListStream();
  }

  // Googleサインイン
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: [
        'email',
      ]).signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
    } on Exception catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  // Appleサインイン
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );
      return FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
    } on Exception catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  // Twitterサインイン
  Future<UserCredential?> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'Gv0F0jj584IpTnU1ar1bOarY8',
        apiSecretKey: '8Xomm3tsvvY7Dz49C1bTLjbH55nf1to0xsDWHsiuRKyh8ONA3W',
        redirectURI: kReleaseMode ? 'schedule-app://' : 'schedule-app-dev://',
      );

      final authResult = await twitterLogin.login();
      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final credential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );
        return FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
    } on Exception catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  // スケジュールに回答する
  Future<void> answerToSchedule(
    String id,
    List<Answer> answerList,
    String comment,
  ) async {
    await _userRepository.saveScheduleAnswer(
      ScheduleId(id),
      answerList,
      UserComment(comment),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_comment.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

export 'package:high_hat/domain/user/user_repository_base.dart';

class UserRepository implements UserRepositoryBase {
  final _db = FirebaseFirestore.instance;
  final _userId = Helpers.userId ?? '';

  @override
  Future<void> addToFriend(UserId userId) async {
    await _db.doc('private/user/user_v1/$_userId').update(
      <String, dynamic>{
        'friendList': FieldValue.arrayUnion(<String>[userId.value]),
      },
    );
  }

// Firestoreからユーザー追加/削除(ユーザー登録、退会時)
  @override
  Future<void> create(User user) async {
    // public
    await _db.doc('public/user/user_v1/${user.id.value}').set(
      <String, dynamic>{
        'displayName': user.userName.value,
        'photoUrl': user.avatarUrl.value,
        'userId': user.userProfileId.value,
        'schedule': <String, dynamic>{},
        'comment': <String, dynamic>{},
      },
    );

    // private
    await _db.doc('private/user/user_v1/${user.id.value}').set(
      <String, dynamic>{
        'friendList': FieldValue.arrayUnion(
          user.userFriend.map((e) => e.value).toList(),
        ),
      },
    );
  }

  @override
  Future<void> delete(UserId userId) async {
    // public
    await _db.doc('public/user/user_v1/${userId.value}').delete();
    // private
    await _db.doc('private/user/user_v1/${userId.value}').delete();
  }

  @override
  Future<void> update(UserId userId, UserName name, UserProfileId id) async {
    await _db.doc('public/user/user_v1/${userId.value}').update(
      <String, dynamic>{
        'displayName': name.value,
        'userId': id.value,
      },
    );
  }

  @override
  Future<void> deleteFromFriend(UserId userId) async {
    // private
    await _db.doc('private/user/user_v1/$_userId').update(
      <String, dynamic>{
        'friendList': FieldValue.arrayRemove(
          <dynamic>[userId.value],
        ),
      },
    );
  }

  @override
  Future<User?> findByUserId(UserId id) async {
    DocumentSnapshot pubSnapshot, priSnapshot;
    final pubDoc = _db.doc('public/user/user_v1/${id.value}');
    final priDoc = _db.doc('private/user/user_v1/${id.value}');

    try {
      pubSnapshot = await pubDoc.get();
      priSnapshot = await priDoc.get();
    } on Exception catch (e) {
      print(e);
      return null;
    }

    if (!pubSnapshot.exists || !priSnapshot.exists) {
      return null;
    }

    try {
      final pubData = pubSnapshot.data()!;
      final priData = priSnapshot.data()!;

      final _userName = pubData['displayName'] as String;
      final _userProfileId = pubData['userId'] as String;
      final _avatarUrl = pubData['photoUrl'] as String;
      final _userFriend = priData['friendList'] as List<dynamic>;

      // TODO(ymgn): もっと綺麗な書き方分かったら修正
      final _answersToSchedule = <ScheduleId, List<Answer>>{};
      ((pubData['schedule'] ?? <String, dynamic>{}) as Map<String, dynamic>)
          .cast<String, List<dynamic>>()
          .forEach((key, value) {
        _answersToSchedule[ScheduleId(key)] =
            value.cast<int>().map((e) => Answer.values[e]).toList();
      });

      final _scheduleComment = <ScheduleId, UserComment>{};
      ((pubData['comment'] ?? <String, dynamic>{}) as Map<String, dynamic>)
          .cast<String, String>()
          .forEach(
        (key, value) {
          _scheduleComment[ScheduleId(key)] = UserComment(value);
        },
      );

      return User(
        id: id,
        userName: UserName(_userName),
        userProfileId: UserProfileId(_userProfileId),
        avatarUrl: AvatarUrl(_avatarUrl),
        userFriend: _userFriend.cast<String>().map((e) => UserId(e)).toList(),
        answersToSchedule: _answersToSchedule,
        scheduleComment: _scheduleComment,
      );
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<User>> findByUserProfileId(UserProfileId id) async {
    final userList = <User>[];

    final query = _db
        .collection('public/user/user_v1')
        .where('userId', whereIn: <String>[id.value]);

    final snapshot = await query.get();
    final docs = snapshot.docs;
    for (final doc in docs) {
      final findUser = await findByUserId(UserId(doc.id));
      if (findUser != null) {
        userList.add(findUser);
      }
    }

    return userList;
  }

  @override
  Future<List<User>> getFriendList() async {
    final userList = <User>[];
    final doc = _db.doc('private/user/user_v1/$_userId');
    DocumentSnapshot snapshot;

    try {
      snapshot = await doc.get();
    } on Exception catch (e) {
      print(e);
      return userList;
    }

    if (!snapshot.exists) {
      return userList;
    }
    final data = snapshot.data()!;

    final userIdList = (data['friendList'] as List).cast<String>();

    for (final id in userIdList) {
      final findUser = await findByUserId(UserId(id));
      if (findUser != null) {
        userList.add(findUser);
      }
    }

    return userList;
  }

  @override
  Stream<List<User>> getFriendListStream() {
    return _db.doc('private/user/user_v1/$_userId').snapshots().asyncMap(
      (snapshot) async {
        if (!snapshot.exists) {
          return <User>[];
        }

        final data = snapshot.data()!;
        final userIdList = (data['friendList'] as List).cast<String>();
        final userList = <User>[];

        for (final id in userIdList) {
          final findUser = await findByUserId(UserId(id));
          if (findUser != null) {
            userList.add(findUser);
          }
        }
        return userList;
      },
    );
  }

  @override
  Future<T> transaction<T>(Future<T> Function() f) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<void> saveScheduleAnswer(
    ScheduleId id,
    List<Answer> answerList,
    UserComment comment,
  ) async {
    final userId = Helpers.userId ?? '';

    // 回答を更新
    await _db.doc('public/user/user_v1/$userId').update(
      <String, dynamic>{
        'schedule.${id.value}': answerList.map((e) => e.index).toList(),
      },
    );

    // コメントを保存
    await _db.doc('public/user/user_v1/$userId').set(
      <String, dynamic>{
        'comment': <String, dynamic>{
          id.value: comment.value,
        },
      },
      SetOptions(merge: true),
    );

    // 回答済みユーザーリストに追加
    await _db.doc('public/schedule/schedule_v1/${id.value}').update(
      <String, dynamic>{
        'answerUserList': FieldValue.arrayUnion(<String>[userId]),
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/user_repository_base.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/domain/user/value/avatar_url.dart';
import 'package:high_hat/domain/user/value/user_name.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

export 'package:high_hat/domain/user/user_repository_base.dart';

class ScheduleRepository implements UserRepositoryBase {
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
        'displayName': user.userName,
        'photoUrl': user.avatarUrl,
        'userId': user.userProfileId,
        'schedule': <String, dynamic>{},
      },
    );

    // private
    await _db.doc('private/user/user_v1/${user.id}').set(
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
    final pubData = pubSnapshot.data()!;
    final priData = priSnapshot.data()!;

    final _userName = pubData['displayName'] as String;
    final _userProfileId = pubData['userId'] as String;
    final _avatarUrl = pubData['photoUrl'] as String;
    final _userFriend = priData[''] as List<String>;

    // TODO(ymgn): あまり良くない書き方(綺麗な書き方分かったら修正)
    final _answersToSchedule = <ScheduleId, Map<ScheduleDate, Answer>>{};
    (pubData['schedule'] as Map<String, Map<Timestamp, int>>).forEach(
      (key, value) {
        final _valueMap = <ScheduleDate, Answer>{};
        value.forEach(
          (key, value) {
            _valueMap[ScheduleDate(key.toDate())] = Answer.values[value];
          },
        );
        _answersToSchedule[ScheduleId(key)] = _valueMap;
      },
    );

    return User(
      id: id,
      userName: UserName(_userName),
      userProfileId: UserProfileId(_userProfileId),
      avatarUrl: AvatarUrl(_avatarUrl),
      userFriend: _userFriend.map((e) => UserId(e)).toList(),
      answersToSchedule: _answersToSchedule,
    );
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

    final userIdList = data['friendList'] as List<String>;

    for (final id in userIdList) {
      final findUser = await findByUserId(UserId(id));
      if (findUser != null) {
        userList.add(findUser);
      }
    }

    return userList;
  }

  @override
  Future<T> transaction<T>(Future<T> Function() f) {
    // TODO: implement transaction
    throw UnimplementedError();
  }
}

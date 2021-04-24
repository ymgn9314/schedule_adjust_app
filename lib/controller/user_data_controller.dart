import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/local_db/friend_box/friend_box.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:hive/hive.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

import 'login_authentication_controller.dart';

class UserDataController extends ChangeNotifier {
  // Firestore上の全ユーザーリスト（uidを比較して重複を避ける）
  // アプリ起動時に一度だけ読み込む
  // LinkedHashSet<UserData> userSet = LinkedHashSet<UserData>(
  //   equals: (lhs, rhs) => lhs == rhs,
  //   hashCode: (data) => data.hashCode,
  // );

  // firestoreから取得したユーザー情報を(UserData)返す
  Future<UserData> getUserDataFromFirestore(String uid) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final exists = user.exists;

      return UserData(
        uid: uid,
        displayName: exists ? user.get('displayName') as String : '不明なユーザー',
        photoUrl: exists ? user.get('photoUrl') as String : '',
      );
    } on Exception catch (e) {
      print(e);
      return UserData(
        uid: 'unknownUid',
        displayName: '不明なユーザー',
        photoUrl: '',
      );
    }
  }

  // ローカルDBの友達リストを更新したか？
  bool isUpdateHiveFriendList = false;
  // ローカルDB上の友達リストを更新する
  // ローカルDB上の友達のuidの内、Firestoreに存在しないものはローカルDBから削除する
  Future<bool> updateHiveFriendList() async {
    // 更新していなければ更新する
    if (!isUpdateHiveFriendList) {
      final friendBox = Hive.box<FriendBox>('friend_box');
      final friendUids = friendBox.values.map((e) => e.uid);
      // ローカルDBに友達リストが存在する?
      await Future.forEach<String>(
        friendUids,
        (uid) async {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          // Firestoreに存在しなければローカルDBから削除する
          if (!doc.exists) {
            await friendBox.delete(uid);
          }
        },
      );
      isUpdateHiveFriendList = true;
    }

    return true;
  }

  // firestoreから取得したユーザー情報から、Cardウィジェットを返す
  Widget getUserCardFromFirestore(String uid) {
    return FutureBuilder<UserData>(
      future: getUserDataFromFirestore(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data!.photoUrl),
              ),
              const SizedBox(width: 8),
              Text(snapshot.data!.displayName),
            ],
          ),
        );
      },
    );
  }

  // 検索にヒットしたユーザー
  final hitUsers = LinkedHashSet<UserData>(
    equals: (lhs, rhs) => lhs == rhs,
    hashCode: (data) => data.hashCode,
  );

  // 予定追加画面の友達候補
  List<MultiSelectItem<UserData>> registerPageAddFriendItems =
      <MultiSelectItem<UserData>>[];
  // 既に取得済みか
  // (一旦チェックせずにSchedulePage->RegisterSchedulePageへの遷移前に毎回取得)
  bool isFecthed = false;

  Future<void> fetchRegisterPageAddFriendItems(BuildContext context) async {
    if (isFecthed) {
      return;
    }
    final user = context.read<LoginAuthenticationController>().user;

    Hive.box<FriendBox>('friend_box').values.forEach((e) {
      if (e.uid != user!.uid) {
        registerPageAddFriendItems.add(MultiSelectItem(
          UserData(
            uid: e.uid,
            displayName: e.displayName,
            photoUrl: e.photoUrl,
          ),
          e.displayName,
        ));
      }
    });

    isFecthed = true;
    notifyListeners();
  }

  void initSearchState() {
    hitUsers.clear();
    notifyListeners();
  }

  Future<void> searchFriend(String searchValue) async {
    // 前回の検索情報をクリアする
    hitUsers.clear();
    // 検索にヒットしたユーザーを取得(完全一致)
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: searchValue)
        .get();
    snapshot.docs.forEach((hitUser) {
      hitUsers.add(
        UserData(
          uid: hitUser.id,
          displayName: hitUser.get('displayName') as String,
          photoUrl: hitUser.get('photoUrl') as String,
        ),
      );
    });

    notifyListeners();
  }

  void addFriendToFirestore(UserData user) {
    // 友達をローカルDBに追加
    Hive.box<FriendBox>('friend_box').put(
      user.uid,
      FriendBox(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      ),
    );
  }

  void deleteFriendFromFirestore(BuildContext context, String uid) {
    final user = context.read<LoginAuthenticationController>().user;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('friends')
        .doc(uid)
        .delete();
    notifyListeners();
  }
}

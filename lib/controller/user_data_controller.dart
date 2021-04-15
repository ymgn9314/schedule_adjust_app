import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class UserDataController extends ChangeNotifier {
  // Firestore上の全ユーザーリスト（uidを比較して重複を避ける）
  // アプリ起動時に一度だけ読み込む
  LinkedHashSet<UserData> userSet = LinkedHashSet<UserData>(
    equals: (lhs, rhs) => lhs == rhs,
    hashCode: (data) => data.hashCode,
  );

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

  Future<void> fetchRegisterPageAddFriendItems() async {
    final user = FirebaseAuth.instance.currentUser;
    // users/uid/friendsのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('friends')
        .get();
    registerPageAddFriendItems = await Future.wait(
        snapshot.docs.map<Future<MultiSelectItem<UserData>>>((doc) async {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.id)
          .get();
      return MultiSelectItem(
        UserData(
          uid: doc.id,
          displayName: user.get('displayName') as String,
          photoUrl: user.get('photoUrl') as String,
        ),
        user.get('displayName') as String,
      );
    }));

    isFecthed = true;
    notifyListeners();
  }

  void initSearchState() {
    hitUsers.clear();
    notifyListeners();
  }

  void searchFriend(String searchValue) {
    // 前回の検索情報をクリアする
    hitUsers.clear();
    // 検索にヒットしたユーザーを取得
    // searchValueが4文字以上のときに限定する
    if (searchValue.length >= 4) {
      userSet.forEach(
        (e) {
          // 文字列が含まれているか(小文字同士で比較)
          if (e.uid.toLowerCase().contains(searchValue.toLowerCase())) {
            hitUsers.add(e);
          }
        },
      );
    }
    notifyListeners();
  }

  void addFriendToFirestore(UserData user) {
    // 友達をfirestoreに追加
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .doc(user.uid)
        .set(
      <String, dynamic>{},
    );
    notifyListeners();
  }

  Future<void> fetchFirestoreUser() async {
    final _firestore = FirebaseFirestore.instance;
    final docs = await _firestore.collection('users').get();
    // firestoreから全ユーザー情報を取得する
    docs.docs.forEach((doc) {
      userSet.add(
        UserData(
          uid: doc.id,
          displayName: doc.get('displayName') as String,
          photoUrl: doc.get('photoUrl') as String,
        ),
      );
    });
    notifyListeners();
  }
}

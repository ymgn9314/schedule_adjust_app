import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/util/user_data.dart';

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

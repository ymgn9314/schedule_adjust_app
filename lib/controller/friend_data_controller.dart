import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:high_hat/util/friend_data.dart';

class FriendDataController extends ChangeNotifier {
  // 友達リスト（uidを比較して重複を避ける）
  LinkedHashSet<FriendData> friendSet = LinkedHashSet<FriendData>(
    equals: (lhs, rhs) => lhs == rhs,
    hashCode: (data) => data.hashCode,
  );

  void add({
    required String uid,
    required String displayName,
    required String photoUrl,
  }) {
    print('FriendDataController#add()');
    friendSet.add(
      FriendData(
        uid: uid,
        displayName: displayName,
        photoUrl: photoUrl,
      ),
    );
    notifyListeners();
  }
}

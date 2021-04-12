import 'package:flutter/material.dart';
import 'package:high_hat/widgets/friend_card.dart';

class FriendDataController extends ChangeNotifier {
  List<FriendCard> friendList = [];

  void add({
    required String displayName,
    required String photoUrl,
  }) {
    print('FriendDataController#add()');
    friendList.add(FriendCard(displayName: displayName, photoUrl: photoUrl));
    notifyListeners();
  }
}

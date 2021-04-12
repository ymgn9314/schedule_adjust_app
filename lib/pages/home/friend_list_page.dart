import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/friend_data_controller.dart';
import 'package:provider/provider.dart';

class FriendListPage extends StatelessWidget {
  static const id = 'friend_list_page';
  @override
  Widget build(BuildContext context) {
    print('FriendListPage#build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Selector<FriendDataController, int>(
        selector: (context, model) => model.friendList.length,
        builder: (context, length, child) {
          return ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) {
              return context.read<FriendDataController>().friendList[index];
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(ymgn): 後でちゃんとする
          final controller = context.read<FriendDataController>();
          if (controller.friendList.length < 10) {
            final user = FirebaseAuth.instance.currentUser;
            controller.add(
                displayName: user!.displayName!, photoUrl: user.photoURL!);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.person_add,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

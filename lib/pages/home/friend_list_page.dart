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
        selector: (context, model) => model.friendSet.length,
        builder: (context, length, child) {
          return ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) {
              final controller = context.read<FriendDataController>();
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      controller.friendSet.elementAt(index).photoUrl),
                ),
                title: Text(controller.friendSet.elementAt(index).displayName),
                subtitle: Text(controller.friendSet.elementAt(index).uid),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(ymgn): 後でちゃんとする
          final controller = context.read<FriendDataController>();
          if (controller.friendSet.length < 10) {
            final user = FirebaseAuth.instance.currentUser;
            controller.add(
              uid: user!.uid,
              displayName: user.displayName!,
              photoUrl: user.photoURL!,
            );
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

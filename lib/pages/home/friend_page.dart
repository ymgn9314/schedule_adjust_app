import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/local_db/friend_box/friend_box.dart';
import 'package:high_hat/pages/home/search_friend_page.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FriendPage extends StatelessWidget {
  static const id = 'friend_page';

  Widget friendCard(
      {required UserData data, required void Function()? onLongPress}) {
    return Card(
      elevation: 4,
      child: ListTile(
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data.photoUrl),
        ),
        title: Text(data.displayName),
        subtitle: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(data.uid)
              .snapshots()
              .handleError(() {}),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // エラーが起きたとき
            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Text('不明なユーザーID');
            }
            return Text(snapshot.data!.get('userId') as String);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('FriendListPage#build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<bool>(
        future: context.read<UserDataController>().updateHiveFriendList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final friendBox = Hive.box<FriendBox>('friend_box');
          return ValueListenableBuilder(
            valueListenable: friendBox.listenable(),
            builder: (context, Box<FriendBox> box, widget) {
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final user =
                      context.read<LoginAuthenticationController>().user;
                  // 自分は保存しない
                  if (box.values.elementAt(index).uid == user!.uid) {
                    return const SizedBox();
                  }
                  return friendCard(
                    data: UserData(
                      uid: box.values.elementAt(index).uid,
                      displayName: box.values.elementAt(index).displayName,
                      photoUrl: box.values.elementAt(index).photoUrl,
                    ),
                    onLongPress: () {
                      // 削除しますか？
                      showDialog<void>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            title: const Text('削除しますか?'),
                            content: const Text('削除した友達は検索から再度追加することができます'),
                            actions: <Widget>[
                              // ボタン領域
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('いいえ'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // ローカルDBから削除
                                  box.delete(box.values.elementAt(index).uid);
                                  Navigator.pop(context);
                                },
                                child: const Text('はい'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 友達検索画面の検索ステータスを初期化しておく
          context.read<UserDataController>().initSearchState();
          // 友達検索画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => SearchFriendPage(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.person_add,
              size: 24,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

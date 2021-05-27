import 'package:flutter/material.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/local_db/friend_box/friend_box.dart';
import 'package:hive/hive.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 友達検索ページ
class SearchFriendPage extends StatelessWidget {
  // Future<bool> _fetchFirestoreUser(BuildContext context) async {
  //   final controller = context.read<UserDataController>();
  //   // Firestore上の全ユーザーを取得する(アプリ起動後初回のみ)
  //   if (controller.userSet.isEmpty) {
  //     await controller.fetchFirestoreUser();
  //   }
  //   return true;
  // }

  Widget searchBody(BuildContext context) {
    final controller = context.read<UserDataController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: OutlineSearchBar(
            borderColor: Colors.transparent,
            elevation: 6,
            borderRadius: BorderRadius.circular(6),
            hintText: 'ユーザーIDで検索',
            onSearchButtonPressed: controller.searchFriend,
          ),
        ),
        Expanded(
          child: Consumer<UserDataController>(
            builder: (context, model, child) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<FriendBox>('friend_box').listenable(),
                builder: (context, Box<FriendBox> box, child) {
                  return ListView.builder(
                    itemCount: model.hitUsers.length,
                    itemBuilder: (context, index) {
                      // インデックス番目のユーザー情報
                      final user = model.hitUsers.elementAt(index);
                      // 既に友達(または自分)かどうか
                      final isAlreadyFriend = box.get(user.uid) != null;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                          ),
                          title: Text(user.displayName),
                          trailing: TextButton(
                            onPressed: isAlreadyFriend
                                ? null
                                : () {
                                    // 友達をfirestoreに追加
                                    controller.addFriendToFirestore(user);
                                    // 予定追加ページの友達フォームに追加
                                    controller.addRegisterPageAddFriendItems(
                                        context, user);
                                  },
                            child: isAlreadyFriend
                                ? const Text('追加済み')
                                : const Text('追加する'),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('SearchFriendPage#build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '友達を追加',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: searchBody(context),
      // body: FutureBuilder(
      //   // firestoreからユーザー情報を取得
      //   future: _fetchFirestoreUser(context),
      //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      //     // firestoreからのデータ取得が完了していない
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return searchBody(context);
      //   },
      // ),
    );
  }
}

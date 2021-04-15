import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:provider/provider.dart';

// 友達検索ページ
class SearchFriendPage extends StatelessWidget {
  Future<bool> _fetchFirestoreUser(BuildContext context) async {
    final controller = context.read<UserDataController>();
    // Firestore上の全ユーザーを取得する(アプリ起動後初回のみ)
    if (controller.userSet.isEmpty) {
      await controller.fetchFirestoreUser();
    }
    return true;
  }

  Widget searchBody(BuildContext context, QuerySnapshot snapshot) {
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
              return ListView.builder(
                itemCount: model.hitUsers.length,
                itemBuilder: (context, index) {
                  // インデックス番目のユーザー情報
                  final user = model.hitUsers.elementAt(index);
                  // 既に友達(または自分)かどうか
                  final isAlreadyFriend = snapshot.docs
                          .where((doc) => doc.id == user.uid)
                          .isNotEmpty ||
                      user.uid == FirebaseAuth.instance.currentUser!.uid;

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
      body: FutureBuilder(
        // firestoreからユーザー情報を取得
        future: _fetchFirestoreUser(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // firestoreからのデータ取得が完了していない
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot>(
            // users/uid/friendsコレクション内のドキュメント一覧をstreamで取得
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('friends')
                .snapshots(),
            builder: (context, snapshot) {
              // firestoreからのデータ取得が完了していない
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return searchBody(context, snapshot.data!);
            },
          );
          // return searchBody(context, snapshot.data!);
        },
      ),
    );
  }
}

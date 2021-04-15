import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/pages/home/search_friend_page.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:provider/provider.dart';

class FriendPage extends StatelessWidget {
  static const id = 'friend_page';

  Widget friendCard(UserData data) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data.photoUrl),
        ),
        title: Text(data.displayName),
        subtitle: Text(data.uid),
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
      body: StreamBuilder<QuerySnapshot>(
        // usersコレクション/uidドキュメント/friendsサブコレクションのstream
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('friends')
            .snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // データが取得できてなければSizedBoxを返す
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // 友達のuid
              final doc = snapshot.data!.docs[index];

              return StreamBuilder<DocumentSnapshot>(
                // usersコレクションから友達の情報を取得
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(doc.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  // データが取得できていなければSizedBoxを返す
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  // データが取得できた
                  return friendCard(
                    UserData(
                      uid: doc.id,
                      displayName: snapshot.data!.get('displayName') as String,
                      photoUrl: snapshot.data!.get('photoUrl') as String,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}

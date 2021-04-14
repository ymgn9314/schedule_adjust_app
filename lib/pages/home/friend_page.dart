import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/pages/home/search_friend_page.dart';
import 'package:high_hat/util/user_data.dart';

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
              final data = snapshot.data!.docs[index];
              return friendCard(
                UserData(
                  uid: data.id,
                  displayName: data.get('displayName') as String,
                  photoUrl: data.get('photoUrl') as String,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // 友達検索画面に遷移
        onPressed: () {
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

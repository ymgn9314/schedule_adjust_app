import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/pages/home/search_friend_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:high_hat/presentation/widget/user/user_card.dart';
import 'package:provider/provider.dart';

class FriendPage extends StatelessWidget {
  static const id = 'friend_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '友達',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<User>>(
          stream: context.watch<UserNotifier>().getFriendListStream(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<User>> snapshot,
          ) {
            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return UserCard(user: snapshot.data![index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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

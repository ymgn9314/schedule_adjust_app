import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        onLongPress: () {
          // 削除しますか？
          showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
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
                      context.read<UserNotifier>().deleteFromFriend(_user.id);
                      Navigator.pop(context);
                    },
                    child: const Text('はい'),
                  ),
                ],
              );
            },
          );
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_user.avatarUrl.value),
        ),
        title: Text(_user.userName.value),
        subtitle: Text(_user.userProfileId.value),
      ),
    );
  }
}

class UserCardAsSearchResult extends StatelessWidget {
  const UserCardAsSearchResult({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  Widget build(BuildContext context) {
    final selector = context.select(
        (UserNotifier notifier) async => notifier.isAlwaysFriend(_user.id));
    return FutureBuilder(
      future: selector,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox();
        }
        final isAlwaysFriend = snapshot.data!;
        final isMe = _user.id == context.read<UserNotifier>().loggedInUser!.id;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(_user.avatarUrl.value)),
            title: Text(_user.userName.value),
            trailing: isMe
                ? null
                : TextButton(
                    onPressed: isAlwaysFriend
                        ? null
                        : () async {
                            final notifier = context.read<UserNotifier>();
                            await notifier.addToFriend(_user.id);
                          },
                    child: isAlwaysFriend
                        ? const Text('既に友達です')
                        : const Text('友達に追加する'),
                  ),
          ),
        );
      },
    );
  }
}

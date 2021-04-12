import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/friend_data_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/util/show_top_snackbar.dart';
import 'package:provider/provider.dart';

class FriendForm extends StatelessWidget {
  // 友達一覧リスト
  List<Widget> friendList = [AddFriendComponent()];

  // 削除
  void delete(BuildContext context, FriendComponent component) {
    friendList.remove(component);
    context.read<RegisterScheduleController>().callNotifyListeners();
  }

  // 追加
  void add(BuildContext context, FriendComponent component) {
    // (自分合わせて)10人以上は追加できないようにする
    if (friendList.length > 9) {
      TopSnackBar().show(context, '9人以上は追加できません');
      return;
    }
    // 既に追加されていなければ追加する
    if (!friendList.contains(component)) {
      friendList.insert(friendList.length - 1, component);
      context.read<RegisterScheduleController>().callNotifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '友達',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Expanded(
          child: Selector<RegisterScheduleController, int>(
            selector: (context, model) => model.friendForm.friendList.length,
            builder: (context, length, child) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                ),
                scrollDirection: Axis.vertical,
                primary: false,
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  return friendList[index];
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// 友達単一コンポーネント
class FriendComponent extends StatelessWidget {
  const FriendComponent({
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: CircleAvatar(
        backgroundImage: NetworkImage(user.photoURL!),
      ),
      backgroundColor: Theme.of(context).accentColor,
      label: Text(
        user.displayName!,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      deleteIcon: Icon(
        Icons.cancel,
        color: Theme.of(context).buttonColor,
      ),
      onDeleted: () {
        // ×ボタンが押されたら候補日を削除する
        final controller = context.read<RegisterScheduleController>();
        controller.friendForm.delete(context, this);
      },
    );
  }
}

// 友達追加コンポーネント
class AddFriendComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:
          Icon(Icons.add_circle_outline, color: Theme.of(context).accentColor),
      onPressed: () async {
        // TODO(ymgn): 後でちゃんとする
        final user = FirebaseAuth.instance.currentUser;
        final registerScheduleController =
            context.read<RegisterScheduleController>();

        final friendDataController = context.read<FriendDataController>();
        final result = await showDialog<List<User?>>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: [
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pop<List<User?>>([]);
                  },
                  child: const Text('キャンセル'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    Navigator.of(context).pop<List<User?>>([user]);
                  },
                  child: const Text('決定'),
                ),
              ],
              title: const Text('友達を選択'),
              content: Container(
                width: double.maxFinite,
                child: ListView(children: friendDataController.friendList),
              ),
            );
          },
        );
        if (result != null) {
          result.forEach((element) {
            registerScheduleController.friendForm
                .add(context, FriendComponent(user: element!));
          });
        }
      },
    );
  }
}

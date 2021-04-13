import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/friend_data_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/util/show_top_snackbar.dart';
import 'package:high_hat/util/friend_data.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

@immutable
class FriendForm extends StatelessWidget {
  // 友達一覧リスト(重複を避けるためにセットにする)
  final LinkedHashSet<FriendData> selectedFriendSet = LinkedHashSet<FriendData>(
    equals: (lhs, rhs) => lhs == rhs,
    hashCode: (data) => data.hashCode,
  );
  // 友達追加コンポーネント
  final AddFriendComponent _addFriendComponent = AddFriendComponent();

  String? validate(BuildContext context) {
    // 友達を１人も選択していなかったら
    if (selectedFriendSet.isEmpty) {
      TopSnackBar().show(context, '友達を一人以上選択してください', isForceShow: true);
      return '友達を一人以上選択してください';
    }
    return null;
  }

  // 削除
  void delete(BuildContext context, FriendData data) {
    selectedFriendSet.remove(data);
    context.read<RegisterScheduleController>().callNotifyListeners();
  }

  // 追加
  void add(BuildContext context, FriendData data) {
    // 既に追加されていなければ追加する
    if (!selectedFriendSet.contains(data)) {
      selectedFriendSet.add(data);
      context.read<RegisterScheduleController>().callNotifyListeners();
    }
  }

  // 一括変更
  void applyChanges(BuildContext context, List<FriendData> list) {
    selectedFriendSet.clear();
    list.forEach((e) {
      selectedFriendSet.add(e);
    });
    context.read<RegisterScheduleController>().callNotifyListeners();
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
            selector: (context, model) =>
                model.friendForm.selectedFriendSet.length,
            builder: (context, length, child) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                ),
                scrollDirection: Axis.vertical,
                primary: false,
                itemCount: selectedFriendSet.length + 1,
                itemBuilder: (context, index) {
                  return [
                    // FriendDataをFriendComponentに変換する
                    ...selectedFriendSet
                        .map((e) => FriendComponent(data: e))
                        .toList(),
                    // 友達追加ボタン
                    _addFriendComponent
                  ][index];
                  // return friendList[index];
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
    required this.data,
  });

  final FriendData data;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      avatar: CircleAvatar(
        backgroundImage: NetworkImage(data.photoUrl),
      ),
      backgroundColor: context.read<AppDataController>().color[500],
      label: Text(
        data.displayName,
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
        controller.friendForm.delete(context, data);
      },
    );
  }
}

// 友達追加コンポーネント
class AddFriendComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendDataController = context.read<FriendDataController>();

    final _items = friendDataController.friendSet
        .map<MultiSelectItem<FriendData>>((elm) => MultiSelectItem<FriendData>(
              elm,
              elm.displayName,
            ))
        .toList();

    return IconButton(
      icon: Icon(Icons.add_circle_outline,
          color: context.read<AppDataController>().color[500]),
      onPressed: () async {
        // キーボードが開かれていたら閉じる
        FocusScope.of(context).unfocus();
        // TODO(ymgn): 後でちゃんと処理したほうがいい？
        // 20msec待つ（キーボード閉じるまで待つ）
        await Future<void>.delayed(const Duration(milliseconds: 20));

        final registerScheduleController =
            context.read<RegisterScheduleController>();

        // (自分合わせて)10人以上は追加できないようにする
        if (registerScheduleController.friendForm.selectedFriendSet.length >=
            9) {
          TopSnackBar().show(context, '9人までしか追加できません');
          return;
        }
        // ボトムシートを表示する
        await showModalBottomSheet<dynamic>(
          backgroundColor: context.read<AppDataController>().color[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          isScrollControlled: true, // required for min/max child size
          context: context,
          builder: (ctx) {
            return MultiSelectBottomSheet(
              confirmText: const Text(
                '決定',
                style: TextStyle(color: Colors.white),
              ),
              cancelText: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.white),
              ),
              itemsTextStyle: const TextStyle(color: Colors.white),
              selectedItemsTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              unselectedColor: Colors.white,
              selectedColor: Colors.white,
              checkColor: context.read<AppDataController>().color,
              title: const Text(
                '友達を選択',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: _items,
              initialValue: registerScheduleController
                  .friendForm.selectedFriendSet
                  .toList(),
              onConfirm: (values) {
                final list = values as List<FriendData>;
                // 変更を一括で反映する
                registerScheduleController.friendForm
                    .applyChanges(context, list);
              },
              maxChildSize: 0.5,
            );
          },
        );
      },
    );
  }
}

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/util/show_top_snackbar.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

@immutable
class FriendForm extends StatelessWidget {
  // 友達一覧リスト
  final LinkedHashSet<UserData> selectedFriendSet = LinkedHashSet<UserData>(
    equals: (lhs, rhs) => lhs == rhs,
    hashCode: (data) => data.hashCode,
  );
  // 友達追加コンポーネント
  // final AddFriendComponent _addFriendComponent = AddFriendComponent();

  String? validate(BuildContext context) {
    // 友達を１人も選択していなかったら
    if (selectedFriendSet.isEmpty) {
      TopSnackBar().show(context, '友達を一人以上選択してください', isForceShow: true);
      return '友達を一人以上選択してください';
    } else if (selectedFriendSet.length > 9) {
      TopSnackBar().show(context, '友達は9人までしか選択できません', isForceShow: true);
      return '友達は9人までしか選択できません';
    }
    return null;
  }

  // 削除
  void delete(BuildContext context, UserData data) {
    selectedFriendSet.remove(data);
    context.read<RegisterScheduleController>().callNotifyListeners();
  }

  // 追加
  void add(BuildContext context, UserData data) {
    print('friend add');
    // 既に追加されていなければ追加する
    if (!selectedFriendSet.contains(data)) {
      selectedFriendSet.add(data);
      context.read<RegisterScheduleController>().callNotifyListeners();
    }
  }

  // 一括変更
  void applyChanges(BuildContext context, List<UserData> list) {
    selectedFriendSet.clear();
    list.forEach(selectedFriendSet.add);
    context.read<RegisterScheduleController>().callNotifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       '友達',
    //       style: Theme.of(context).textTheme.bodyText1,
    //     ),
    //     Expanded(
    //       child: Selector<RegisterScheduleController, int>(
    //         selector: (context, model) =>
    //             model.friendForm.selectedFriendSet.length,
    //         builder: (context, length, child) {
    //           return GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 2,
    //               childAspectRatio: 5,
    //             ),
    //             scrollDirection: Axis.vertical,
    //             primary: false,
    //             itemCount: selectedFriendSet.length + 1,
    //             itemBuilder: (context, index) {
    //               return [
    //                 // FriendDataをFriendComponentに変換する
    //                 ...selectedFriendSet
    //                     .map((e) => FriendComponent(data: e))
    //                     .toList(),
    //                 // 友達追加ボタン
    //                 _addFriendComponent
    //               ][index];
    //               // return friendList[index];
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}

// // 友達単一コンポーネント
// class FriendComponent extends StatelessWidget {
//   const FriendComponent({
//     required User user,
//     // required this.data,
//   }) : _user = user;

//   final User _user;
//   // final UserData data;

//   @override
//   Widget build(BuildContext context) {
//     return InputChip(
//       avatar: CircleAvatar(
//         backgroundImage: NetworkImage(_user.avatarUrl.value),
//       ),
//       backgroundColor: context.read<AppDataController>().color[500],
//       label: Text(
//         _user.userName.value,
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       deleteIcon: const Icon(
//         Icons.cancel,
//         color: Colors.white,
//       ),
//       onDeleted: () {
//         // ×ボタンが押されたら友達を削除する
//         final controller = context.read<RegisterScheduleController>();
//         controller.friendForm.delete(context, _user);
//       },
//     );
//   }
// }

// // 友達追加コンポーネント
// class AddFriendComponent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.add_circle_outline,
//           color: context.read<AppDataController>().color[500]),
//       onPressed: () async {
//         // キーボードが開かれていたら閉じる
//         FocusScope.of(context).unfocus();
//         // TODO(ymgn): 後でちゃんと処理したほうがいい？
//         // 50msec待つ（キーボード閉じるまで待つ）
//         await Future<void>.delayed(const Duration(milliseconds: 50));

//         final registerScheduleController =
//             context.read<RegisterScheduleController>();
//         final userDataController = context.read<UserDataController>();

//         // ボトムシートを表示する
//         await showModalBottomSheet<dynamic>(
//           backgroundColor: context.read<AppDataController>().color[400],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           isScrollControlled: true, // required for min/max child size
//           context: context,
//           builder: (ctx) {
//             return MultiSelectBottomSheet(
//               confirmText: const Text(
//                 '決定',
//                 style: TextStyle(color: Colors.white),
//               ),
//               cancelText: const Text(
//                 'キャンセル',
//                 style: TextStyle(color: Colors.white),
//               ),
//               itemsTextStyle: const TextStyle(color: Colors.white),
//               selectedItemsTextStyle: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//               unselectedColor: Colors.white,
//               selectedColor: Colors.white,
//               checkColor: context.read<AppDataController>().color,
//               title: const Text(
//                 '友達を選択',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               items: userDataController.registerPageAddFriendItems,
//               initialValue: registerScheduleController
//                   .friendForm.selectedFriendSet
//                   .toList(),
//               onConfirm: (values) {
//                 final list = values as List<UserData>;
//                 // 変更を一括で反映する
//                 registerScheduleController.friendForm
//                     .applyChanges(context, list);
//               },
//               maxChildSize: 0.5,
//             );
//           },
//         );
//       },
//     );
//   }
// }

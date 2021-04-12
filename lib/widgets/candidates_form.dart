// import 'package:flutter/material.dart';
// import 'package:high_hat/controller/register_schedule_controller.dart';
// import 'package:high_hat/util/show_cupertino_date_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// // 候補日一覧フォーム
// class CandidateDatesForm extends StatelessWidget {
//   // 候補日一覧リスト
//   List<Widget> candidateDateList = [AddCandidateDateComponent()];

//   // 候補日を追加
//   void addCandidateDate(BuildContext context, DateTime datetime) {
//     candidateDateList.insert(
//       candidateDateList.length - 1,
//       CandidateDateComponent(datetime),
//     );
//     context.read<RegisterScheduleController>().callNotifyListeners();
//   }

//   // 候補日を削除
//   void deleteCandidateDate(
//       BuildContext context, CandidateDateComponent component) {
//     candidateDateList.remove(component);
//     context.read<RegisterScheduleController>().callNotifyListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '候補日',
//           style: Theme.of(context).textTheme.bodyText1,
//         ),
//         Expanded(
//           child: Selector<RegisterScheduleController, int>(
//             selector: (context, model) =>
//                 model.candidateDatesForm.candidateDateList.length,
//             builder: (context, length, child) {
//               return GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 5,
//                 ),
//                 scrollDirection: Axis.vertical,
//                 primary: false,
//                 itemCount: candidateDateList.length,
//                 itemBuilder: (context, index) {
//                   return candidateDateList[index];
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// // 候補日コンポーネント(単一の候補日パーツ)
// class CandidateDateComponent extends StatelessWidget {
//   const CandidateDateComponent(this._dateTime);
//   final DateTime _dateTime;

//   @override
//   Widget build(BuildContext context) {
//     return InputChip(
//       backgroundColor: Theme.of(context).accentColor,
//       label: Text(
//         DateFormat.yMMMMEEEEd().add_jms().format(_dateTime),
//         style: Theme.of(context).textTheme.bodyText1,
//       ),
//       deleteIcon: Icon(
//         Icons.cancel,
//         color: Theme.of(context).buttonColor,
//       ),
//       onDeleted: () {
//         // ×ボタンが押されたら候補日を削除する
//         final controller = context.read<RegisterScheduleController>();
//         controller.candidateDatesForm.deleteCandidateDate(context, this);
//       },
//     );
//   }
// }

// // 候補日追加コンポーネント
// class AddCandidateDateComponent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon:
//           Icon(Icons.add_circle_outline, color: Theme.of(context).accentColor),
//       onPressed: () async {
//         final controller = context.read<RegisterScheduleController>();
//         final datetime = await showCupertinoDatePicker(context);
//         // 日付が選択されていたらフォームを更新する
//         if (datetime != null) {
//           controller.candidateDatesForm.addCandidateDate(context, datetime);
//         }
//       },
//     );
//   }
// }

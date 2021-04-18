import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/util/custom_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAnswerPage extends StatelessWidget {
  static const id = 'view_answer_page';

  ViewAnswerPage(this._scheduleId, this._answerNumber);

  // schedulesoコレクションのスケジュールID
  final String _scheduleId;
  // 回答済みの人数
  final int _answerNumber;

  Widget viewBody(QuerySnapshot snapshot, BuildContext context) {
    // 日付一覧を格納
    final dates = <String>[]; // etc: 2021-04-21, 2021-04-22
    // ユーザーごとの回答を格納(uid: int)
    // etc: uid: 2021-04-21: 0
    final userAnswers = <String, Map<String, int>>{}; // <uid, <date, anser>>

    final future =
        Future.forEach<QueryDocumentSnapshot>(snapshot.docs, (doc) async {
      // 回答していたら
      if (doc.get('isAnswer') as bool) {
        final answerDocs = await FirebaseFirestore.instance
            .collection('schedules')
            .doc(_scheduleId)
            .collection('users')
            .doc(doc.id)
            .collection('answers')
            .get();
        // まだ日付一覧に値が格納されていなかったら
        if (dates.isEmpty) {
          for (final answerDoc in answerDocs.docs) {
            dates.add(answerDoc.id);
          }
        }
        // ユーザーの回答を格納
        final answers = <String, int>{};
        for (final answerDoc in answerDocs.docs) {
          answers[answerDoc.id] = answerDoc.get('answer') as int;
        }
        userAnswers[doc.id] = answers;
      }
    });

    return FutureBuilder<dynamic>(
      future: future,
      builder: (context, snapshot) {
        // データ取得が完了していないなら
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
            // スクロールする方向
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                const DataColumn(
                  label: Text(
                    'ユーザー',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...dates.map((e) => DataColumn(
                        label: Center(
                      child: Text(
                        DateFormat('M/d(E)')
                            .format(DateFormat('y-M-d').parseStrict(e)),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))),
              ],
              rows: <DataRow>[
                ...userAnswers.entries.map((e) {
                  return DataRow(
                    cells: <DataCell>[
                      // ユーザー(アイコン+名前)
                      DataCell(
                        context
                            .read<UserDataController>()
                            .getUserCardFromFirestore(e.key),
                      ),
                      ...e.value.entries.map((d) {
                        return DataCell(
                          d.value == 0
                              ? customIcon(
                                  'assets/circle.svg',
                                  context.read<AppDataController>().color[600],
                                  20) // ◯
                              : d.value == 1
                                  ? customIcon(
                                      'assets/triangle.svg',
                                      context
                                          .read<AppDataController>()
                                          .color[200],
                                      20) // △
                                  : customIcon(
                                      'assets/cross.svg', Colors.grey, 20), // ×
                        );
                      }),
                    ],
                  );
                }).toList(),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('ViewAnswerPage#build()');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'みんなの回答',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _answerNumber == 0
          ? const Center(
              child: Text(
              'まだ誰も回答していません',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
          : StreamBuilder<QuerySnapshot>(
              // schedules/scheduleId/usersコレクションを取得
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .doc(_scheduleId)
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                // firestoreからの取得が完了していない
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return viewBody(snapshot.data!, context);
              },
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:provider/provider.dart';

import 'answer_schedule_page.dart';

class SchedulePage extends StatelessWidget {
  static const id = 'schedule_page';

  Widget scheduleCard(
      BuildContext context, DocumentSnapshot schedule, QuerySnapshot users) {
    final friendNumber = users.docs.length;
    final answerNumber =
        users.docs.where((user) => user.get('isAnswer') as bool).length;

    return FutureBuilder<UserData>(
      // オーナーの情報を取得
      future: context
          .read<UserDataController>()
          .getUserDataFromFirestore(schedule.get('ownerId') as String),
      builder: (context, userData) {
        // 取得できてなければ
        if (!userData.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Card(
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(userData.data!.photoUrl)),
            title: Text(schedule.get('title') as String),
            subtitle: Text(schedule.get('remarks') as String),
            trailing: Text('参加者$friendNumber人(回答済み$answerNumber人)'),
            onTap: () {
              // TODO(ymgn): タップされた時の処理
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (context) {
                  return AnswerSchedulePage(schedule.id, answerNumber);
                }),
              );
            },
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
                    content: const Text('削除した予定は閲覧することができなくなります'),
                    actions: <Widget>[
                      // ボタン領域
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('いいえ'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<ScheduleDataController>()
                              .deleteScheduleFromFirestore(schedule.id);
                          Navigator.pop(context);
                        },
                        child: const Text('はい'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('SchedulePage#build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 自分のスケジュール一覧を取得する
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('schedules')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> schedules) {
          // firestoreから取得できてなければ
          if (!schedules.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // スケジュールごとにリストを作成する
          return ListView.builder(
            itemCount: schedules.data!.docs.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('schedules')
                    .doc(schedules.data!.docs[index].id)
                    .get(),
                builder: (context, schedule) {
                  // firestoreからデータ取得が完了していない
                  if (!schedule.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('schedules')
                        .doc(schedules.data!.docs[index].id)
                        .collection('users')
                        .snapshots(),
                    builder: (context, users) {
                      // firestoreからデータ取得が完了していない
                      if (!users.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return scheduleCard(context, schedule.data!, users.data!);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // firestoreから予定追加画面に表示する友達一覧をキャッシュする
          await context
              .read<UserDataController>()
              .fetchRegisterPageAddFriendItems();

          // 予定登録ページへ遷移
          await Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) {
                return RegisterSchedulePage();
              },
            ),
          );
        },
        child: Stack(
          children: [
            const Positioned(
              top: 18,
              left: 7,
              child: Icon(
                Icons.add,
                size: 16,
                color: Colors.white70,
              ),
            ),
            const Positioned(
              top: 18,
              left: 20,
              child: Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

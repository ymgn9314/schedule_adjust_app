import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:provider/provider.dart';

class ViewAnswerPage extends StatelessWidget {
  static const id = 'view_answer_page';

  ViewAnswerPage(this._scheduleId);

  // schedulesoコレクションのスケジュールID
  final String _scheduleId;

  Widget viewBody(QuerySnapshot snapshot) {
    // こんな感じで取得できる
    // snapshot.docs[0].get('isAnswer') as bool
    return SizedBox(
      child: Text('みんなの回答だよ'),
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
      body: StreamBuilder<QuerySnapshot>(
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
          return viewBody(snapshot.data!);
        },
      ),
    );
  }
}

import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:high_hat/util/schedule_data.dart';

class ScheduleDataController extends ChangeNotifier {
  // firestoreから取得したスケジュールを格納する
  // ex) 20210416: 1
  Map<String, int> schedules = <String, int>{};
  // 既に回答したか
  bool isAnswer = false;

  // firestoreからスケジュール一覧を取得する
  Future<bool> fetchSchedule(String _scheduleId) async {
    // 前回取得したスケジュールをクリアする
    schedules.clear();
    isAnswer = false;

    // 既に回答したかを取得
    final userDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    isAnswer = userDoc.get('isAnswer') as bool;

    // 回答ドキュメント一覧を取得
    final answerDocs = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('answers')
        .get();

    for (var i = 0; i < answerDocs.docs.length; i++) {
      schedules[answerDocs.docs[i].id] =
          answerDocs.docs[i].get('answer') as int;
    }
    notifyListeners();
    return true;
  }

  // 回答をfirestoreに送信する
  Future<void> sendAnswer(String _scheduleId) async {
    // schedules/scheduleId/users/uid/answersコレクションの参照を取得
    final userDocRef = FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // バッチ書き込みする
    final batch = FirebaseFirestore.instance.batch();
    schedules.forEach((key, value) {
      batch.update(userDocRef.collection('answers').doc(key),
          <String, int>{'answer': value});
    });
    batch.update(userDocRef, <String, bool>{'isAnswer': true});

    // firestoreにコミットする
    await batch.commit().then((value) {
      // コミットが成功したときの処理
    });

    notifyListeners();
  }
}

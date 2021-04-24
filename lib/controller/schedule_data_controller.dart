import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:provider/provider.dart';

class ScheduleDataController extends ChangeNotifier {
  // firestoreから取得したスケジュールを格納する
  // ex) 20210416: 1
  Map<String, int> schedules = <String, int>{};
  // 既に回答したか
  bool isAnswer = false;

  // firestoreからスケジュール一覧を取得する
  Future<bool> fetchSchedule(BuildContext context, String _scheduleId) async {
    // 前回取得したスケジュールをクリアする
    schedules.clear();
    isAnswer = false;

    final user = context.read<LoginAuthenticationController>().user;

    // 既に回答したかを取得
    final userDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(user!.uid)
        .get();
    isAnswer = userDoc.get('isAnswer') as bool;

    // 回答ドキュメント一覧を取得
    final answerDocs = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(user.uid)
        .collection('answers')
        .get();

    for (var i = 0; i < answerDocs.docs.length; i++) {
      schedules[answerDocs.docs[i].id] =
          answerDocs.docs[i].get('answer') as int;
    }
    return true;
  }

  // 回答をfirestoreに送信する
  Future<void> sendAnswer(BuildContext context, String _scheduleId) async {
    final user = context.read<LoginAuthenticationController>().user;

    // schedules/scheduleId/users/uid/answersコレクションの参照を取得
    final userDocRef = FirebaseFirestore.instance
        .collection('schedules')
        .doc(_scheduleId)
        .collection('users')
        .doc(user!.uid);

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
  }

  // firestoreからスケジュールを削除する
  // 参照のみ削除、参照カウントが0になったらスケジュール本体も削除
  Future<bool> deleteScheduleFromFirestore(
      BuildContext context, String scheduleId) async {
    final user = context.read<LoginAuthenticationController>().user;

    // /schedules/scheduleIdの参照
    final scheduleDocRef =
        FirebaseFirestore.instance.collection('schedules').doc(scheduleId);

    // /users/uid/schedules/scheduleIdの参照
    final userScheduleDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('schedules')
        .doc(scheduleId);

    // スケジュール本体への参照を削除、参照カウントをデクリメント
    final batch = FirebaseFirestore.instance.batch()
      ..delete(userScheduleDoc)
      ..update(
        scheduleDocRef,
        <String, FieldValue>{'refCount': FieldValue.increment(-1)},
      );
    // 変更をfirestoreにコミット
    await batch.commit();

    // 更新後、参照カウントを取得
    final doc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(scheduleId)
        .get();
    final refCount = doc.get('refCount') as int;

    print('refCount : $refCount');

    // 参照カウントが0になっていたら自分しか参照してないからスケジュール本体も消す
    if (refCount <= 0) {
      print('delete refCount <= 0');
      //final scheduleRef = FirebaseFirestore.instance.collection('schedules');
      //await scheduleRef.doc(scheduleId).delete();
      final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast2')
          .httpsCallable(
        'recursiveDelete',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 5),
        ),
      );
      // return path?
      try {
        final result = await callable
            .call<dynamic>(<String, dynamic>{'path': '/schedules/$scheduleId'});
        print(result.data);
      } catch (e) {
        print('catch exception on cloud functions');
      }
    }

    return true;
  }
}

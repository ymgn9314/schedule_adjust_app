import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterSchedulePage extends StatefulWidget {
  static const id = 'register_schedule_page';

  @override
  _RegisterSchedulePageState createState() => _RegisterSchedulePageState();
}

class _RegisterSchedulePageState extends State<RegisterSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> registerScheduleAndPopNavigation(BuildContext context) async {
    // 予定を登録する
    final user = context.read<LoginAuthenticationController>().user;
    final rController = context.read<RegisterScheduleController>();

    // 予定作成者(オーナー)のUserData
    final owner = UserData(
        uid: user!.uid, displayName: user.displayName, photoUrl: user.photoUrl);

    // 参加者(オーナー含む)のUserData
    final participantUsers = rController.friendForm.selectedFriendSet
      ..add(owner);

    // firestoreに予定を追加する
    // 予定にはscheduleId(予定作成者のuid + 今の日時String型)を付与する
    // 今の日時
    final dateNow = DateFormat('yyyyMMddHHmms').format(DateTime.now())
      ..replaceAll(RegExp(r'\s'), '');

    final scheduleId = owner.uid + dateNow;

    // 予定のタイトル
    final title = rController.title;
    // 予定の備考欄
    final remarks = rController.remarks;

    // バッチ書き込みする
    final batch = FirebaseFirestore.instance.batch();

    // 参加者全員(オーナー含む)のscheduleサブコレクションにscheduleIdを追加
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final emptyData = <String, dynamic>{};

    for (final user in participantUsers) {
      // users/uid/schedules/scheduleIdドキュメントを作成
      // scheduleIdで/schedulesコレクション上のスケジュールを参照できる
      final userDocReference =
          usersCollection.doc(user.uid).collection('schedules').doc(scheduleId);
      batch.set(userDocReference, emptyData);
    }

    // schedules/scheduleIdに予定のタイトル, 備考欄, 作成日時を追加する
    final schedulesDocReference =
        FirebaseFirestore.instance.collection('schedules').doc(scheduleId);
    batch.set(schedulesDocReference, <String, dynamic>{
      'title': title,
      'remarks': remarks,
      'createdAt': DateFormat('yyyy/MM/dd/HH:mm:s').format(DateTime.now()),
      'ownerId': owner.uid,
      'refCount': participantUsers.length,
    });

    for (final user in participantUsers) {
      final doc = schedulesDocReference.collection('users').doc(user.uid);
      // 予定に回答したか
      batch.set(doc, <String, dynamic>{'isAnswer': false});
      // 回答コレクション
      final answerCollection = doc.collection('answers');
      for (final day in rController.calendarForm.selectedDays) {
        batch.set(answerCollection.doc(DateFormat('yyyy-MM-dd').format(day)),
            <String, dynamic>{'answer': 1});
      }
    }

    // firestoreにコミット
    await batch.commit().then((value) {
      // コミットに成功した時の処理
    });

    // 画面を抜ける
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print('_Home in RegisterSchedulePage#build()');

    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return ChangeNotifierProvider<RegisterScheduleController>(
      create: (context) => RegisterScheduleController(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '予定を追加',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Consumer<RegisterScheduleController>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, bottomSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // カレンダーフォーム
                      model.calendarForm,
                      // 題名
                      model.titleForm,
                      // 備考欄
                      model.remarksForm,
                      // 友達一覧
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: model.friendForm,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () async {
                            // キーボードが開かれていたら閉じる
                            FocusScope.of(context).unfocus();
                            // バリデーションが無効なら登録できない
                            final isValidate =
                                _formKey.currentState!.validate();
                            final isValidate2 =
                                model.friendForm.validate(context) == null;
                            // 予定をfirestoreに追加
                            if (isValidate && isValidate2) {
                              await registerScheduleAndPopNavigation(context);
                            }
                          },
                          child: const Text(
                            '予定を登録',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

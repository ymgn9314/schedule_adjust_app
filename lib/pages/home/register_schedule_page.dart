import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/util/schedule_data.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:provider/provider.dart';

class RegisterSchedulePage extends StatefulWidget {
  static const id = 'register_schedule_page';

  @override
  _RegisterSchedulePageState createState() => _RegisterSchedulePageState();
}

class _RegisterSchedulePageState extends State<RegisterSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  void registerScheduleAndPopNavigation(BuildContext context) {
    // 予定を登録する
    final user = FirebaseAuth.instance.currentUser;
    final sController = context.read<ScheduleDataController>();
    final rController = context.read<RegisterScheduleController>();

    // 予定作成者(オーナー)のFriendData
    final owner = UserData(
        uid: user!.uid,
        displayName: user.displayName!,
        photoUrl: user.photoURL!);

    // 参加者(オーナー含む)のFriendData
    final participantsSet = rController.friendForm.selectedFriendSet
      ..add(owner);

    // 日付ごとの回答
    final answerMap = LinkedHashMap<DateTime, Answer>();
    rController.calendarForm.selectedDays.forEach((e) {
      answerMap[e] = Answer.either;
    });

    // 参加者(オーナー含む)のFriendAnswerData
    var participants = LinkedHashSet<FriendAnswerData>();
    participantsSet.forEach(
      (e) {
        participants.add(
          FriendAnswerData(
            person: e,
            isAnswer: false,
            answerMap: answerMap,
          ),
        );
      },
    );

    sController.add(
        title: rController.titleForm.content,
        remarks: rController.remarksForm.content,
        owner: owner,
        participants: participants);
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
                          onPressed: () {
                            // キーボードが開かれていたら閉じる
                            FocusScope.of(context).unfocus();
                            // バリデーションが無効なら登録できない
                            final isValidate =
                                _formKey.currentState!.validate();
                            final isValidate2 =
                                model.friendForm.validate(context) == null;
                            if (isValidate && isValidate2) {
                              registerScheduleAndPopNavigation(context);
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

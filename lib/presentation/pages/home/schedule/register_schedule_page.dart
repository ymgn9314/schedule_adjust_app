import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_answer_calendar_body.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_answer_remarks_body.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_answer_title_body.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_answer_user_body.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:high_hat/presentation/notifier/schedule_notifier.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class RegisterSchedulePage extends StatelessWidget {
  const RegisterSchedulePage({Key? key}) : super(key: key);
  static const id = 'RegisterSchedulePage';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: ChangeNotifierProvider<RegisterScheduleNotifier>(
        create: (context) => RegisterScheduleNotifier(),
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                '予定を作成する',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: FutureBuilder(
              future: context.read<UserNotifier>().getFriendList(),
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;

                return Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // タイトル
                            const RegisterAnswerTitleBody(),
                            // 備考欄(任意)
                            const RegisterAnswerRemarksBody(),
                            // カレンダー
                            const RegisterAnswerCalendarBody(),
                            // 友達
                            RegisterAnswerUserBody(userList: data),
                          ],
                        ),
                      ),
                    ),
                    // 登録する
                    Container(
                      margin: const EdgeInsets.all(32),
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          final sNotifier = context.read<ScheduleNotifier>();
                          final rNotifier =
                              context.read<RegisterScheduleNotifier>();
                          final uNotifier = context.read<UserNotifier>();

                          // バリデーション処理
                          if (rNotifier.validate() != null) {
                            return;
                          }

                          // 予定作成前に自分を追加する
                          context
                              .read<RegisterScheduleNotifier>()
                              .onUserSelected(uNotifier.loggedInUser!);

                          // 予定を作成する
                          await sNotifier.createSchedule(
                            title: rNotifier.title,
                            ownerUrl: uNotifier.loggedInUser!.avatarUrl.value,
                            remarks: rNotifier.remarks,
                            scheduleList: rNotifier.selectedDateTimes,
                            userList: rNotifier.selectedUserStrings,
                            answerUserList: <String>[],
                          );

                          // 前の画面に戻す
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '予定を作成する',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/user/value/user_id.dart';
import 'package:high_hat/presentation/pages/home/schedule/answer_schedule_page.dart';
import 'package:high_hat/presentation/notifier/answer_notifier.dart';
import 'package:high_hat/presentation/notifier/schedule_notifier.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:high_hat/common/extension/string_extension.dart';

class ScheduleCard extends StatelessWidget {
  ScheduleCard({
    Key? key,
    required Schedule schedule,
  })  : _schedule = schedule,
        super(key: key);

  final Schedule _schedule;

  final _userId = Helpers.userId ?? '';

  @override
  Widget build(BuildContext context) {
    final friendNumber = _schedule.userList.length;
    final answerNumber = _schedule.answerUserList.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: NetworkImage(_schedule.ownerUrl.value)),
        // タイトル
        title: Text(_schedule.title.value.length > 13
            ? '${_schedule.title.value.splitByLength(13)[0]}...'
            : _schedule.title.value),
        // 備考欄(11文字より大きい場合は...で表示を省略する)
        subtitle: Text(
          _schedule.remarks.value.length > 15
              ? '${_schedule.remarks.value.splitByLength(15)[0]}...'
              : _schedule.remarks.value,
        ),
        trailing: Text('回答$answerNumber / $friendNumber人'),
        onTap: () async {
          // TODO(ymgn9314): AnswerSchedulePage側でFutureBuilderで取得する方がベター

          // 既に回答したかを取得
          final isAlreadyAnswer =
              _schedule.answerUserList.contains(UserId(Helpers.userId ?? ''));
          // 既に回答した回答を取得して初期化する
          final answerList = await context
              .read<UserNotifier>()
              .getAnswer(_userId, _schedule.id.value);
          context.read<AnswerNotifier>().initAnswer(
                setAnswer: answerList,
                isAlreadyAnswer: isAlreadyAnswer,
              );

          await Navigator.of(context).push<void>(
            MaterialPageRoute(builder: (context) {
              return AnswerSchedulePage(
                schedule: _schedule,
              );
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
                          .read<ScheduleNotifier>()
                          .deleteSchedule(_schedule.id.value);
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
  }
}

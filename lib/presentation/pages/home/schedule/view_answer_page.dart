import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/presentation/pages/home/schedule/view_answer_comment_body.dart';
import 'package:high_hat/presentation/pages/home/schedule/view_answer_number_body.dart';
import 'package:high_hat/presentation/notifier/schedule_notifier.dart';
import 'package:provider/provider.dart';

class ViewAnswerPage extends StatelessWidget {
  static const id = 'view_answer_page';

  const ViewAnswerPage({
    Key? key,
    required Schedule schedule,
  })  : _schedule = schedule,
        super(key: key);

  final Schedule _schedule;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'みんなの回答',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          context
              .read<ScheduleNotifier>()
              .getAnswerNumberList(_schedule.id.value),
          context
              .read<ScheduleNotifier>()
              .getUserListInSchedule(_schedule.id.value),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final answerList = snapshot.data![0] as List<Map<Answer, int>>?;
          final userList = snapshot.data![1] as List<User>?;

          return answerList == null
              ? const Center(
                  child: Text('まだ誰も回答していません'),
                )
              : Column(
                  children: [
                    Flexible(
                      child: ViewAnswerNumberBody(
                          schedule: _schedule, answerList: answerList),
                    ),
                    ViewAnswerCommentBody(
                        schedule: _schedule, userList: userList),
                  ],
                );
        },
      ),
    );
  }
}

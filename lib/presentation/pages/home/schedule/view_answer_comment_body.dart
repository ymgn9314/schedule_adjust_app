import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/presentation/pages/home/schedule/view_answer_comment_balloon_left_body.dart';
import 'package:high_hat/presentation/pages/home/schedule/view_answer_comment_balloon_right_body.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class ViewAnswerCommentBody extends StatelessWidget {
  const ViewAnswerCommentBody({
    Key? key,
    required Schedule schedule,
    required List<User>? userList,
  })  : _schedule = schedule,
        _userList = userList,
        super(key: key);

  final Schedule _schedule;
  final List<User>? _userList;

  @override
  Widget build(BuildContext context) {
    // コメントしているユーザーだけのリストを作成する
    final commentedUserList = _userList
            ?.where((e) =>
                e.scheduleComment[_schedule.id]?.value.isNotEmpty ?? false)
            .toList() ??
        <User>[];

    return commentedUserList.isEmpty
        ? const SizedBox()
        : Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[50]
                  : Colors.grey[850],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]!
                      : Colors.grey[900]!,
                  spreadRadius: 4,
                  blurRadius: 4,
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: commentedUserList.length,
              itemBuilder: (BuildContext context, int index) {
                // 自分のコメントは右側、他のユーザーのコメントは左側に表示
                return context.read<UserNotifier>().loggedInUser!.id ==
                        commentedUserList[index].id
                    ? ViewAnswerCommentBalloonRightBody(
                        scheduleId: _schedule.id,
                        user: commentedUserList[index],
                      )
                    : ViewAnswerCommentBalloonLeftBody(
                        scheduleId: _schedule.id,
                        user: commentedUserList[index],
                      );
              },
            ),
          );
  }
}

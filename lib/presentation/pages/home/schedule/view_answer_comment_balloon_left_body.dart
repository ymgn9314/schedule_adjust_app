import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/domain/user/user.dart';

class ViewAnswerCommentBalloonLeftBody extends StatelessWidget {
  const ViewAnswerCommentBalloonLeftBody({
    Key? key,
    required ScheduleId scheduleId,
    required User user,
  })  : _scheduleId = scheduleId,
        _user = user,
        super(key: key);

  final ScheduleId _scheduleId;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(_user.avatarUrl.value),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_user.userName.value),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                //alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[300]!
                          : Colors.grey[900]!,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    _user.scheduleComment[_scheduleId]?.value ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

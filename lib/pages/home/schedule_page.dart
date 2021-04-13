import 'package:flutter/material.dart';
import 'package:high_hat/controller/friend_data_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/util/schedule_data.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  static const id = 'schedule_page';

  Widget ScheduleCard(ScheduleData data) {
    final friendNumber = data.participants.length;
    int answerNumber = 0;
    data.participants.forEach((e) {
      if (e.isAnswer) answerNumber++;
    });
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data.owner.photoUrl),
      ),
      title: Text(data.title),
      subtitle: Text(data.remarks),
      trailing: Text('参加者${friendNumber}人(回答済み${answerNumber}人)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('SchedulePage#build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Selector<ScheduleDataController, int>(
        selector: (context, model) => model.scheduleList.length,
        builder: (context, length, child) {
          return ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) {
              // スケジュールカードを作成して返す
              final ScheduleData data =
                  context.read<ScheduleDataController>().scheduleList[index];
              return ScheduleCard(data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context2) =>
                  ChangeNotifierProvider<ScheduleDataController>.value(
                value:
                    Provider.of<ScheduleDataController>(context, listen: false),
                child: ChangeNotifierProvider<FriendDataController>.value(
                  value:
                      Provider.of<FriendDataController>(context, listen: false),
                  child: RegisterSchedulePage(),
                ),
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              size: 16,
            ),
            Icon(
              Icons.calendar_today,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/util/schedule_data.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  static const id = 'schedule_page';

  Widget ScheduleCard(ScheduleData data, MaterialColor cardMaterialColor) {
    final friendNumber = data.participants.length;
    int answerNumber = 0;
    data.participants.forEach((e) {
      if (e.isAnswer) answerNumber++;
    });
    // TODO(ymgn): 引数のcardMaterialColor使う?
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data.owner.photoUrl),
        ),
        title: Text(data.title),
        subtitle: Text(data.remarks),
        trailing: Text('参加者${friendNumber}人(回答済み${answerNumber}人)'),
      ),
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
              final data =
                  context.read<ScheduleDataController>().scheduleList[index];
              final color = context.read<AppDataController>().color;
              return ScheduleCard(data, color);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 予定登録ページへ遷移
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) {
                return RegisterSchedulePage();
              },
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

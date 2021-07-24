import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/schedule/value/schedule_id.dart';
import 'package:high_hat/presentation/notifier/schedule_notifier.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_schedule_page.dart';
import 'package:high_hat/presentation/widget/schedule/schedule_card.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  static const id = 'schedule_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '予定',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        // スケジュール一覧をStreamで取得
        child: StreamBuilder<List<ScheduleId>>(
          stream: context.read<ScheduleNotifier>().fetchScheduleIdListStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<ScheduleId>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // スケジュールID
                final id = snapshot.data![index].value;
                // スケジュールごとにStreamで監視する
                return StreamBuilder(
                  stream:
                      context.read<ScheduleNotifier>().fetchScheduleStream(id),
                  builder: (BuildContext context,
                      AsyncSnapshot<Schedule?> snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox();
                    }

                    final schedule = snapshot.data!;
                    return ScheduleCard(schedule: schedule);
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          // 予定登録ページへ遷移
          await Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) {
                return const RegisterSchedulePage();
              },
            ),
          );
        },
        child: Stack(
          children: const [
            Positioned(
              top: 18,
              left: 7,
              child: Icon(Icons.add, size: 16, color: Colors.white70),
            ),
            Positioned(
              top: 18,
              left: 20,
              child:
                  Icon(Icons.calendar_today, size: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

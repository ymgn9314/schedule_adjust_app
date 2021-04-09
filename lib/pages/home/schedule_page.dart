import 'package:flutter/material.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  static const id = 'schedule_page';
  @override
  Widget build(BuildContext context) {
    print('SchedulePage#build()');

    return Scaffold(
      body: Consumer<ScheduleDataController>(
        builder: (context, model, child) {
          return ListView.builder(
            itemCount: model.scheduleList.length,
            itemBuilder: (context, index) {
              return model.scheduleList[index];
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
                child: RegisterSchedulePage(),
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

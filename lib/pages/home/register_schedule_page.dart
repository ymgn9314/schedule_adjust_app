import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:provider/provider.dart';

class RegisterSchedulePage extends StatelessWidget {
  static const id = 'register_schedule_page';

  void registerScheduleAndPopNavigation(BuildContext context) {
    // 予定を登録する
    final scheduleDataController = context.read<ScheduleDataController>();
    final registerScheduleController =
        context.read<RegisterScheduleController>();
    scheduleDataController.add(
      titleForm: registerScheduleController.titleForm,
      deadlineForm: registerScheduleController.deadlineForm,
      candidateDatesForm: registerScheduleController.candidateDatesForm,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print('_Home in RegisterSchedulePage#build()');

    return ChangeNotifierProvider<RegisterScheduleController>(
      create: (context) => RegisterScheduleController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '予定を追加',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<RegisterScheduleController>(
          builder: (context, model, child) {
            return Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 題名
                        model.titleForm,
                        // 締め切り日
                        model.deadlineForm,
                        const SizedBox(height: 32),
                        // 候補日一覧
                        Expanded(child: model.candidateDatesForm),
                        const SizedBox(height: 32),
                        Expanded(child: model.candidateDatesForm),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  child: ElevatedButton(
                    onPressed: () => registerScheduleAndPopNavigation(context),
                    child: const Text('予定を登録'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

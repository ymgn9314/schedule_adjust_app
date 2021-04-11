import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '予定を追加',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<RegisterScheduleController>(
          builder: (context, model, child) {
            return Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // カレンダーフォーム
                        model.calendarForm,
                        // 題名
                        model.titleForm,
                        // 備考欄
                        model.remarksForm,
                        const SizedBox(height: 32),
                        // 候補日一覧
                        // Expanded(child: model.candidateDatesForm),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () => registerScheduleAndPopNavigation(context),
                    child: const Text(
                      '予定を登録',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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

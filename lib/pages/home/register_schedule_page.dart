import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:provider/provider.dart';

class RegisterSchedulePage extends StatelessWidget {
  static const id = 'register_schedule_page';
  @override
  Widget build(BuildContext context) {
    print('_Home in RegisterSchedulePage#build()');

    return ChangeNotifierProvider<RegisterScheduleController>(
      create: (context) => RegisterScheduleController(),
      builder: (context, _) {
        // フォームを初期化する(ビルドが終わった後に初期化を実行したいので、遅延させる)
        Future.delayed(Duration.zero, () {
          final controller = context.read<RegisterScheduleController>();
          controller
            ..context = context
            ..initForm();
        });
        return Selector<RegisterScheduleController, bool>(
          selector: (context, model) => model.isInitialized,
          builder: (context, isInitialized, child) {
            final controller = context.read<RegisterScheduleController>();
            return isInitialized
                ? Scaffold(
                    appBar: AppBar(
                      title: const Text('予定を追加'),
                    ),
                    body: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 題名
                                controller.titleForm,
                                // 締め切り日
                                controller.deadlineForm,
                                const SizedBox(height: 32),
                                // 候補日一覧
                                Expanded(child: controller.candidateDatesForm),
                                const SizedBox(height: 32),
                                Expanded(child: controller.candidateDatesForm),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 64,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                controller.registerScheduleAndPopNavigation,
                            child: const Text('予定を登録'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
          },
        );
      },
    );
  }
}

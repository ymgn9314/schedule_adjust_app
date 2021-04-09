import 'package:flutter/material.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/widgets/candidates_form.dart';
import 'package:high_hat/widgets/deadline_form.dart';
import 'package:high_hat/widgets/title_form.dart';

import 'package:provider/provider.dart';

class RegisterScheduleController extends ChangeNotifier {
  // 題名フォーム
  late TitleForm titleForm;
  // 締め切り日時フォーム
  late DeadlineForm deadlineForm;
  // 候補日フォーム
  late CandidateDatesForm candidateDatesForm;

  // 先祖にChangeNotifierProvider<RegisterScheduleController>がいる必要がある
  BuildContext? _context;

  // 初期化処理が終わっているか
  // (_contextの初期化、initFormの呼び出しを遅延させているので、その対処)
  bool isInitialized = false;

  set context(BuildContext? context) => _context = context;

  void initForm() {
    titleForm = TitleForm(inheritedContext: _context!);
    deadlineForm = DeadlineForm(inheritedContext: _context!);
    candidateDatesForm = CandidateDatesForm(inheritedContext: _context!);
    // candidateDateList = [AddCandidateDateComponent()];
    // 初期化完了
    isInitialized = true;
    notifyListeners();
  }

  // notifyListenersを呼び出す
  void callNotifyListeners() {
    notifyListeners();
  }

  // 予定を登録
  void registerScheduleAndPopNavigation() {
    // AppDataControllerに予定を登録する
    final controller = _context!.read<ScheduleDataController>();
    controller.add(
      titleForm: titleForm,
      deadlineForm: deadlineForm,
      candidateDatesForm: candidateDatesForm,
    );

    Navigator.of(_context!).pop();

    // notifyListeners();はcontroller.add()内で行っているので不要
  }
}

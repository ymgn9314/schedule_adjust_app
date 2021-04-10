import 'package:flutter/material.dart';
import 'package:high_hat/widgets/candidates_form.dart';
import 'package:high_hat/widgets/deadline_form.dart';
import 'package:high_hat/widgets/title_form.dart';

class RegisterScheduleController extends ChangeNotifier {
  // 題名フォーム
  TitleForm titleForm = TitleForm();
  // 締め切り日時フォーム
  DeadlineForm deadlineForm = DeadlineForm();
  // 候補日フォーム
  CandidateDatesForm candidateDatesForm = CandidateDatesForm();

  // notifyListenersを呼び出す
  void callNotifyListeners() {
    notifyListeners();
  }
}

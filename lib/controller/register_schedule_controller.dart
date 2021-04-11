import 'package:flutter/material.dart';
import 'package:high_hat/widgets/calendar_form.dart';
import 'package:high_hat/widgets/candidates_form.dart';
import 'package:high_hat/widgets/remarks_form.dart';
import 'package:high_hat/widgets/title_form.dart';

class RegisterScheduleController extends ChangeNotifier {
  // カレンダーフォーム
  CalendarForm calendarForm = CalendarForm();
  // 題名フォーム
  TitleForm titleForm = TitleForm();
  // 備考欄フォーム
  RemarksForm remarksForm = RemarksForm();
  // 候補日フォーム
  CandidateDatesForm candidateDatesForm = CandidateDatesForm();

  // notifyListenersを呼び出す
  void callNotifyListeners() {
    notifyListeners();
  }
}

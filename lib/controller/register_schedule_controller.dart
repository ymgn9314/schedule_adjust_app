import 'package:flutter/material.dart';
import 'package:high_hat/widgets/calendar_form.dart';
import 'package:high_hat/widgets/friend_form.dart';
import 'package:high_hat/widgets/remarks_form.dart';
import 'package:high_hat/widgets/title_form.dart';

class RegisterScheduleController extends ChangeNotifier {
  // カレンダーフォーム
  CalendarForm calendarForm = CalendarForm();
  // 題名フォーム
  TitleForm titleForm = TitleForm();
  // 備考欄フォーム
  RemarksForm remarksForm = RemarksForm();
  // 友達フォーム
  FriendForm friendForm = FriendForm();

  FocusNode titleFocusNode = FocusNode();
  FocusNode remarksFocusNode = FocusNode();
  String title = '';
  String remarks = '';

  // notifyListenersを呼び出す
  void callNotifyListeners() {
    notifyListeners();
  }
}

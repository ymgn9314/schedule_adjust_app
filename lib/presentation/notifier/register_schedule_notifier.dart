import 'package:flutter/material.dart';
import 'package:high_hat/domain/schedule/value/schedule_date.dart';
import 'package:high_hat/domain/user/user.dart';

class RegisterScheduleNotifier with ChangeNotifier {
  // 題名
  final _title = TextEditingController(text: '');
  // 備考欄
  final _remarks = TextEditingController(text: '');
  // 選択した日付リスト
  final _selectedDays = <ScheduleDate>[];
  // 選択したユーザーリスト
  final _selectedUsers = <User>[];

  @override
  void dispose() {
    _title.dispose();
    _remarks.dispose();
    super.dispose();
  }

  String get title => _title.text;
  String get remarks => _remarks.text;
  TextEditingController get titleController => _title;
  TextEditingController get remarksController => _remarks;
  List<User> get selectedUsers => _selectedUsers;
  List<String> get selectedUserStrings =>
      _selectedUsers.map((e) => e.id.value).toList();
  List<ScheduleDate> get selectedDays => _selectedDays;
  List<DateTime> get selectedDateTimes =>
      _selectedDays.map((e) => e.value).toList();

  // 指定した日付の選択・非選択を切り替える
  void onDaySelected(DateTime selectedDay) {
    final target = ScheduleDate(selectedDay);

    _selectedDays.contains(target)
        ? _selectedDays.remove(target)
        : _selectedDays.add(target);

    // 日付をソートする
    _selectedDays.sort((lhs, rhs) => lhs.value.compareTo(rhs.value));

    notifyListeners();
  }

  // ユーザーの選択・非選択を切り替える
  void onUserSelected(User user) {
    _selectedUsers.contains(user)
        ? _selectedUsers.remove(user)
        : _selectedUsers.add(user);

    notifyListeners();
  }

  String? validate() {
    // タイトルが入力されていない
    if (title.isEmpty) {
      return 'タイトルが未設定です.';
    }
    if (_selectedUsers.isEmpty) {
      return '友達が選択されていません.';
    }
    if (_selectedDays.isEmpty) {
      return '日付が選択されていません.';
    }
    return null;
  }
}

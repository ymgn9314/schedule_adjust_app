import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CalendarForm extends StatelessWidget {
  // 選択されている日付を格納する
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: (DateTime key) =>
        key.day * 1000000 + key.month * 10000 + key.year,
  );
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _firstDay = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 30));
  DateTime _focusDay = DateTime.now();

  // 上部のスナックバー連打防止用
  bool isDisplayTopSnackbar = true;

  // 選択できない日付を選択したときにエラー表示を出す
  void showTopSnackbar(BuildContext context) {
    if (isDisplayTopSnackbar) {
      // 10秒間スナックバーの表示を無効にする
      isDisplayTopSnackbar = false;
      Future.delayed(
        const Duration(seconds: 5),
        () => isDisplayTopSnackbar = true,
      );
      final first = DateFormat.MMMMd().format(_firstDay);
      final last = DateFormat.MMMMd().format(_lastDay);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: '$first〜$lastしか選択できません',
        ),
      );
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _focusDay = focusedDay;
    if (_selectedDays.contains(selectedDay)) {
      _selectedDays.remove(selectedDay);
    } else {
      _selectedDays.add(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataController>(
      builder: (context, model, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            gradient:
                LinearGradient(colors: [model.color[600]!, model.color[400]!]),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Selector<RegisterScheduleController, int>(
            selector: (context, model) =>
                model.calendarForm._selectedDays.length,
            builder: (context, length, child) {
              return TableCalendar<void>(
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusDay,
                calendarFormat: _calendarFormat,
                // カレンダー一行あたりの高さ
                rowHeight: MediaQuery.of(context).size.height * 0.05,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: _selectedDays.contains,
                // ヘッダーのテキストスタイル
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  // 左右矢印のウィジェット
                  leftChevronIcon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
                // 月〜金のテキストスタイル
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay, focusedDay);
                  context
                      .read<RegisterScheduleController>()
                      .callNotifyListeners();
                },
                onPageChanged: (focusedDay) {
                  _focusDay = focusedDay;
                },
                // 選択できない日付を選択したらエラーを出す
                onDisabledDayTapped: (selectedDay) async {
                  showTopSnackbar(context);
                },
                calendarStyle: CalendarStyle(
                  canMarkersOverflow: true,
                  // 月〜金のテキストカラー
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  // 土日のテキストカラー
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  // 月をまたいでいる日のテキストカラー
                  outsideTextStyle: const TextStyle(color: Colors.white),
                  // 今日のテキストカラー
                  todayTextStyle: TextStyle(color: model.color[600]),
                  // 選択できない日のテキストカラー
                  disabledTextStyle: TextStyle(color: Colors.grey[400]),
                  // 選択されている日のテキストカラー
                  selectedTextStyle: TextStyle(
                      color: model.color[50], fontWeight: FontWeight.bold),
                  // 今日の丸アイコンスタイル
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: model.acColor[100],
                  ),
                  // 選択されている日付のアイコンスタイル
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: model.color[700],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

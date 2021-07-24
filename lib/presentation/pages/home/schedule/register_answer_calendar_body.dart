import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class RegisterAnswerCalendarBody extends StatefulWidget {
  const RegisterAnswerCalendarBody({Key? key}) : super(key: key);

  @override
  _RegisterAnswerCalendarBodyState createState() =>
      _RegisterAnswerCalendarBodyState();
}

class _RegisterAnswerCalendarBodyState
    extends State<RegisterAnswerCalendarBody> {
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: (DateTime key) =>
        key.day * 1000000 + key.month * 10000 + key.year,
  );

  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey
                  : Colors.grey[900]!,
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TableCalendar<void>(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 120)),
          focusedDay: _focusedDay,
          // 論理上の画面サイズに応じて表示の仕方を変える
          // iPhone12 miniは812pt.
          // iPhoneXR, 11 => 896, iPhone12, 12Pro => 844, iPhone12ProMax => 926
          calendarFormat: MediaQuery.of(context).size.height < 813
              ? CalendarFormat.twoWeeks
              : CalendarFormat.month,
          selectedDayPredicate: _selectedDays.contains,
          calendarStyle: CalendarStyle(
            canMarkersOverflow: true,
            // 月〜金のテキストカラー
            defaultTextStyle: const TextStyle(color: Colors.white),
            // 土日のテキストカラー
            weekendTextStyle: const TextStyle(color: Colors.white),
            // 月をまたいでいる日のテキストカラー
            outsideTextStyle: const TextStyle(color: Colors.white),
            // 選択できない日のテキストカラー
            disabledTextStyle: TextStyle(color: Colors.grey[350]),
            // 選択されている日のテキストカラー
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            // 今日の丸アイコンスタイル
            todayDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Theme.of(context).accentColor,
            ),
            // 選択されている日付のアイコンスタイル
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).accentColor,
            ),
          ),
          //ヘッダーのテキストスタイル
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
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
          //月〜金のテキストスタイル
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white, fontSize: 13),
            weekendStyle: TextStyle(color: Colors.white, fontSize: 13),
          ),
          // 日付が選択されたとき
          onDaySelected: (selectedDay, focusedDay) {
            // 日付の選択・非選択を切り替え
            context.read<RegisterScheduleNotifier>().onDaySelected(selectedDay);
            _onDaySelected(selectedDay, focusedDay);
          },
        ),
      ),
    );
  }
}

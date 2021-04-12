import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:high_hat/util/show_top_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

@immutable
class CalendarFormField extends FormField<LinkedHashSet<DateTime>> {
  CalendarFormField({
    required FormFieldValidator<LinkedHashSet<DateTime>> validator,
    required this.calendarFormat,
    required this.firstDay,
    required this.lastDay,
    required this.focusDay,
    required this.onUpdate,
    required this.onDisabledDayTapped,
    required this.onChangeFocusDay,
    required this.calendarStyle,
  }) : super(
          onSaved: (newValue) {
            onUpdate!(newValue!);
          },
          validator: validator,
          initialValue: LinkedHashSet<DateTime>(
            equals: isSameDay,
            hashCode: (DateTime key) =>
                key.day * 1000000 + key.month * 10000 + key.year,
          ),
          builder: (FormFieldState<LinkedHashSet<DateTime>> state) {
            return TableCalendar<void>(
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: focusDay,
              calendarFormat: calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: state.value!.contains,
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
              // 日付が選択されたとき
              onDaySelected: (selectedDay, focusedDay) {
                //フォーカスを更新
                onChangeFocusDay!(focusedDay);

                // 選択された日付を追加・削除
                if (state.value!.contains(selectedDay)) {
                  state.value!.remove(selectedDay);
                } else {
                  state.value!.add(selectedDay);
                }
                onUpdate!(state.value!);
              },
              onPageChanged: (focusedDay) {
                // フォーカスを更新
                onChangeFocusDay!(focusedDay);
                onUpdate!(state.value!);
              },
              // 選択できない日付を選択したらエラーを出す
              onDisabledDayTapped: onDisabledDayTapped,
              calendarStyle: calendarStyle,
            );
          },
        );

  final CalendarFormat calendarFormat;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusDay;
  final void Function(LinkedHashSet<DateTime>)? onUpdate;
  final void Function(DateTime)? onDisabledDayTapped;
  final void Function(DateTime)? onChangeFocusDay;
  final CalendarStyle calendarStyle;
}

class CalendarForm extends StatelessWidget {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _firstDay = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 30));
  DateTime _focusDay = DateTime.now();

  // 選択されている日付
  LinkedHashSet<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: (DateTime key) =>
        key.day * 1000000 + key.month * 10000 + key.year,
  );

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
                model.calendarForm.selectedDays.length,
            builder: (context, length, child) {
              return CalendarFormField(
                onUpdate: (newValue) {
                  selectedDays = newValue;
                  // キーボードが開かれている場合閉じるようにする
                  FocusScope.of(context).unfocus();
                  context
                      .read<RegisterScheduleController>()
                      .callNotifyListeners();
                },
                onDisabledDayTapped: (selected) {
                  // 選択できない日付をタップしたらエラー表示
                  final first = DateFormat.MMMMd().format(_firstDay);
                  final last = DateFormat.MMMMd().format(_lastDay);
                  final message = '$first〜$lastしか選択できません';
                  TopSnackBar().show(context, message);
                  // キーボードが開かれている場合閉じるようにする
                  FocusScope.of(context).unfocus();
                },
                onChangeFocusDay: (focusedDay) {
                  // フォーカスを更新
                  _focusDay = focusedDay;
                },
                validator: (value) {
                  // 2日以上選択していないとエラー
                  if (value!.length < 2) {
                    // スナックバー表示
                    TopSnackBar().show(
                      context,
                      '2日以上選択してください',
                      isForceShow: true,
                    );
                    return '2日以上選択してください';
                  } else if (value.length > 14) {
                    // スナックバー表示
                    TopSnackBar().show(
                      context,
                      '14日までしか選択できません',
                      isForceShow: true,
                    );
                    return '14日までしか選択できません';
                  }
                  return null;
                },
                calendarFormat: _calendarFormat,
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusDay: _focusDay,
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

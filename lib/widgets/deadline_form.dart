// 締め切りフォーム
import 'package:flutter/material.dart';
import 'package:high_hat/util/show_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

import 'form_base.dart';

class DeadlineForm extends FormBase {
  DeadlineForm({required BuildContext inheritedContext})
      : super(
          inheritedContext: inheritedContext,
          formType: elementType.deadline,
        );

  final TextEditingController _controller = TextEditingController();
  String get content => _controller.text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: '締め切り日時',
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(20),
        // ),
        suffixIcon: calendarIconButton(),
      ),
    );
  }

  Widget calendarIconButton() {
    return IconButton(
      icon: const Icon(Icons.calendar_today_outlined),
      onPressed: () async {
        // Cupertinoの日付ポップアップを表示する
        DateTime? datetime = await showCupertinoDatePicker(inheritedContext);
        // 日付が選択されていたらフォームを更新する
        if (datetime != null) {
          final formattedDateTime =
              DateFormat('yyyy/MM/dd HH:mm').format(datetime);
          _controller.text = formattedDateTime.toString();
        }
      },
    );
  }
}

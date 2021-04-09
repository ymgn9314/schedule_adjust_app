import 'package:flutter/cupertino.dart';

Future<DateTime?> showCupertinoDatePicker(BuildContext context) async {
  DateTime? _dateTime;
  DateTime? _selected = DateTime.now();

  await showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: _selected,
              onDateTimeChanged: (DateTime newDateTime) {
                // 日付を更新
                _selected = newDateTime;
              },
            ),
          ),
          CupertinoButton(
            onPressed: () {
              // 決定ボタンが押されたときだけ日付選択したことにする
              _dateTime = _selected;
              Navigator.of(context).pop();
            },
            child: const Text('決定'),
          ),
        ],
      ),
    ),
  );

  return _dateTime;
}

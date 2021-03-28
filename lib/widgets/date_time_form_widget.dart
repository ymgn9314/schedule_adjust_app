import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeFormWidget extends StatelessWidget {
  final _dateTimeController = TextEditingController(text: '');
  var _inputDate = '';
  var _inputTime = '';

  String get date => _inputDate;
  String get time => _inputTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: _dateTimeController,
        decoration: InputDecoration(
          labelText: '日付',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  if (selectedDate != null) {
                    final year = selectedDate.year.toString();
                    final month = selectedDate.month.toString();
                    final day = selectedDate.day.toString();
                    _inputDate = '$year/$month/$day';
                    _dateTimeController.text = '$_inputDate$_inputTime';
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    final hour = (picked.hour < 10)
                        ? '0${picked.hour}'
                        : '${picked.hour}';
                    final minute = (picked.minute < 10)
                        ? '0${picked.minute}'
                        : '${picked.minute}';
                    _inputTime = ' $hour:$minute';
                    _dateTimeController.text = '$_inputDate$_inputTime';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:provider/provider.dart';

class RegisterAnswerTitleBody extends StatelessWidget {
  const RegisterAnswerTitleBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: TextFormField(
        maxLength: 15,
        keyboardType: TextInputType.text,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: context.read<RegisterScheduleNotifier>().titleController,
        decoration: InputDecoration(
          labelText: 'タイトル',
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

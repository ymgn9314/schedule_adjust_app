import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:provider/provider.dart';

class RegisterAnswerRemarksBody extends StatelessWidget {
  const RegisterAnswerRemarksBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: TextFormField(
        maxLength: 300,
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: context.read<RegisterScheduleNotifier>().remarksController,
        decoration: InputDecoration(
          labelText: '備考欄(任意)',
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

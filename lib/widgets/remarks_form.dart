import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:provider/provider.dart';

// 備考欄フォーム
class RemarksForm extends StatefulWidget {
  @override
  _RemarksFormState createState() => _RemarksFormState();
}

class _RemarksFormState extends State<RemarksForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: context.read<RegisterScheduleController>().remarksFocusNode,
      maxLength: 20,
      controller: _controller,
      decoration: const InputDecoration(
        labelText: '備考欄(任意)',
      ),
      onChanged: (value) {
        context.read<RegisterScheduleController>().remarks = value;
      },
    );
  }
}

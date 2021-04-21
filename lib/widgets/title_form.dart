import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:provider/provider.dart';

// 題名入力フォーム
class TitleForm extends StatefulWidget {
  @override
  _TitleFormState createState() => _TitleFormState();
}

class _TitleFormState extends State<TitleForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: context.read<RegisterScheduleController>().titleFocusNode,
      validator: (value) {
        if (value!.length < 3) {
          return '3文字以上入力してください';
        }
        return null;
      },
      onChanged: (value) {
        context.read<RegisterScheduleController>().title = value;
      },
      maxLength: 10,
      controller: _controller,
      decoration: const InputDecoration(
        labelText: '題名',
      ),
      textInputAction: TextInputAction.next, // 追加
      onFieldSubmitted: (_) {
        final controller = context.read<RegisterScheduleController>();
        FocusScope.of(context).requestFocus(controller.remarksFocusNode);
      },
    );
  }
}

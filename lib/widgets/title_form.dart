import 'package:flutter/material.dart';
import 'package:high_hat/controller/register_schedule_controller.dart';
import 'package:provider/provider.dart';

// 題名入力フォーム
class TitleForm extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  String get content => _controller.text;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: (value) {
        if (value!.length < 3) {
          return '3文字以上入力してください';
        }
        return null;
      },
      maxLength: 10,
      controller: _controller,
      decoration: const InputDecoration(
        labelText: '題名',
      ),
      textInputAction: TextInputAction.next, // 追加
      onFieldSubmitted: (_) {
        final controller = context.read<RegisterScheduleController>();
        FocusScope.of(context).requestFocus(controller.remarksForm.focusNode);
      },
    );
  }
}

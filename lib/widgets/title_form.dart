// 題名入力フォーム
import 'package:flutter/material.dart';
import 'form_base.dart';

class TitleForm extends FormBase {
  TitleForm({required BuildContext inheritedContext})
      : super(
          inheritedContext: inheritedContext,
          formType: elementType.title,
        );

  final TextEditingController _controller = TextEditingController();
  String get content => _controller.text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        if (value!.isEmpty) {
          return '値が未設定です';
        } else if (value.length < 3) {
          return '3文字以上にしてください';
        }
        return null;
      }, // NameValidator.validate,
      maxLength: 10,
      controller: _controller,
      decoration: const InputDecoration(
        labelText: '題名',
      ),
    );
  }
}

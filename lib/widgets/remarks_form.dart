import 'package:flutter/material.dart';

// 備考欄フォーム
class RemarksForm extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  String get content => _controller.text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 20,
      controller: _controller,
      decoration: const InputDecoration(
        labelText: '備考欄(任意)',
      ),
    );
  }
}

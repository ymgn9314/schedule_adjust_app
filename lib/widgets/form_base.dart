import 'package:flutter/material.dart';

enum elementType {
  title,
  deadline,
  candidateDay,
  addCandidateDay,
  friendForm,
  addFriendForm,
}

// フォーム基底クラス
abstract class FormBase extends StatelessWidget {
  const FormBase({required this.inheritedContext, required this.formType});
  final elementType formType;
  final BuildContext inheritedContext;

  @override
  Widget build(BuildContext context);
}

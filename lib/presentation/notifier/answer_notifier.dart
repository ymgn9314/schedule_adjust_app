import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/value/answer.dart';

class AnswerNotifier with ChangeNotifier {
  // 予定に対する回答を保持
  final _answerToSchedule = <Answer>[];
  // 既に回答したか
  bool _isAlreadyAnswer = false;
  // コメント(任意)
  final _comment = TextEditingController(text: '');

  // 回答を取得
  List<Answer> get answer => _answerToSchedule;
  // 既に回答したかを取得
  bool get isAlreadyAnswer => _isAlreadyAnswer;

  String get comment => _comment.text;
  TextEditingController get commentController => _comment;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // 回答を初期化
  void initAnswer({List<Answer>? setAnswer, bool? isAlreadyAnswer}) {
    // 回答をクリア
    _answerToSchedule.clear();
    // コメントをクリア
    _comment.clear();

    // 回答をセットする
    if (setAnswer != null) {
      for (var i = 0; i < setAnswer.length; ++i) {
        _answerToSchedule.add(setAnswer[i]);
      }
    }

    // 既に回答したかをセットする
    _isAlreadyAnswer = isAlreadyAnswer ?? false;

    notifyListeners();
  }

  // 回答を更新
  void updateAnswer(int index, Answer newAnswer) {
    _answerToSchedule[index] = newAnswer;
    notifyListeners();
  }

  void sendAnswer() {
    _isAlreadyAnswer = true;
    notifyListeners();
  }
}

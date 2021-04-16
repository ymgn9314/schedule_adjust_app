import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/pages/home/view_answer_page.dart';
import 'package:high_hat/util/custom_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnswerButtonComponent {
  AnswerButtonComponent(this.assetName,
      {this.isSelected = false, this.selectedColor});
  bool isSelected = false;
  final String assetName;
  Color? selectedColor;

  Widget get button {
    return isSelected
        ? customIcon(assetName, selectedColor, 28)
        : customIcon(assetName, Colors.grey, 28);
  }
}

class CustomAnswerRadio extends StatelessWidget {
  const CustomAnswerRadio(this._answerButton);
  final AnswerButtonComponent _answerButton;

  @override
  Widget build(BuildContext context) {
    return _answerButton.button;
  }
}

class AnswerSelector extends StatefulWidget {
  AnswerSelector({
    required this.docName, // answersコレクションのドキュメント名
    required this.initialValue,
    required this.isAnswer,
    this.selectedColor,
  });

  final int initialValue;
  final bool isAnswer;
  String docName;
  Color? selectedColor;

  @override
  _AnswerSelectorState createState() =>
      _AnswerSelectorState(initialValue, docName, isAnswer,
          selectedColor: selectedColor);
}

class _AnswerSelectorState extends State<AnswerSelector> {
  _AnswerSelectorState(this._initialValue, this.docName, this.isAnswer,
      {this.selectedColor});
  final int _initialValue;
  String docName;
  final bool isAnswer;
  Color? selectedColor;

  final List<AnswerButtonComponent> _radio = [];

  @override
  void initState() {
    super.initState();
    _radio
      ..add(AnswerButtonComponent('assets/circle.svg',
          isSelected: _initialValue == 0, selectedColor: selectedColor))
      ..add(AnswerButtonComponent('assets/triangle.svg',
          isSelected: _initialValue == 1, selectedColor: selectedColor))
      ..add(AnswerButtonComponent('assets/cross.svg',
          isSelected: _initialValue == 2, selectedColor: selectedColor));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: false,
      itemCount: _radio.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: isAnswer
                ? null
                : () {
                    setState(() {
                      // firestoreに書き込む値を更新
                      context
                          .read<ScheduleDataController>()
                          .schedules[docName] = index;

                      for (var i = 0; i < _radio.length; i++) {
                        _radio[i].isSelected = false;
                      }
                      _radio[index].isSelected = true;
                    });
                  },
            child: CustomAnswerRadio(_radio[index]),
          ),
        );
      },
    );
  }
}

class AnswerSchedulePage extends StatelessWidget {
  static const id = 'answer_schedule_page';

  AnswerSchedulePage(this._scheduleId);

  // schedulesoコレクションのスケジュールID
  final String _scheduleId;

  @override
  Widget build(BuildContext context) {
    print('AnswerSchedulePage#build()');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '回答する',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<bool>(
        future:
            context.read<ScheduleDataController>().fetchSchedule(_scheduleId),
        builder: (context, snapshot) {
          // 取得が完了していない
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: context.read<AppDataController>().color[600],
                  ),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (context) {
                          return ViewAnswerPage(_scheduleId);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'みんなの回答をみる',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // 回答一覧
                ...context.read<ScheduleDataController>().schedules.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('M/d(E)').format(
                                  DateFormat('y-M-d').parseStrict(e.key)),
                              style: const TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 48,
                              child: AnswerSelector(
                                initialValue: e.value,
                                docName: e.key,
                                isAnswer: context
                                    .read<ScheduleDataController>()
                                    .isAnswer,
                                selectedColor: context
                                    .read<AppDataController>()
                                    .color[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ElevatedButton(
                  onPressed: context.read<ScheduleDataController>().isAnswer
                      ? null
                      : () async {
                          // firestoreに回答を送信する
                          await context
                              .read<ScheduleDataController>()
                              .sendAnswer(_scheduleId);

                          // 画面を抜ける？
                          Navigator.of(context).pop();
                        },
                  child: context.read<ScheduleDataController>().isAnswer
                      ? const Text(
                          '回答済みです',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          '回答を送信する',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

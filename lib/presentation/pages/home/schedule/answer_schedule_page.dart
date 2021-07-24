import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/user/value/answer.dart';
import 'package:high_hat/presentation/pages/home/schedule/view_answer_page.dart';
import 'package:high_hat/presentation/notifier/answer_notifier.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class AnswerSelectComponent extends StatefulWidget {
  AnswerSelectComponent({
    Key? key,
    required int selfIndex,
    required int selected,
    required bool isFix,
  })  : _selfIndex = selfIndex,
        _selected = selected,
        _isFix = isFix,
        super(key: key);

  final int _selfIndex;
  int _selected = 0;
  final bool _isFix;

  @override
  _AnswerSelectComponentState createState() => _AnswerSelectComponentState();
}

class _AnswerSelectComponentState extends State<AnswerSelectComponent> {
  @override
  Widget build(BuildContext context) {
    // TODO(ymgn9314): フィールドとして持ちたい
    final _customRadioAssetList = <Widget>[
      SvgPicture.asset('assets/circle.svg',
          color: Colors.grey, width: 32, height: 32),
      SvgPicture.asset('assets/triangle.svg',
          color: Colors.grey, width: 32, height: 32),
      SvgPicture.asset('assets/cross.svg',
          color: Colors.grey, width: 32, height: 32),
      SvgPicture.asset('assets/circle.svg',
          color: Theme.of(context).primaryColor, width: 32, height: 32),
      SvgPicture.asset('assets/triangle.svg',
          color: Theme.of(context).primaryColor, width: 32, height: 32),
      SvgPicture.asset('assets/cross.svg',
          color: Theme.of(context).primaryColor, width: 32, height: 32),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int i = 0; i < _customRadioAssetList.length / 2; i++)
          GestureDetector(
              onTap: widget._isFix
                  ? null
                  : () {
                      setState(() {
                        widget._selected = i;
                        context
                            .read<AnswerNotifier>()
                            .updateAnswer(widget._selfIndex, Answer.values[i]);
                        // print(widget._selected);
                      });
                    },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: (widget._selected == i)
                    ? _customRadioAssetList[i + 3]
                    : _customRadioAssetList[i],
              )),
      ],
    );
  }
}

class AnswerSchedulePage extends StatelessWidget {
  static const id = 'answer_schedule_page';

  const AnswerSchedulePage({
    Key? key,
    required Schedule schedule,
  })  : _schedule = schedule,
        super(key: key);

  final Schedule _schedule;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '${_schedule.title.value}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text('${_schedule.remarks.value}'),
            ),
            Container(
              margin: const EdgeInsets.all(32),
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // 回答閲覧ページ画面に遷移
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ViewAnswerPage(schedule: _schedule),
                    ),
                  );
                },
                child: const Text(
                  'みんなの回答をみる',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Helpers.dateFormat
                            .format(_schedule.scheduleList[index].value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 48),
                      AnswerSelectComponent(
                        selfIndex: index,
                        selected:
                            context.read<AnswerNotifier>().answer[index].index,
                        isFix: context.read<AnswerNotifier>().isAlreadyAnswer,
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 12);
                },
                itemCount: _schedule.scheduleList.length,
              ),
            ),
            // コメント
            if (!context.watch<AnswerNotifier>().isAlreadyAnswer)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: TextFormField(
                  maxLength: 50,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: context.read<AnswerNotifier>().commentController,
                  decoration: InputDecoration(
                    labelText: 'みんなにコメントを送る(任意)',
                    contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.all(32),
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: context.watch<AnswerNotifier>().isAlreadyAnswer
                    ? null
                    : () async {
                        final userNotifier = context.read<UserNotifier>();
                        final answerNotifier = context.read<AnswerNotifier>();
                        // 回答とコメントを送信する
                        await userNotifier.answerToSchedule(
                          _schedule.id.value,
                          answerNotifier.answer,
                          answerNotifier.comment,
                        );
                        answerNotifier.sendAnswer();
                      },
                child: Text(
                  context.watch<AnswerNotifier>().isAlreadyAnswer
                      ? '回答済みです'
                      : '回答を送信する',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

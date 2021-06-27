import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:high_hat/common/helper/helpers.dart';
import 'package:high_hat/domain/schedule/schedule.dart';
import 'package:high_hat/domain/user/value/answer.dart';

class ViewAnswerNumberBody extends StatelessWidget {
  ViewAnswerNumberBody({
    Key? key,
    required Schedule schedule,
    required List<Map<Answer, int>> answerList,
  })  : _schedule = schedule,
        _answerList = answerList,
        super(key: key);

  Schedule _schedule;
  List<Map<Answer, int>> _answerList;

  @override
  Widget build(BuildContext context) {
    // TODO(ymgn9314): フィールドとして持ちたい
    final _customRadioAssetList = <Widget>[
      SvgPicture.asset('assets/circle.svg',
          color: Theme.of(context).primaryColor, width: 24, height: 24),
      SvgPicture.asset('assets/triangle.svg',
          color: Theme.of(context).accentColor, width: 24, height: 24),
      SvgPicture.asset('assets/cross.svg',
          color: Colors.grey, width: 24, height: 24),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                  const SizedBox(width: 32),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: _customRadioAssetList[0],
                  ),
                  Text(
                    _answerList[index][Answer.ok].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: _customRadioAssetList[1],
                  ),
                  Text(
                    _answerList[index][Answer.either].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: _customRadioAssetList[2],
                  ),
                  Text(
                    _answerList[index][Answer.ng].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 24);
            },
            itemCount: _schedule.scheduleList.length,
          ),
        ),
      ],
    );
  }
}

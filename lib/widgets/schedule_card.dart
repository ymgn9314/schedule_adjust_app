import 'package:flutter/material.dart';
import 'package:high_hat/widgets/calendar_form.dart';

import 'candidates_form.dart';
import 'title_form.dart';

class ScheduleCard extends StatelessWidget {
  ScheduleCard({
    required this.titleForm,
    required this.calendarForm,
    required this.ownerUid,
    required this.ownerPhotoUrl,
  });

  // 題名(タコパとかボドゲ会とか): String?
  // 締め切り: DateTime?
  // 候補日: List<DateTime>?
  // 友達一覧: List<uid>? => ここもう少し考える必要あり(予定作成者のphotoURLを表示させたい)
  // ユーザーのuid, photoURLはStringで別々に持っておく？(firestoreはUser型保存できない)
  TitleForm titleForm;
  CalendarForm calendarForm;
  String ownerUid;
  String ownerPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('pressed listtile');
      },
      onLongPress: () {},
      leading: CircleAvatar(
        backgroundImage: NetworkImage(ownerPhotoUrl),
      ),
      title: Row(
        children: [
          Text(
            titleForm.content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
          const Text(
            '回答2/5',
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(ownerPhotoUrl),
          ),
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(ownerPhotoUrl),
          ),
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.grey, BlendMode.modulate),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(ownerPhotoUrl),
            ),
          ),
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.grey, BlendMode.modulate),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(ownerPhotoUrl),
            ),
          ),
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.grey, BlendMode.modulate),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(ownerPhotoUrl),
            ),
          ),
        ],
      ),
      subtitle: const Text('作成者Seiya Yamamoto'),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}

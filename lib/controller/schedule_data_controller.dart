import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/widgets/candidates_form.dart';
import 'package:high_hat/widgets/deadline_form.dart';
import 'package:high_hat/widgets/title_form.dart';

class ScheduleDataController extends ChangeNotifier {
  List<ScheduleCard> scheduleList = [];

  void add({
    required TitleForm titleForm,
    required DeadlineForm deadlineForm,
    required CandidateDatesForm candidateDatesForm,
  }) {
    print('AppDataController#add()');
    final user = FirebaseAuth.instance.currentUser;
    scheduleList.add(
      ScheduleCard(
        titleForm: titleForm,
        deadlineForm: deadlineForm,
        candidateDatesForm: candidateDatesForm,
        ownerUid: user!.uid,
        ownerPhotoUrl: user.photoURL!,
      ),
    );
    notifyListeners();
  }
}

class ScheduleCard extends StatelessWidget {
  ScheduleCard({
    required this.titleForm,
    required this.deadlineForm,
    required this.candidateDatesForm,
    required this.ownerUid,
    required this.ownerPhotoUrl,
  });

  // 題名(タコパとかボドゲ会とか): String?
  // 締め切り: DateTime?
  // 候補日: List<DateTime>?
  // 友達一覧: List<uid>? => ここもう少し考える必要あり(予定作成者のphotoURLを表示させたい)
  // ユーザーのuid, photoURLはStringで別々に持っておく？(firestoreはUser型保存できない)
  TitleForm titleForm;
  DeadlineForm deadlineForm;
  CandidateDatesForm candidateDatesForm;
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
      subtitle: Row(
        children: [
          const Text('作成者Seiya Yamamoto'),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          Text(
            '〆${deadlineForm.content}',
          ),
        ],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
    );
  }
}

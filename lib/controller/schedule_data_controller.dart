import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/widgets/candidates_form.dart';
import 'package:high_hat/widgets/schedule_card.dart';
import 'package:high_hat/widgets/title_form.dart';

class ScheduleDataController extends ChangeNotifier {
  List<ScheduleCard> scheduleList = [];

  void add({
    required TitleForm titleForm,
    required CandidateDatesForm candidateDatesForm,
  }) {
    print('AppDataController#add()');
    final user = FirebaseAuth.instance.currentUser;
    scheduleList.add(
      ScheduleCard(
        titleForm: titleForm,
        candidateDatesForm: candidateDatesForm,
        ownerUid: user!.uid,
        ownerPhotoUrl: user.photoURL!,
      ),
    );
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'schedule_view_notifier.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView._({Key? key}) : super(key: key);

  static Widget wrapped() {
    return MultiProvider(
      providers: [
        StateNotifierProvider<ScheduleViewNotifier, ScheduleViewState>(
          create: (context) => ScheduleViewNotifier(
            context: context,
          ),
        )
      ],
      child: const ScheduleView._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ScheduleViewNotifier>();
    return Builder(builder: (BuildContext context) {
      return Scaffold(
        body: const Center(
          child: Icon(
            Icons.calendar_today_outlined,
            size: 200,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            notifier
              ..initDialogItems()
              ..showPopupForm();
          },
          backgroundColor: Colors.black,
          elevation: 8,
          child: const Icon(Icons.playlist_add_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}

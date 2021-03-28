import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:high_hat/pages/root_page_notifier.dart';
import 'package:provider/provider.dart';

import 'package:high_hat/views/schedule_view.dart';
import 'package:high_hat/views/friend_view.dart';
import 'package:high_hat/views/account_view.dart';

class RootPage extends StatelessWidget {
  RootPage._({Key? key}) : super(key: key);

  static const String id = 'root_page';

  final List<Widget> _viewList = <Widget>[
    ScheduleView.wrapped(),
    FriendView(),
    AccountView(),
  ];

  final tabItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today_outlined),
      label: '一覧',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.supervisor_account),
      label: '友達',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'アカウント',
    ),
  ];

  static Widget wrapped() {
    return MultiProvider(
      providers: [
        StateNotifierProvider<RootPageNotifier, RootPageState>(
          create: (context) => RootPageNotifier(
            context: context,
          ),
        ),
      ],
      child: RootPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<RootPageNotifier>();

    return Builder(builder: (BuildContext context) {
      final viewIndex =
          context.select((RootPageState state) => state.viewIndex);
      return Scaffold(
        body: _viewList[viewIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: viewIndex,
          items: tabItems,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            notifier.viewIndex = value;
          },
        ),
      );
    });
  }
}

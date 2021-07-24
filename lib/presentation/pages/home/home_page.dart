import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/bottom_navigation_notifier.dart';
import 'package:high_hat/presentation/pages/home/account/account_page.dart';
import 'package:high_hat/presentation/pages/home/schedule/schedule_page.dart';
import 'package:provider/provider.dart';
import 'friend/friend_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNavigationNotifier(),
        ),
      ],
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  final List<Widget> _pageList = <Widget>[
    SchedulePage(),
    FriendPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final _index = context.select(
        (BottomNavigationNotifier controller) => controller.currentIndex);
    return Scaffold(
      body: _pageList[_index],
      bottomNavigationBar: BottomNavigationBar(
        // ボトムナビゲーションのラベル表示を消す
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _index,
        onTap: (index) {
          context.read<BottomNavigationNotifier>().currentIndex = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '予定',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: '友達',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'アカウント',
          ),
        ],
      ),
    );
  }
}

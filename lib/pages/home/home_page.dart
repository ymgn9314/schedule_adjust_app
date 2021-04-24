import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/bottom_navigation_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/pages/Home/account_page.dart';
import 'package:high_hat/pages/Home/schedule_page.dart';
import 'package:high_hat/pages/home/friend_page.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<bool> setUserData(BuildContext context) async {
    // ログインしていなかったらログインする
    if (context.read<LoginAuthenticationController>().user == null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final exists = doc.exists;
      context.read<LoginAuthenticationController>().user = UserData(
        uid: doc.id,
        displayName: exists ? doc.get('displayName') as String : '不明なユーザー',
        photoUrl: exists ? doc.get('photoUrl') as String : '',
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage#build()');

    return FutureBuilder(
      future: setUserData(context),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => BottomNavigationController(),
            ),
          ],
          child: _HomePage(),
        );
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  final List<Widget> _pageList = <Widget>[
    SchedulePage(),
    FriendPage(),
    AccountPage(),
  ];

  final List<String> _appBarTitleList = <String>[
    '予定一覧',
    '友達',
    'アカウント',
  ];

  @override
  Widget build(BuildContext context) {
    print('_Home in _HomePage#build()');

    return Selector<BottomNavigationController, int>(
      selector: (context, model) => model.currentIndex,
      builder: (context, currentIndex, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              _appBarTitleList[
                  context.read<BottomNavigationController>().currentIndex],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: _pageList[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            // ボトムナビゲーションのラベル表示を消す
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<BottomNavigationController>().currentIndex = index;
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
      },
    );
  }
}

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:high_hat/pages/login_page.dart';

class AccountView extends StatelessWidget {
  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ログアウトしますか？'),
          content: const Text('再度ログインすることでアプリをご利用いただけます。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginPage.id);
              },
              child: const Text('ログアウト'),
            ),
          ],
        );
      },
    );
  }

  Widget _getProfileWidget() {
    final user = FirebaseAuth.instance.currentUser;

    return Column(children: [
      CircularProfileAvatar(
        user != null ? user.photoURL.toString() : '',
        radius: 48,
        backgroundColor: Colors.transparent,
        borderWidth: 8,
        initialsText: const Text(
          '',
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
        borderColor: Colors.white,
        elevation: 4,
        foregroundColor: Colors.white.withOpacity(0),
        cacheImage: true,
        onTap: () {}, // sets on tap
        showInitialTextAbovePicture: true,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        (user != null ? user.displayName : '')!,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        user != null ? '@${user.uid}' : '',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.12,
                  ),
                  child: _getProfileWidget(),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.1,
                ),
                child: const Text('ログアウト'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

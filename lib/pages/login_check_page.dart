import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/pages/login_page.dart';
import 'package:high_hat/pages/root_page.dart';

class LoginCheckPage extends StatelessWidget {
  static const String id = 'login_check_page';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return RootPage.wrapped();
    } else {
      return LoginPage();
    }
  }
}

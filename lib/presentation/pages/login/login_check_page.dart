import 'package:flutter/material.dart';
import 'package:high_hat/presentation/pages/Home/home_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class LoginCheckPage extends StatelessWidget {
  static const id = 'login_check_page';
  @override
  Widget build(BuildContext context) {
    final _loggedInUser =
        context.select((UserNotifier notifier) => notifier.loggedInUser);
    return _loggedInUser != null ? HomePage() : LoginPage();
  }
}

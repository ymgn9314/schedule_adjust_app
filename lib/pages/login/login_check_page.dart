import 'package:flutter/material.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/pages/Home/home_page.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class LoginCheckPage extends StatelessWidget {
  static const id = 'login_check_page';

  @override
  Widget build(BuildContext context) {
    print('LoginCheckPage#build()');

    return Selector<LoginAuthenticationController, bool>(
      selector: (context, model) => model.isLogin,
      builder: (context, isLogin, child) {
        return isLogin ? HomePage() : LoginPage();
      },
    );
  }
}

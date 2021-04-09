import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/util/sign_in_func.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';
  @override
  Widget build(BuildContext context) {
    print('LoginPage#build()');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'はじめる',
            style: TextStyle(fontSize: 32),
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () async {
              final result = await signInWithGoogle();
              // ログインに成功したらcontrollerに渡す
              if (result!.user != null) {
                context
                    .read<LoginAuthenticationController>()
                    .login(result.user);
              }
            },
          ),
        ],
      ),
    );
  }
}

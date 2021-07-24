import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:high_hat/presentation/pages/home/home_page.dart';
import 'package:high_hat/presentation/pages/term_policy/privacy_policy_page.dart';
import 'package:high_hat/presentation/pages/term_policy/terms_of_use_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';
  @override
  Widget build(BuildContext context) {
    print('LoginPage#build()');

    final notifier = context.read<UserNotifier>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: const Image(
                    image: AssetImage('assets/schedule_icon_transparent.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    '「みんなでスケジュール調整」をはじめる',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '利用規約',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute(builder: (context) {
                                  return TermsOfUsePage();
                                }),
                              );
                            },
                        ),
                        const TextSpan(
                            text: 'と', style: TextStyle(color: Colors.grey)),
                        TextSpan(
                          text: 'プライバシーポリシー',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute(builder: (context) {
                                  return PrivacyPolicyPage();
                                }),
                              );
                            },
                        ),
                        const TextSpan(
                          text: 'に同意した上でログインしてください。',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ), //Text('利用規約とプライバシーポリシーに同意したうえでログインしてください。'),
                ),
                if (Platform.isIOS)
                  SignInButton(
                    Buttons.Apple,
                    onPressed: () async {
                      final userCredential = await notifier.signInWithApple();
                      // サインインに成功した
                      if (userCredential != null) {
                        // ユーザーを作成
                        await notifier.createMyAccount();
                        await notifier.notifySignIn();
                        // ホーム画面へ遷移
                        await Navigator.of(context).pushReplacement<void, void>(
                          MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            },
                          ),
                        );
                      }
                    },
                  ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    final userCredential = await notifier.signInWithGoogle();
                    // サインインに成功した
                    if (userCredential != null) {
                      // ユーザーを作成
                      await notifier.createMyAccount();
                      await notifier.notifySignIn();
                      // ホーム画面へ遷移
                      await Navigator.of(context).pushReplacement<void, void>(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ),
                      );
                    }
                  },
                ),
                SignInButton(
                  Buttons.Twitter,
                  onPressed: () async {
                    final userCredential = await notifier.signInWithTwitter();
                    // サインインに成功した
                    if (userCredential != null) {
                      // ユーザーを作成
                      await notifier.createMyAccount();
                      await notifier.notifySignIn();
                      // ホーム画面へ遷移
                      await Navigator.of(context).pushReplacement<void, void>(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

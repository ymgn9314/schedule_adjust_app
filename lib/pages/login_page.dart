import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:high_hat/pages/root_page.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatelessWidget {
  static const String id = 'login_page';
  bool _isLogin = false;

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;

      await EasyLoading.show(status: 'Loading...');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _isLogin = true;
    } catch (e) {
      _isLogin = false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _signInWithApple() async {
    await EasyLoading.show(status: 'Loading...');

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      _isLogin = true;
    } catch (e) {
      _isLogin = false;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const Text(
              'はじめる',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SignInButton(
              Buttons.Google,
              text: 'Googleでログイン',
              onPressed: () async {
                await _signInWithGoogle();
                if (_isLogin) {
                  await Navigator.of(context).pushReplacementNamed(RootPage.id);
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            SignInButton(
              Buttons.Apple,
              text: 'Appleでサインイン',
              onPressed: () async {
                await _signInWithApple();
                if (_isLogin) {
                  await Navigator.of(context).pushReplacementNamed(RootPage.id);
                }
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            SignInButton(
              Buttons.Twitter,
              text: 'Twitterでログイン',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

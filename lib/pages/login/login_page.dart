import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/local_db/friend_box/friend_box.dart';
import 'package:high_hat/pages/term_policy/privacy_policy_page.dart';
import 'package:high_hat/pages/term_policy/terms_of_use_page.dart';
import 'package:high_hat/util/gen_random_string.dart';
import 'package:high_hat/util/sign_in_func.dart';
import 'package:high_hat/util/user_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';
  @override
  Widget build(BuildContext context) {
    print('LoginPage#build()');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: const Image(
                      image:
                          AssetImage('assets/schedule_icon_transparent.png'))),
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
                    final user = await signInWithApple();

                    // ログインに成功したらcontrollerに渡す
                    if (user != null) {
                      // ローカルDBに保存する
                      print('open hive box in LoginPage');
                      await Hive.openBox<FriendBox>('friend_box');
                      await Hive.box<FriendBox>('friend_box').put(
                        user.uid,
                        FriendBox(
                            uid: user.uid,
                            displayName: user.displayName,
                            photoUrl: user.photoUrl),
                      );
                      // Firestoreにユーザー情報を登録
                      // TODO(ymgn): 本当は新規登録時のみやる
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid) // ドキュメントID == ユーザーID
                          .set(<String, dynamic>{
                        'displayName': user.displayName,
                        'photoUrl': user.photoUrl,
                        'userId': randomString(6), // 適当なユーザーIDを付与する
                      });
                      context.read<LoginAuthenticationController>().login(user);
                    }
                  },
                ),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  final result = await signInWithGoogle();

                  // ログインに成功したらcontrollerに渡す
                  if (result != null && result.user != null) {
                    // ローカルDBに保存する
                    print('open hive box in LoginPage');
                    await Hive.openBox<FriendBox>('friend_box');
                    await Hive.box<FriendBox>('friend_box').put(
                      result.user!.uid,
                      FriendBox(
                          uid: result.user!.uid,
                          displayName: result.user!.displayName!,
                          photoUrl: result.user!.photoURL!),
                    );
                    // Firestoreにユーザー情報を登録
                    // TODO(ymgn): 本当は新規登録時のみやる
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(result.user!.uid) // ドキュメントID == ユーザーID
                        .set(
                      <String, dynamic>{
                        'displayName': result.user!.displayName,
                        'photoUrl': result.user!.photoURL,
                        'userId': randomString(6), // 適当なユーザーIDを付与する
                      },
                    );
                    context.read<LoginAuthenticationController>().login(
                          UserData(
                              uid: result.user!.uid,
                              displayName: result.user!.displayName!,
                              photoUrl: result.user!.photoURL!),
                        );
                    //.login(result.user);
                  }
                },
              ),
              SignInButton(
                Buttons.Twitter,
                onPressed: () async {
                  final result = await signInWithTwitter();

                  // ログインに成功したらcontrollerに渡す
                  if (result != null) {
                    // ローカルDBに保存する
                    print('open hive box in LoginPage');
                    await Hive.openBox<FriendBox>('friend_box');
                    await Hive.box<FriendBox>('friend_box').put(
                      result.uid,
                      FriendBox(
                          uid: result.uid,
                          displayName: result.displayName,
                          photoUrl: result.photoUrl),
                    );
                    // Firestoreにユーザー情報を登録
                    // TODO(ymgn): 本当は新規登録時のみやる
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(result.uid) // ドキュメントID == ユーザーID
                        .set(
                      <String, dynamic>{
                        'displayName': result.displayName,
                        'photoUrl': result.photoUrl,
                        'userId': randomString(6), // 適当なユーザーIDを付与する
                      },
                    );
                    context.read<LoginAuthenticationController>().login(
                          UserData(
                              uid: result.uid,
                              displayName: result.displayName,
                              photoUrl: result.photoUrl),
                        );
                    //.login(result.user);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

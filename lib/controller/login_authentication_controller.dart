import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:high_hat/util/user_data.dart';

class LoginAuthenticationController extends ChangeNotifier {
  // ログイン・ログアウト時の画面遷移を検知するため
  UserData? user;
  bool get isLogin => FirebaseAuth.instance.currentUser != null;

  bool login(UserData? user) {
    this.user = user;
    notifyListeners();
    return this.user != null;
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}

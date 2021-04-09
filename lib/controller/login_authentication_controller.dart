import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LoginAuthenticationController extends ChangeNotifier {
  // FirebaseAuth.instance.currentUserを保持しておく
  // ログイン・ログアウト時の画面遷移を検知するため
  User? _user = FirebaseAuth.instance.currentUser;

  bool get isLogin => _user != null;
  User? get user => _user;

  bool login(User? user) {
    _user = user;
    notifyListeners();
    return _user != null;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

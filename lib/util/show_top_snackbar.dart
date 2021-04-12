import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TopSnackBar {
  factory TopSnackBar() {
    _instance ??= TopSnackBar._internal();
    return _instance!;
  }
  TopSnackBar._internal();
  static TopSnackBar? _instance;

  // 上部のスナックバー連打防止用
  static bool _isDisplayTopSnackbar = true;

  void show(BuildContext context, String message, {bool isForceShow = false}) {
    // 強制的に表示する
    if (isForceShow) {
      _isDisplayTopSnackbar = true;
    }
    if (_isDisplayTopSnackbar) {
      // 5秒間スナックバーの表示を無効にする
      _isDisplayTopSnackbar = false;
      Future.delayed(
        const Duration(seconds: 5),
        () => _isDisplayTopSnackbar = true,
      );
      showTopSnackBar(context, CustomSnackBar.error(message: message));
    }
  }
}

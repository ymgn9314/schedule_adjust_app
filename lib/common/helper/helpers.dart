import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

// ignore: avoid_classes_with_only_static_members
class Helpers {
  static Future<DateTime>? get ntpTime => NTP.now();

  static Future<String> get dateId async =>
      DateFormat('yyyy-MM').format(await ntpTime ?? DateTime.now());

  static DateFormat get dateFormat => DateFormat('yyyy/MM/dd(E)', 'ja_JP');

  static DateFormat get dateFormatForId => DateFormat('yyyyMMddHms');

  static final _auth = FirebaseAuth.instance;
  static String? get userId => _auth.currentUser?.uid;
  static String? get photoUrl => _auth.currentUser?.photoURL;
  static String? get userName => _auth.currentUser?.displayName;

  static String generateRandomString(int len) {
    final random = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[random.nextInt(_chars.length)])
        .join();
  }

  static ThemeData defaultThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      primaryColor: Colors.green[600],
      primaryColorBrightness: Brightness.light,
      accentColor: Colors.green[400],
      accentColorBrightness: Brightness.light,
      buttonColor: Colors.green[500],
    );
  }

  static ThemeData defaultDarkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      primaryColor: Colors.green[600],
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.green[400],
      accentColorBrightness: Brightness.dark,
      buttonColor: Colors.green[500],
    );
  }
}

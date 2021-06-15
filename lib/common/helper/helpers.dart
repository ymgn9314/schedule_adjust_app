import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

// ignore: avoid_classes_with_only_static_members
class Helpers {
  static Future<DateTime>? get ntpTime => NTP.now();

  static Future<String> get dateId async =>
      DateFormat('yyyy-MM').format(await ntpTime ?? DateTime.now());

  static final _auth = FirebaseAuth.instance;
  static String? get userId => _auth.currentUser?.uid;
  static String? get photoUrl => _auth.currentUser?.photoURL;
  static String? get userName => _auth.currentUser?.displayName;
}

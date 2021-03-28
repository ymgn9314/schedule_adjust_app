import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:high_hat/pages/login_page.dart';
import 'package:high_hat/pages/root_page.dart';
import 'package:high_hat/pages/login_check_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      builder: EasyLoading.init(),
      initialRoute: LoginCheckPage.id,
      routes: {
        LoginCheckPage.id: (context) => LoginCheckPage(),
        LoginPage.id: (context) => LoginPage(),
        RootPage.id: (context) => RootPage.wrapped(),
      },
    );
  }
}

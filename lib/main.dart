import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/pages/Home/account_page.dart';
import 'package:high_hat/pages/Home/friend_list_page.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/pages/Login/login_page.dart';
import 'package:high_hat/pages/Home/schedule_page.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:provider/provider.dart';
import 'pages/Login/login_check_page.dart';

final ThemeData myLightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: Colors.orange[500],
  primaryColorBrightness: Brightness.light,
  accentColor: Colors.orangeAccent, // Colors.pink[200],
  accentColorBrightness: Brightness.light,
  buttonColor: Colors.orange[50],
);

final ThemeData myDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
  primaryColor: Colors.green[500],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.green[800], // Colors.yellow[200],
  accentColorBrightness: Brightness.dark,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginAuthenticationController>(
          create: (context) => LoginAuthenticationController(),
        ),
        ChangeNotifierProvider<AppDataController>(
          create: (context) => AppDataController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // テーマ等、アプリ全体に影響を及ぼす変更(AppDataController内で管理)
    // があればリビルドさせる
    return Consumer<AppDataController>(
      builder: (context, model, child) {
        return MaterialApp(
          theme: model.isDarkTheme ? myDarkTheme : myLightTheme,
          builder: EasyLoading.init(),
          initialRoute: LoginCheckPage.id,
          routes: {
            LoginCheckPage.id: (context) => LoginCheckPage(),
            LoginPage.id: (context) => LoginPage(),
            SchedulePage.id: (context) => SchedulePage(),
            RegisterSchedulePage.id: (context) => RegisterSchedulePage(),
            FriendListPage.id: (context) => FriendListPage(),
            AccountPage.id: (context) => AccountPage(),
          },
        );
      },
    );
  }
}

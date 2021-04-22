import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/user_data_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/controller/schedule_data_controller.dart';
import 'package:high_hat/local_db/friend_box/friend_box.dart';
import 'package:high_hat/pages/Home/account_page.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/pages/Home/schedule_page.dart';
import 'package:high_hat/pages/Login/login_page.dart';
import 'package:high_hat/pages/home/friend_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'pages/Login/login_check_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'ja_JP'; // 'ja' でも良い
  await initializeDateFormatting('ja_JP');

  // Hiveを初期化
  await Hive.initFlutter();
  Hive.registerAdapter(FriendBoxAdapter());
  await Hive.openBox<FriendBox>('friend_box');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginAuthenticationController>(
          create: (context) => LoginAuthenticationController(),
        ),
        ChangeNotifierProvider<AppDataController>(
          create: (context) => AppDataController(),
        ),
        ChangeNotifierProvider<ScheduleDataController>(
          create: (context) => ScheduleDataController(),
        ),
        ChangeNotifierProvider<UserDataController>(
          create: (context) => UserDataController(),
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
    context.read<AppDataController>().loadSharedPreferenceTheme();
    return Consumer<AppDataController>(
      builder: (context, model, child) {
        return MaterialApp(
          theme: model.themeData,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          initialRoute: LoginCheckPage.id,
          routes: {
            LoginCheckPage.id: (context) => LoginCheckPage(),
            LoginPage.id: (context) => LoginPage(),
            SchedulePage.id: (context) => SchedulePage(),
            RegisterSchedulePage.id: (context) => RegisterSchedulePage(),
            FriendPage.id: (context) => FriendPage(),
            AccountPage.id: (context) => AccountPage(),
          },
        );
      },
    );
  }
}

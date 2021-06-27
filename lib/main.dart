import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:high_hat/application/schedule_app_service.dart';
import 'package:high_hat/application/user_app_service.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/infrastructure/schedule/schedule_factory.dart';
import 'package:high_hat/infrastructure/schedule/schedule_repository.dart';
import 'package:high_hat/infrastructure/user/user_factory.dart';
import 'package:high_hat/infrastructure/user/user_repository.dart';
import 'package:high_hat/pages/Home/account_page.dart';
import 'package:high_hat/pages/Home/register_schedule_page.dart';
import 'package:high_hat/pages/Home/schedule_page.dart';
import 'package:high_hat/pages/Login/login_page.dart';
import 'package:high_hat/pages/home/friend_page.dart';
import 'package:high_hat/pages/login/login_check_page.dart';
import 'package:high_hat/presentation/notifier/answer_notifier.dart';
import 'package:high_hat/presentation/notifier/schedule_notifier.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'ja_JP';
  await initializeDateFormatting('ja_JP');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataController>(
          create: (context) => AppDataController(),
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (context) => UserNotifier(
            service: UserAppService(
              userFactory: UserFactory(),
              userRepository: UserRepository(),
            ),
          ),
        ),
        ChangeNotifierProvider<ScheduleNotifier>(
          create: (context) => ScheduleNotifier(
            service: ScheduleAppService(
              scheduleFactory: ScheduleFactory(),
              scheduleRepository: ScheduleRepository(),
              userRepository: UserRepository(),
            ),
          ),
        ),
        ChangeNotifierProvider<AnswerNotifier>(
          create: (context) => AnswerNotifier(),
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

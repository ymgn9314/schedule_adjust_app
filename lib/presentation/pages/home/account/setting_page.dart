import 'package:flutter/material.dart';
import 'package:high_hat/presentation/pages/home/account/setting_user_id_page.dart';
import 'package:high_hat/presentation/pages/home/account/setting_user_name_page.dart';
import 'package:high_hat/presentation/pages/login/login_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _controller = TextEditingController(text: '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '設定',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                child: Text(
                  'アカウント',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('ユーザー名変更'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (context) {
                                return const SettingUserNamePage();
                              },
                            ),
                          );
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        title: const Text('ユーザーID変更'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (context) {
                                return const SettingUserIdPage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                child: Text(
                  'その他',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('ライセンス'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final info = await PackageInfo.fromPlatform();
                          showLicensePage(
                            context: context,
                            applicationName: info.appName,
                            applicationVersion: info.version,
                            applicationIcon: const SizedBox(
                              height: 64,
                              child: Image(
                                image: AssetImage(
                                    'assets/schedule_icon_transparent.png'),
                              ),
                            ),
                            applicationLegalese: 'みんなでスケジュール調整',
                          );
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        title: const Text('ログアウト'),
                        onTap: () async {
                          // サインアウト処理
                          context.read<UserNotifier>().notifySignOut();

                          // ログインページに遷移
                          await Navigator.of(context).pushAndRemoveUntil<void>(
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }), (_) => false);
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        title: const Text('退会'),
                        onTap: () async {
                          // 退会処理
                          final notifier = context.read<UserNotifier>();
                          await notifier.deleteMyAccount();
                          notifier.notifySignOut();

                          // ログインページに遷移
                          await Navigator.of(context).pushAndRemoveUntil<void>(
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }), (_) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

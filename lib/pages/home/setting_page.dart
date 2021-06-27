import 'package:flutter/material.dart';
import 'package:high_hat/pages/home/setting_user_id_page.dart';
import 'package:high_hat/pages/home/setting_user_name_page.dart';
import 'package:high_hat/pages/login/login_check_page.dart';
import 'package:high_hat/pages/login/login_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _controller = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

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
                          final notifier = context.read<UserNotifier>();
                          // 退会処理
                          notifier.notifySignOut();
                          await notifier.deleteMyAccount();

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
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const SizedBox(height: 24),
          //     const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Text('ユーザーID変更', style: TextStyle(fontSize: 20)),
          //     ),
          //     Form(
          //       key: _formKey,
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 16, vertical: 8),
          //             child: TextFormField(
          //               controller: _controller,
          //               maxLength: 10,
          //               decoration: InputDecoration(
          //                 labelText: '6文字以上(半角英数とアンダースコアのみ)',
          //                 border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(6)),
          //               ),
          //               validator: (value) {
          //                 if (value == null || value.isEmpty) {
          //                   return 'IDを入力してください';
          //                 } else if (value.length < 6) {
          //                   return '6文字以上入力してください';
          //                 } else if (!RegExp(r'^[a-zA-Z0-9_]+$')
          //                     .hasMatch(value)) {
          //                   return '半角英数とアンダースコアしか使用できません';
          //                 }
          //                 return null;
          //               },
          //             ),
          //           ),
          //           Center(
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 if (_formKey.currentState!.validate()) {
          //                   final currentUser = notifier.loggedInUser;
          //                   await notifier.updateMyAccount(
          //                     userId: currentUser?.id.value ?? '',
          //                     name: currentUser?.userName.value ?? '',
          //                     userProfileId: _controller.text,
          //                   );
          //                   Navigator.of(context).pop();
          //                 }
          //               },
          //               child: const Text('変更'),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(height: 36),
          //     const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Text('テーマカラー切り替え', style: TextStyle(fontSize: 20)),
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         ElevatedButton(
          //           onPressed: () {
          //             context
          //                 .read<AppDataController>()
          //                 .applyColorThemeChange(0);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             shape: const CircleBorder(),
          //             primary: Colors.red,
          //           ),
          //           child: null,
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             context
          //                 .read<AppDataController>()
          //                 .applyColorThemeChange(1);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             shape: const CircleBorder(),
          //             primary: Colors.deepOrange,
          //           ),
          //           child: null,
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             context
          //                 .read<AppDataController>()
          //                 .applyColorThemeChange(2);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             shape: const CircleBorder(),
          //             primary: Colors.green,
          //           ),
          //           child: null,
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             context
          //                 .read<AppDataController>()
          //                 .applyColorThemeChange(3);
          //           },
          //           style: ElevatedButton.styleFrom(
          //             shape: const CircleBorder(),
          //             primary: Colors.blue,
          //           ),
          //           child: null,
          //         ),
          //       ],
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const Text('ダークモード'),
          //         Switch(
          //           value: context.read<AppDataController>().isDarkTheme,
          //           activeColor: Colors.grey[700],
          //           activeTrackColor: Colors.grey,
          //           inactiveThumbColor: Colors.white,
          //           inactiveTrackColor: Colors.grey,
          //           onChanged: (isDark) {
          //             context.read<AppDataController>().toggleDarkLightTheme();
          //           },
          //         ),
          //       ],
          //     ),
          //     const SizedBox(height: 36),
          //     const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Text('アカウント', style: TextStyle(fontSize: 20)),
          //     ),
          //     Center(
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.8,
          //         child: ElevatedButton(
          //           onPressed: () async {
          //             await showDialog<void>(
          //               context: context,
          //               builder: (_) {
          //                 return AlertDialog(
          //                   shape: const RoundedRectangleBorder(
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(8)),
          //                   ),
          //                   title: const Text('ログアウトしますか?'),
          //                   content: const Text('ログインすることでサービスを引き続きご利用できます'),
          //                   actions: <Widget>[
          //                     // ボタン領域
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context),
          //                       child: const Text('いいえ'),
          //                     ),
          //                     TextButton(
          //                       onPressed: () async {
          //                         // ダイアログを閉じる
          //                         Navigator.of(context).pop();

          //                         // サインアウト処理
          //                         notifier.notifySignOut();

          //                         await Navigator.of(context)
          //                             .pushAndRemoveUntil<void>(
          //                                 MaterialPageRoute(builder: (context) {
          //                           return LoginCheckPage();
          //                         }), (_) => false);
          //                       },
          //                       child: const Text('はい'),
          //                     ),
          //                   ],
          //                 );
          //               },
          //             );
          //           },
          //           child: const Text('ログアウト'),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 16),
          //     Center(
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.8,
          //         child: ElevatedButton(
          //           onPressed: () {
          //             showDialog<void>(
          //               context: context,
          //               builder: (_) {
          //                 return AlertDialog(
          //                   shape: const RoundedRectangleBorder(
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(8)),
          //                   ),
          //                   title: const Text('アカウントを削除しますか?'),
          //                   content: const Text('現在調整中の予定や友達は全て閲覧できなくなります'),
          //                   actions: <Widget>[
          //                     // ボタン領域
          //                     TextButton(
          //                       onPressed: () => Navigator.pop(context),
          //                       child: const Text('いいえ'),
          //                     ),
          //                     TextButton(
          //                       onPressed: () async {
          //                         // ダイアログを閉じる
          //                         Navigator.of(context).pop();

          //                         // ローディング表示する
          //                         await EasyLoading.show();

          //                         // 退会処理
          //                         notifier.notifySignOut();
          //                         await notifier.deleteMyAccount();

          //                         // ローディング表示消す
          //                         await EasyLoading.dismiss();

          //                         // ログインページへ遷移
          //                         await Navigator.of(context)
          //                             .pushAndRemoveUntil<void>(
          //                                 MaterialPageRoute(builder: (context) {
          //                           return LoginCheckPage();
          //                         }), (_) => false);
          //                       },
          //                       child: const Text('はい'),
          //                     ),
          //                   ],
          //                 );
          //               },
          //             );
          //           },
          //           child: const Text('アカウント削除'),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 32),
          //     const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Text('その他', style: TextStyle(fontSize: 20)),
          //     ),
          //     Center(
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.8,
          //         child: ElevatedButton(
          //             onPressed: () async {
          //               final info = await PackageInfo.fromPlatform();
          //               showLicensePage(
          //                 context: context,
          //                 applicationName: info.appName,
          //                 applicationVersion: info.version,
          //                 applicationIcon: SizedBox(
          //                   height: MediaQuery.of(context).size.height * 0.1,
          //                   child: const Padding(
          //                     padding: EdgeInsets.all(8),
          //                     child: Image(
          //                         image: AssetImage(
          //                             'assets/schedule_icon_transparent.png')),
          //                   ),
          //                 ),
          //                 applicationLegalese: 'みんなでスケジュール調整',
          //               );
          //             },
          //             child: const Text('ライセンス')),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}

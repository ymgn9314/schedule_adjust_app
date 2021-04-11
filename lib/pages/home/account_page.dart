import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  static const id = 'account_page';

  @override
  Widget build(BuildContext context) {
    print('AccountPage#build()');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    context
                        .read<LoginAuthenticationController>()
                        .user!
                        .photoURL!,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context
                      .read<LoginAuthenticationController>()
                      .user!
                      .displayName!
                      .toString(),
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 128,
                  child: GridView.count(
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      MaterialButton(
                        color: Colors.red,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.red, Colors.redAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.orange,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.orange, Colors.orangeAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.yellow,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.yellow, Colors.yellowAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.green,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.green, Colors.greenAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.blue, Colors.blueAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.purple,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.purple, Colors.purpleAccent);
                        },
                      ),
                      MaterialButton(
                        color: Colors.pink,
                        shape: const CircleBorder(),
                        onPressed: () {
                          context
                              .read<AppDataController>()
                              .applyColorThemeChange(
                                  Colors.pink, Colors.pinkAccent);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AppDataController>().toggleDarkLightTheme();
                  },
                  child: const Text('ライト/ダークテーマ切り替え'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                context.read<LoginAuthenticationController>().logout();
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}

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
                      .displayName!,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  context.read<LoginAuthenticationController>().user!.uid,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppDataController>()
                            .applyColorThemeChange(0);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.red,
                      ),
                      child: null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppDataController>()
                            .applyColorThemeChange(1);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.deepOrange,
                      ),
                      child: null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppDataController>()
                            .applyColorThemeChange(2);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.green,
                      ),
                      child: null,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<AppDataController>()
                            .applyColorThemeChange(3);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.blue,
                      ),
                      child: null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('テーマカラー切り替え'),
                    Switch(
                      value: context.read<AppDataController>().isDarkTheme,
                      activeColor: Colors.grey[700],
                      activeTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (isDark) {
                        context
                            .read<AppDataController>()
                            .toggleDarkLightTheme();
                      },
                    ),
                  ],
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

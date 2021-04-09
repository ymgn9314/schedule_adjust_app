import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  static const id = 'account_page';
  @override
  Widget build(BuildContext context) {
    print('AccountPage#build()');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(
              context.read<LoginAuthenticationController>().user!.photoURL!,
            ),
          ),
          Text(
            context
                .read<LoginAuthenticationController>()
                .user!
                .displayName!
                .toString(),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${context.read<LoginAuthenticationController>().user!.uid}',
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppDataController>().toggleTheme();
            },
            child: const Text('テーマ切り替え'),
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
    );
  }
}

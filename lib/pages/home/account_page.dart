import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_hat/controller/app_data_controller.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:high_hat/pages/home/setting_page.dart';
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(context
                          .read<LoginAuthenticationController>()
                          .user!
                          .uid)
                      .snapshots()
                      .handleError(() {}),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError || !snapshot.data!.exists) {
                      return const Text(
                        '不明なユーザーID',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                        '',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      );
                    }
                    return Text(
                      snapshot.data!.get('userId') as String,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingPage();
                      },
                    ),
                  );
                },
                child: const Text('設定',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

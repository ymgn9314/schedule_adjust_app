import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_hat/presentation/pages/home/account/setting_page.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  static const id = 'account_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'アカウント',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, size: 32),
            padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) {
                    return SettingPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: context.select(
                        (UserNotifier notifier) => NetworkImage(
                          notifier.loggedInUser?.avatarUrl.value ?? '',
                        ),
                      ),
                    ),
                  ),
                  context.select(
                    (UserNotifier notifier) => Text(
                      notifier.loggedInUser!.userName.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  context.select(
                    (UserNotifier notifier) => Text(
                      notifier.loggedInUser!.userProfileId.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

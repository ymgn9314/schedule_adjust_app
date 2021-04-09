import 'package:flutter/material.dart';
import 'package:high_hat/controller/login_authentication_controller.dart';
import 'package:provider/provider.dart';

class FriendListPage extends StatelessWidget {
  static const id = 'friend_list_page';
  @override
  Widget build(BuildContext context) {
    print('FriendListPage#build()');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<LoginAuthenticationController>(
                builder: (context, model, child) {
              return const Text('In FriendListPage: ');
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            null, //context.read<LoginAuthenticationController>().add(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.person_add,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

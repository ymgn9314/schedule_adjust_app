import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FriendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.supervisor_account,
          size: 200,
        ),
      ),
    );
  }
}

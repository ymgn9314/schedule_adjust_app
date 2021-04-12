import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  FriendCard({
    required this.displayName,
    required this.photoUrl,
  });

  String displayName;
  String photoUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(photoUrl),
      ),
      title: Text(displayName),
    );
  }
}

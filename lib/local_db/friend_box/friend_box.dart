import 'dart:io';
import 'package:hive/hive.dart';

part 'friend_box.g.dart';

@HiveType(typeId: 1)
class FriendBox {
  FriendBox(
      {required this.uid, required this.displayName, required this.photoUrl});

  @HiveField(0)
  String uid;

  @HiveField(1)
  String displayName;

  @HiveField(2)
  String photoUrl;
}

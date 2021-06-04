import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

@immutable
class UserFriend {
  const UserFriend(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserFriend && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final List<UserId> value;
}

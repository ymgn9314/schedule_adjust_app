import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/value/user_id.dart';

@immutable
class Participants {
  Participants(this.value) {
    if (value.isEmpty) {
      throw Exception('Participants must not be empty.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Participants && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final List<UserId> value;
}

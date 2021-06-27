import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserProfileId {
  UserProfileId(this.value) {
    if (value.isEmpty) {
      throw Exception('User name must not be empty.');
    }
    if (value.length < 6 || value.length > 10) {
      throw Exception('UserProfileId must be 6<= and <=10.');
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      throw Exception('Only alphabet and underscores are allowed.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileId && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

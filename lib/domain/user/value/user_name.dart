import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserName {
  UserName(this.value) {
    if (value.isEmpty) {
      throw Exception('User name must not be empty.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserName && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

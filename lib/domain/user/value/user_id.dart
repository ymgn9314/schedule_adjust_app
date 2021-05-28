import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserId {
  UserId(this.value) {
    if (value.isEmpty) {
      throw Exception('UserId must not be empty.');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserId && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

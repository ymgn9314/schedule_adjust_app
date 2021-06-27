import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserComment {
  const UserComment(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserComment && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

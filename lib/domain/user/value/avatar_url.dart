import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AvatarUrl {
  AvatarUrl(this.value) {
    // if (value.isEmpty) {
    //   throw Exception('AvatarUrl must not be empty.');
    // }
    // TODO(ymgn9314): 有効なURLかチェック
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AvatarUrl && other.value == value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  final String value;
}

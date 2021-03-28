import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'root_page_notifier.freezed.dart';

@freezed
class RootPageState with _$RootPageState {
  const factory RootPageState({
    @Default(0) int viewIndex,
  }) = _RootPageState;
}

class RootPageNotifier extends StateNotifier<RootPageState> with LocatorMixin {
  RootPageNotifier({required this.context}) : super(const RootPageState());

  final BuildContext context;

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  void initState() {}

  int get viewIndex => state.viewIndex;

  set viewIndex(int index) {
    state = state.copyWith(viewIndex: index);
  }
}

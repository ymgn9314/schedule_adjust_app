// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'schedule_view_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ScheduleViewStateTearOff {
  const _$ScheduleViewStateTearOff();

  _ScheduleViewState call({List<Widget> dialogItems = const <Widget>[]}) {
    return _ScheduleViewState(
      dialogItems: dialogItems,
    );
  }
}

/// @nodoc
const $ScheduleViewState = _$ScheduleViewStateTearOff();

/// @nodoc
mixin _$ScheduleViewState {
  List<Widget> get dialogItems => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduleViewStateCopyWith<ScheduleViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleViewStateCopyWith<$Res> {
  factory $ScheduleViewStateCopyWith(
          ScheduleViewState value, $Res Function(ScheduleViewState) then) =
      _$ScheduleViewStateCopyWithImpl<$Res>;
  $Res call({List<Widget> dialogItems});
}

/// @nodoc
class _$ScheduleViewStateCopyWithImpl<$Res>
    implements $ScheduleViewStateCopyWith<$Res> {
  _$ScheduleViewStateCopyWithImpl(this._value, this._then);

  final ScheduleViewState _value;
  // ignore: unused_field
  final $Res Function(ScheduleViewState) _then;

  @override
  $Res call({
    Object? dialogItems = freezed,
  }) {
    return _then(_value.copyWith(
      dialogItems: dialogItems == freezed
          ? _value.dialogItems
          : dialogItems // ignore: cast_nullable_to_non_nullable
              as List<Widget>,
    ));
  }
}

/// @nodoc
abstract class _$ScheduleViewStateCopyWith<$Res>
    implements $ScheduleViewStateCopyWith<$Res> {
  factory _$ScheduleViewStateCopyWith(
          _ScheduleViewState value, $Res Function(_ScheduleViewState) then) =
      __$ScheduleViewStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Widget> dialogItems});
}

/// @nodoc
class __$ScheduleViewStateCopyWithImpl<$Res>
    extends _$ScheduleViewStateCopyWithImpl<$Res>
    implements _$ScheduleViewStateCopyWith<$Res> {
  __$ScheduleViewStateCopyWithImpl(
      _ScheduleViewState _value, $Res Function(_ScheduleViewState) _then)
      : super(_value, (v) => _then(v as _ScheduleViewState));

  @override
  _ScheduleViewState get _value => super._value as _ScheduleViewState;

  @override
  $Res call({
    Object? dialogItems = freezed,
  }) {
    return _then(_ScheduleViewState(
      dialogItems: dialogItems == freezed
          ? _value.dialogItems
          : dialogItems // ignore: cast_nullable_to_non_nullable
              as List<Widget>,
    ));
  }
}

/// @nodoc
class _$_ScheduleViewState
    with DiagnosticableTreeMixin
    implements _ScheduleViewState {
  const _$_ScheduleViewState({this.dialogItems = const <Widget>[]});

  @JsonKey(defaultValue: const <Widget>[])
  @override
  final List<Widget> dialogItems;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleViewState(dialogItems: $dialogItems)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleViewState'))
      ..add(DiagnosticsProperty('dialogItems', dialogItems));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScheduleViewState &&
            (identical(other.dialogItems, dialogItems) ||
                const DeepCollectionEquality()
                    .equals(other.dialogItems, dialogItems)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(dialogItems);

  @JsonKey(ignore: true)
  @override
  _$ScheduleViewStateCopyWith<_ScheduleViewState> get copyWith =>
      __$ScheduleViewStateCopyWithImpl<_ScheduleViewState>(this, _$identity);
}

abstract class _ScheduleViewState implements ScheduleViewState {
  const factory _ScheduleViewState({List<Widget> dialogItems}) =
      _$_ScheduleViewState;

  @override
  List<Widget> get dialogItems => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ScheduleViewStateCopyWith<_ScheduleViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

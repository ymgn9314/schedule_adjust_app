// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'root_page_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RootPageStateTearOff {
  const _$RootPageStateTearOff();

  _RootPageState call({int viewIndex = 0}) {
    return _RootPageState(
      viewIndex: viewIndex,
    );
  }
}

/// @nodoc
const $RootPageState = _$RootPageStateTearOff();

/// @nodoc
mixin _$RootPageState {
  int get viewIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RootPageStateCopyWith<RootPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RootPageStateCopyWith<$Res> {
  factory $RootPageStateCopyWith(
          RootPageState value, $Res Function(RootPageState) then) =
      _$RootPageStateCopyWithImpl<$Res>;
  $Res call({int viewIndex});
}

/// @nodoc
class _$RootPageStateCopyWithImpl<$Res>
    implements $RootPageStateCopyWith<$Res> {
  _$RootPageStateCopyWithImpl(this._value, this._then);

  final RootPageState _value;
  // ignore: unused_field
  final $Res Function(RootPageState) _then;

  @override
  $Res call({
    Object? viewIndex = freezed,
  }) {
    return _then(_value.copyWith(
      viewIndex: viewIndex == freezed
          ? _value.viewIndex
          : viewIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$RootPageStateCopyWith<$Res>
    implements $RootPageStateCopyWith<$Res> {
  factory _$RootPageStateCopyWith(
          _RootPageState value, $Res Function(_RootPageState) then) =
      __$RootPageStateCopyWithImpl<$Res>;
  @override
  $Res call({int viewIndex});
}

/// @nodoc
class __$RootPageStateCopyWithImpl<$Res>
    extends _$RootPageStateCopyWithImpl<$Res>
    implements _$RootPageStateCopyWith<$Res> {
  __$RootPageStateCopyWithImpl(
      _RootPageState _value, $Res Function(_RootPageState) _then)
      : super(_value, (v) => _then(v as _RootPageState));

  @override
  _RootPageState get _value => super._value as _RootPageState;

  @override
  $Res call({
    Object? viewIndex = freezed,
  }) {
    return _then(_RootPageState(
      viewIndex: viewIndex == freezed
          ? _value.viewIndex
          : viewIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
class _$_RootPageState with DiagnosticableTreeMixin implements _RootPageState {
  const _$_RootPageState({this.viewIndex = 0});

  @JsonKey(defaultValue: 0)
  @override
  final int viewIndex;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RootPageState(viewIndex: $viewIndex)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RootPageState'))
      ..add(DiagnosticsProperty('viewIndex', viewIndex));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RootPageState &&
            (identical(other.viewIndex, viewIndex) ||
                const DeepCollectionEquality()
                    .equals(other.viewIndex, viewIndex)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(viewIndex);

  @JsonKey(ignore: true)
  @override
  _$RootPageStateCopyWith<_RootPageState> get copyWith =>
      __$RootPageStateCopyWithImpl<_RootPageState>(this, _$identity);
}

abstract class _RootPageState implements RootPageState {
  const factory _RootPageState({int viewIndex}) = _$_RootPageState;

  @override
  int get viewIndex => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$RootPageStateCopyWith<_RootPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

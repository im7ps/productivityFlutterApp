// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizState _$QuizStateFromJson(Map<String, dynamic> json) {
  return _QuizState.fromJson(json);
}

/// @nodoc
mixin _$QuizState {
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  Map<String, int> get accumulatedStats => throw _privateConstructorUsedError;
  bool get isFinished => throw _privateConstructorUsedError;

  /// Serializes this QuizState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStateCopyWith<QuizState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStateCopyWith<$Res> {
  factory $QuizStateCopyWith(QuizState value, $Res Function(QuizState) then) =
      _$QuizStateCopyWithImpl<$Res, QuizState>;
  @useResult
  $Res call({
    int currentQuestionIndex,
    Map<String, int> accumulatedStats,
    bool isFinished,
  });
}

/// @nodoc
class _$QuizStateCopyWithImpl<$Res, $Val extends QuizState>
    implements $QuizStateCopyWith<$Res> {
  _$QuizStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentQuestionIndex = null,
    Object? accumulatedStats = null,
    Object? isFinished = null,
  }) {
    return _then(
      _value.copyWith(
            currentQuestionIndex: null == currentQuestionIndex
                ? _value.currentQuestionIndex
                : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            accumulatedStats: null == accumulatedStats
                ? _value.accumulatedStats
                : accumulatedStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            isFinished: null == isFinished
                ? _value.isFinished
                : isFinished // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizStateImplCopyWith<$Res>
    implements $QuizStateCopyWith<$Res> {
  factory _$$QuizStateImplCopyWith(
    _$QuizStateImpl value,
    $Res Function(_$QuizStateImpl) then,
  ) = __$$QuizStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentQuestionIndex,
    Map<String, int> accumulatedStats,
    bool isFinished,
  });
}

/// @nodoc
class __$$QuizStateImplCopyWithImpl<$Res>
    extends _$QuizStateCopyWithImpl<$Res, _$QuizStateImpl>
    implements _$$QuizStateImplCopyWith<$Res> {
  __$$QuizStateImplCopyWithImpl(
    _$QuizStateImpl _value,
    $Res Function(_$QuizStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentQuestionIndex = null,
    Object? accumulatedStats = null,
    Object? isFinished = null,
  }) {
    return _then(
      _$QuizStateImpl(
        currentQuestionIndex: null == currentQuestionIndex
            ? _value.currentQuestionIndex
            : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        accumulatedStats: null == accumulatedStats
            ? _value._accumulatedStats
            : accumulatedStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        isFinished: null == isFinished
            ? _value.isFinished
            : isFinished // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizStateImpl implements _QuizState {
  const _$QuizStateImpl({
    this.currentQuestionIndex = 0,
    final Map<String, int> accumulatedStats = const {
      'stat_strength': 10,
      'stat_endurance': 10,
      'stat_intelligence': 10,
      'stat_focus': 10,
    },
    this.isFinished = false,
  }) : _accumulatedStats = accumulatedStats;

  factory _$QuizStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizStateImplFromJson(json);

  @override
  @JsonKey()
  final int currentQuestionIndex;
  final Map<String, int> _accumulatedStats;
  @override
  @JsonKey()
  Map<String, int> get accumulatedStats {
    if (_accumulatedStats is EqualUnmodifiableMapView) return _accumulatedStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_accumulatedStats);
  }

  @override
  @JsonKey()
  final bool isFinished;

  @override
  String toString() {
    return 'QuizState(currentQuestionIndex: $currentQuestionIndex, accumulatedStats: $accumulatedStats, isFinished: $isFinished)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStateImpl &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            const DeepCollectionEquality().equals(
              other._accumulatedStats,
              _accumulatedStats,
            ) &&
            (identical(other.isFinished, isFinished) ||
                other.isFinished == isFinished));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentQuestionIndex,
    const DeepCollectionEquality().hash(_accumulatedStats),
    isFinished,
  );

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      __$$QuizStateImplCopyWithImpl<_$QuizStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizStateImplToJson(this);
  }
}

abstract class _QuizState implements QuizState {
  const factory _QuizState({
    final int currentQuestionIndex,
    final Map<String, int> accumulatedStats,
    final bool isFinished,
  }) = _$QuizStateImpl;

  factory _QuizState.fromJson(Map<String, dynamic> json) =
      _$QuizStateImpl.fromJson;

  @override
  int get currentQuestionIndex;
  @override
  Map<String, int> get accumulatedStats;
  @override
  bool get isFinished;

  /// Create a copy of QuizState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStateImplCopyWith<_$QuizStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

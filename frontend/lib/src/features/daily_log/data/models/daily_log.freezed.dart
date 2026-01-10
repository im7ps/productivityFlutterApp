// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyLogCreate _$DailyLogCreateFromJson(Map<String, dynamic> json) {
  return _DailyLogCreate.fromJson(json);
}

/// @nodoc
mixin _$DailyLogCreate {
  String get day => throw _privateConstructorUsedError; // Format: YYYY-MM-DD
  double get sleepHours => throw _privateConstructorUsedError;
  int get sleepQuality => throw _privateConstructorUsedError;
  int get moodScore => throw _privateConstructorUsedError;
  int get dietQuality => throw _privateConstructorUsedError;
  int get exerciseMinutes => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this DailyLogCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyLogCreateCopyWith<DailyLogCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLogCreateCopyWith<$Res> {
  factory $DailyLogCreateCopyWith(
    DailyLogCreate value,
    $Res Function(DailyLogCreate) then,
  ) = _$DailyLogCreateCopyWithImpl<$Res, DailyLogCreate>;
  @useResult
  $Res call({
    String day,
    double sleepHours,
    int sleepQuality,
    int moodScore,
    int dietQuality,
    int exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class _$DailyLogCreateCopyWithImpl<$Res, $Val extends DailyLogCreate>
    implements $DailyLogCreateCopyWith<$Res> {
  _$DailyLogCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? sleepHours = null,
    Object? sleepQuality = null,
    Object? moodScore = null,
    Object? dietQuality = null,
    Object? exerciseMinutes = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            sleepHours: null == sleepHours
                ? _value.sleepHours
                : sleepHours // ignore: cast_nullable_to_non_nullable
                      as double,
            sleepQuality: null == sleepQuality
                ? _value.sleepQuality
                : sleepQuality // ignore: cast_nullable_to_non_nullable
                      as int,
            moodScore: null == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                      as int,
            dietQuality: null == dietQuality
                ? _value.dietQuality
                : dietQuality // ignore: cast_nullable_to_non_nullable
                      as int,
            exerciseMinutes: null == exerciseMinutes
                ? _value.exerciseMinutes
                : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyLogCreateImplCopyWith<$Res>
    implements $DailyLogCreateCopyWith<$Res> {
  factory _$$DailyLogCreateImplCopyWith(
    _$DailyLogCreateImpl value,
    $Res Function(_$DailyLogCreateImpl) then,
  ) = __$$DailyLogCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String day,
    double sleepHours,
    int sleepQuality,
    int moodScore,
    int dietQuality,
    int exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class __$$DailyLogCreateImplCopyWithImpl<$Res>
    extends _$DailyLogCreateCopyWithImpl<$Res, _$DailyLogCreateImpl>
    implements _$$DailyLogCreateImplCopyWith<$Res> {
  __$$DailyLogCreateImplCopyWithImpl(
    _$DailyLogCreateImpl _value,
    $Res Function(_$DailyLogCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? sleepHours = null,
    Object? sleepQuality = null,
    Object? moodScore = null,
    Object? dietQuality = null,
    Object? exerciseMinutes = null,
    Object? note = freezed,
  }) {
    return _then(
      _$DailyLogCreateImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        sleepHours: null == sleepHours
            ? _value.sleepHours
            : sleepHours // ignore: cast_nullable_to_non_nullable
                  as double,
        sleepQuality: null == sleepQuality
            ? _value.sleepQuality
            : sleepQuality // ignore: cast_nullable_to_non_nullable
                  as int,
        moodScore: null == moodScore
            ? _value.moodScore
            : moodScore // ignore: cast_nullable_to_non_nullable
                  as int,
        dietQuality: null == dietQuality
            ? _value.dietQuality
            : dietQuality // ignore: cast_nullable_to_non_nullable
                  as int,
        exerciseMinutes: null == exerciseMinutes
            ? _value.exerciseMinutes
            : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLogCreateImpl implements _DailyLogCreate {
  const _$DailyLogCreateImpl({
    required this.day,
    this.sleepHours = 0,
    this.sleepQuality = 5,
    this.moodScore = 5,
    this.dietQuality = 5,
    this.exerciseMinutes = 0,
    this.note,
  });

  factory _$DailyLogCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLogCreateImplFromJson(json);

  @override
  final String day;
  // Format: YYYY-MM-DD
  @override
  @JsonKey()
  final double sleepHours;
  @override
  @JsonKey()
  final int sleepQuality;
  @override
  @JsonKey()
  final int moodScore;
  @override
  @JsonKey()
  final int dietQuality;
  @override
  @JsonKey()
  final int exerciseMinutes;
  @override
  final String? note;

  @override
  String toString() {
    return 'DailyLogCreate(day: $day, sleepHours: $sleepHours, sleepQuality: $sleepQuality, moodScore: $moodScore, dietQuality: $dietQuality, exerciseMinutes: $exerciseMinutes, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLogCreateImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.dietQuality, dietQuality) ||
                other.dietQuality == dietQuality) &&
            (identical(other.exerciseMinutes, exerciseMinutes) ||
                other.exerciseMinutes == exerciseMinutes) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    sleepHours,
    sleepQuality,
    moodScore,
    dietQuality,
    exerciseMinutes,
    note,
  );

  /// Create a copy of DailyLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLogCreateImplCopyWith<_$DailyLogCreateImpl> get copyWith =>
      __$$DailyLogCreateImplCopyWithImpl<_$DailyLogCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLogCreateImplToJson(this);
  }
}

abstract class _DailyLogCreate implements DailyLogCreate {
  const factory _DailyLogCreate({
    required final String day,
    final double sleepHours,
    final int sleepQuality,
    final int moodScore,
    final int dietQuality,
    final int exerciseMinutes,
    final String? note,
  }) = _$DailyLogCreateImpl;

  factory _DailyLogCreate.fromJson(Map<String, dynamic> json) =
      _$DailyLogCreateImpl.fromJson;

  @override
  String get day; // Format: YYYY-MM-DD
  @override
  double get sleepHours;
  @override
  int get sleepQuality;
  @override
  int get moodScore;
  @override
  int get dietQuality;
  @override
  int get exerciseMinutes;
  @override
  String? get note;

  /// Create a copy of DailyLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyLogCreateImplCopyWith<_$DailyLogCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyLogRead _$DailyLogReadFromJson(Map<String, dynamic> json) {
  return _DailyLogRead.fromJson(json);
}

/// @nodoc
mixin _$DailyLogRead {
  String get id => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  double get sleepHours => throw _privateConstructorUsedError;
  int get sleepQuality => throw _privateConstructorUsedError;
  int get moodScore => throw _privateConstructorUsedError;
  int get dietQuality => throw _privateConstructorUsedError;
  int get exerciseMinutes => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this DailyLogRead to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyLogRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyLogReadCopyWith<DailyLogRead> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLogReadCopyWith<$Res> {
  factory $DailyLogReadCopyWith(
    DailyLogRead value,
    $Res Function(DailyLogRead) then,
  ) = _$DailyLogReadCopyWithImpl<$Res, DailyLogRead>;
  @useResult
  $Res call({
    String id,
    String day,
    double sleepHours,
    int sleepQuality,
    int moodScore,
    int dietQuality,
    int exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class _$DailyLogReadCopyWithImpl<$Res, $Val extends DailyLogRead>
    implements $DailyLogReadCopyWith<$Res> {
  _$DailyLogReadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyLogRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? day = null,
    Object? sleepHours = null,
    Object? sleepQuality = null,
    Object? moodScore = null,
    Object? dietQuality = null,
    Object? exerciseMinutes = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            sleepHours: null == sleepHours
                ? _value.sleepHours
                : sleepHours // ignore: cast_nullable_to_non_nullable
                      as double,
            sleepQuality: null == sleepQuality
                ? _value.sleepQuality
                : sleepQuality // ignore: cast_nullable_to_non_nullable
                      as int,
            moodScore: null == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                      as int,
            dietQuality: null == dietQuality
                ? _value.dietQuality
                : dietQuality // ignore: cast_nullable_to_non_nullable
                      as int,
            exerciseMinutes: null == exerciseMinutes
                ? _value.exerciseMinutes
                : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyLogReadImplCopyWith<$Res>
    implements $DailyLogReadCopyWith<$Res> {
  factory _$$DailyLogReadImplCopyWith(
    _$DailyLogReadImpl value,
    $Res Function(_$DailyLogReadImpl) then,
  ) = __$$DailyLogReadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String day,
    double sleepHours,
    int sleepQuality,
    int moodScore,
    int dietQuality,
    int exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class __$$DailyLogReadImplCopyWithImpl<$Res>
    extends _$DailyLogReadCopyWithImpl<$Res, _$DailyLogReadImpl>
    implements _$$DailyLogReadImplCopyWith<$Res> {
  __$$DailyLogReadImplCopyWithImpl(
    _$DailyLogReadImpl _value,
    $Res Function(_$DailyLogReadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyLogRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? day = null,
    Object? sleepHours = null,
    Object? sleepQuality = null,
    Object? moodScore = null,
    Object? dietQuality = null,
    Object? exerciseMinutes = null,
    Object? note = freezed,
  }) {
    return _then(
      _$DailyLogReadImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        sleepHours: null == sleepHours
            ? _value.sleepHours
            : sleepHours // ignore: cast_nullable_to_non_nullable
                  as double,
        sleepQuality: null == sleepQuality
            ? _value.sleepQuality
            : sleepQuality // ignore: cast_nullable_to_non_nullable
                  as int,
        moodScore: null == moodScore
            ? _value.moodScore
            : moodScore // ignore: cast_nullable_to_non_nullable
                  as int,
        dietQuality: null == dietQuality
            ? _value.dietQuality
            : dietQuality // ignore: cast_nullable_to_non_nullable
                  as int,
        exerciseMinutes: null == exerciseMinutes
            ? _value.exerciseMinutes
            : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLogReadImpl implements _DailyLogRead {
  const _$DailyLogReadImpl({
    required this.id,
    required this.day,
    required this.sleepHours,
    required this.sleepQuality,
    required this.moodScore,
    required this.dietQuality,
    required this.exerciseMinutes,
    this.note,
  });

  factory _$DailyLogReadImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLogReadImplFromJson(json);

  @override
  final String id;
  @override
  final String day;
  @override
  final double sleepHours;
  @override
  final int sleepQuality;
  @override
  final int moodScore;
  @override
  final int dietQuality;
  @override
  final int exerciseMinutes;
  @override
  final String? note;

  @override
  String toString() {
    return 'DailyLogRead(id: $id, day: $day, sleepHours: $sleepHours, sleepQuality: $sleepQuality, moodScore: $moodScore, dietQuality: $dietQuality, exerciseMinutes: $exerciseMinutes, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLogReadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.dietQuality, dietQuality) ||
                other.dietQuality == dietQuality) &&
            (identical(other.exerciseMinutes, exerciseMinutes) ||
                other.exerciseMinutes == exerciseMinutes) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    day,
    sleepHours,
    sleepQuality,
    moodScore,
    dietQuality,
    exerciseMinutes,
    note,
  );

  /// Create a copy of DailyLogRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLogReadImplCopyWith<_$DailyLogReadImpl> get copyWith =>
      __$$DailyLogReadImplCopyWithImpl<_$DailyLogReadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLogReadImplToJson(this);
  }
}

abstract class _DailyLogRead implements DailyLogRead {
  const factory _DailyLogRead({
    required final String id,
    required final String day,
    required final double sleepHours,
    required final int sleepQuality,
    required final int moodScore,
    required final int dietQuality,
    required final int exerciseMinutes,
    final String? note,
  }) = _$DailyLogReadImpl;

  factory _DailyLogRead.fromJson(Map<String, dynamic> json) =
      _$DailyLogReadImpl.fromJson;

  @override
  String get id;
  @override
  String get day;
  @override
  double get sleepHours;
  @override
  int get sleepQuality;
  @override
  int get moodScore;
  @override
  int get dietQuality;
  @override
  int get exerciseMinutes;
  @override
  String? get note;

  /// Create a copy of DailyLogRead
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyLogReadImplCopyWith<_$DailyLogReadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyLogUpdate _$DailyLogUpdateFromJson(Map<String, dynamic> json) {
  return _DailyLogUpdate.fromJson(json);
}

/// @nodoc
mixin _$DailyLogUpdate {
  double? get sleepHours => throw _privateConstructorUsedError;
  int? get sleepQuality => throw _privateConstructorUsedError;
  int? get moodScore => throw _privateConstructorUsedError;
  int? get dietQuality => throw _privateConstructorUsedError;
  int? get exerciseMinutes => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this DailyLogUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyLogUpdateCopyWith<DailyLogUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLogUpdateCopyWith<$Res> {
  factory $DailyLogUpdateCopyWith(
    DailyLogUpdate value,
    $Res Function(DailyLogUpdate) then,
  ) = _$DailyLogUpdateCopyWithImpl<$Res, DailyLogUpdate>;
  @useResult
  $Res call({
    double? sleepHours,
    int? sleepQuality,
    int? moodScore,
    int? dietQuality,
    int? exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class _$DailyLogUpdateCopyWithImpl<$Res, $Val extends DailyLogUpdate>
    implements $DailyLogUpdateCopyWith<$Res> {
  _$DailyLogUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepHours = freezed,
    Object? sleepQuality = freezed,
    Object? moodScore = freezed,
    Object? dietQuality = freezed,
    Object? exerciseMinutes = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            sleepHours: freezed == sleepHours
                ? _value.sleepHours
                : sleepHours // ignore: cast_nullable_to_non_nullable
                      as double?,
            sleepQuality: freezed == sleepQuality
                ? _value.sleepQuality
                : sleepQuality // ignore: cast_nullable_to_non_nullable
                      as int?,
            moodScore: freezed == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            dietQuality: freezed == dietQuality
                ? _value.dietQuality
                : dietQuality // ignore: cast_nullable_to_non_nullable
                      as int?,
            exerciseMinutes: freezed == exerciseMinutes
                ? _value.exerciseMinutes
                : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyLogUpdateImplCopyWith<$Res>
    implements $DailyLogUpdateCopyWith<$Res> {
  factory _$$DailyLogUpdateImplCopyWith(
    _$DailyLogUpdateImpl value,
    $Res Function(_$DailyLogUpdateImpl) then,
  ) = __$$DailyLogUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double? sleepHours,
    int? sleepQuality,
    int? moodScore,
    int? dietQuality,
    int? exerciseMinutes,
    String? note,
  });
}

/// @nodoc
class __$$DailyLogUpdateImplCopyWithImpl<$Res>
    extends _$DailyLogUpdateCopyWithImpl<$Res, _$DailyLogUpdateImpl>
    implements _$$DailyLogUpdateImplCopyWith<$Res> {
  __$$DailyLogUpdateImplCopyWithImpl(
    _$DailyLogUpdateImpl _value,
    $Res Function(_$DailyLogUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepHours = freezed,
    Object? sleepQuality = freezed,
    Object? moodScore = freezed,
    Object? dietQuality = freezed,
    Object? exerciseMinutes = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$DailyLogUpdateImpl(
        sleepHours: freezed == sleepHours
            ? _value.sleepHours
            : sleepHours // ignore: cast_nullable_to_non_nullable
                  as double?,
        sleepQuality: freezed == sleepQuality
            ? _value.sleepQuality
            : sleepQuality // ignore: cast_nullable_to_non_nullable
                  as int?,
        moodScore: freezed == moodScore
            ? _value.moodScore
            : moodScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        dietQuality: freezed == dietQuality
            ? _value.dietQuality
            : dietQuality // ignore: cast_nullable_to_non_nullable
                  as int?,
        exerciseMinutes: freezed == exerciseMinutes
            ? _value.exerciseMinutes
            : exerciseMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyLogUpdateImpl implements _DailyLogUpdate {
  const _$DailyLogUpdateImpl({
    this.sleepHours,
    this.sleepQuality,
    this.moodScore,
    this.dietQuality,
    this.exerciseMinutes,
    this.note,
  });

  factory _$DailyLogUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLogUpdateImplFromJson(json);

  @override
  final double? sleepHours;
  @override
  final int? sleepQuality;
  @override
  final int? moodScore;
  @override
  final int? dietQuality;
  @override
  final int? exerciseMinutes;
  @override
  final String? note;

  @override
  String toString() {
    return 'DailyLogUpdate(sleepHours: $sleepHours, sleepQuality: $sleepQuality, moodScore: $moodScore, dietQuality: $dietQuality, exerciseMinutes: $exerciseMinutes, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLogUpdateImpl &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.dietQuality, dietQuality) ||
                other.dietQuality == dietQuality) &&
            (identical(other.exerciseMinutes, exerciseMinutes) ||
                other.exerciseMinutes == exerciseMinutes) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sleepHours,
    sleepQuality,
    moodScore,
    dietQuality,
    exerciseMinutes,
    note,
  );

  /// Create a copy of DailyLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLogUpdateImplCopyWith<_$DailyLogUpdateImpl> get copyWith =>
      __$$DailyLogUpdateImplCopyWithImpl<_$DailyLogUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLogUpdateImplToJson(this);
  }
}

abstract class _DailyLogUpdate implements DailyLogUpdate {
  const factory _DailyLogUpdate({
    final double? sleepHours,
    final int? sleepQuality,
    final int? moodScore,
    final int? dietQuality,
    final int? exerciseMinutes,
    final String? note,
  }) = _$DailyLogUpdateImpl;

  factory _DailyLogUpdate.fromJson(Map<String, dynamic> json) =
      _$DailyLogUpdateImpl.fromJson;

  @override
  double? get sleepHours;
  @override
  int? get sleepQuality;
  @override
  int? get moodScore;
  @override
  int? get dietQuality;
  @override
  int? get exerciseMinutes;
  @override
  String? get note;

  /// Create a copy of DailyLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyLogUpdateImplCopyWith<_$DailyLogUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) {
  return _ActivityLog.fromJson(json);
}

/// @nodoc
mixin _$ActivityLog {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this ActivityLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCopyWith<ActivityLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCopyWith<$Res> {
  factory $ActivityLogCopyWith(
    ActivityLog value,
    $Res Function(ActivityLog) then,
  ) = _$ActivityLogCopyWithImpl<$Res, ActivityLog>;
  @useResult
  $Res call({
    String id,
    DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class _$ActivityLogCopyWithImpl<$Res, $Val extends ActivityLog>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogImplCopyWith<$Res>
    implements $ActivityLogCopyWith<$Res> {
  factory _$$ActivityLogImplCopyWith(
    _$ActivityLogImpl value,
    $Res Function(_$ActivityLogImpl) then,
  ) = __$$ActivityLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class __$$ActivityLogImplCopyWithImpl<$Res>
    extends _$ActivityLogCopyWithImpl<$Res, _$ActivityLogImpl>
    implements _$$ActivityLogImplCopyWith<$Res> {
  __$$ActivityLogImplCopyWithImpl(
    _$ActivityLogImpl _value,
    $Res Function(_$ActivityLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _$ActivityLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogImpl implements _ActivityLog {
  const _$ActivityLogImpl({
    required this.id,
    required this.startTime,
    this.endTime,
    this.description,
    this.categoryId,
  });

  factory _$ActivityLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final String? description;
  @override
  final String? categoryId;

  @override
  String toString() {
    return 'ActivityLog(id: $id, startTime: $startTime, endTime: $endTime, description: $description, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, startTime, endTime, description, categoryId);

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      __$$ActivityLogImplCopyWithImpl<_$ActivityLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogImplToJson(this);
  }
}

abstract class _ActivityLog implements ActivityLog {
  const factory _ActivityLog({
    required final String id,
    required final DateTime startTime,
    final DateTime? endTime,
    final String? description,
    final String? categoryId,
  }) = _$ActivityLogImpl;

  factory _ActivityLog.fromJson(Map<String, dynamic> json) =
      _$ActivityLogImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  String? get description;
  @override
  String? get categoryId;

  /// Create a copy of ActivityLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogImplCopyWith<_$ActivityLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogCreate _$ActivityLogCreateFromJson(Map<String, dynamic> json) {
  return _ActivityLogCreate.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogCreate {
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogCreateCopyWith<ActivityLogCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogCreateCopyWith<$Res> {
  factory $ActivityLogCreateCopyWith(
    ActivityLogCreate value,
    $Res Function(ActivityLogCreate) then,
  ) = _$ActivityLogCreateCopyWithImpl<$Res, ActivityLogCreate>;
  @useResult
  $Res call({
    DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class _$ActivityLogCreateCopyWithImpl<$Res, $Val extends ActivityLogCreate>
    implements $ActivityLogCreateCopyWith<$Res> {
  _$ActivityLogCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _value.copyWith(
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogCreateImplCopyWith<$Res>
    implements $ActivityLogCreateCopyWith<$Res> {
  factory _$$ActivityLogCreateImplCopyWith(
    _$ActivityLogCreateImpl value,
    $Res Function(_$ActivityLogCreateImpl) then,
  ) = __$$ActivityLogCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class __$$ActivityLogCreateImplCopyWithImpl<$Res>
    extends _$ActivityLogCreateCopyWithImpl<$Res, _$ActivityLogCreateImpl>
    implements _$$ActivityLogCreateImplCopyWith<$Res> {
  __$$ActivityLogCreateImplCopyWithImpl(
    _$ActivityLogCreateImpl _value,
    $Res Function(_$ActivityLogCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _$ActivityLogCreateImpl(
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogCreateImpl implements _ActivityLogCreate {
  const _$ActivityLogCreateImpl({
    required this.startTime,
    this.endTime,
    this.description,
    this.categoryId,
  });

  factory _$ActivityLogCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogCreateImplFromJson(json);

  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  final String? description;
  @override
  final String? categoryId;

  @override
  String toString() {
    return 'ActivityLogCreate(startTime: $startTime, endTime: $endTime, description: $description, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogCreateImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startTime, endTime, description, categoryId);

  /// Create a copy of ActivityLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogCreateImplCopyWith<_$ActivityLogCreateImpl> get copyWith =>
      __$$ActivityLogCreateImplCopyWithImpl<_$ActivityLogCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogCreateImplToJson(this);
  }
}

abstract class _ActivityLogCreate implements ActivityLogCreate {
  const factory _ActivityLogCreate({
    required final DateTime startTime,
    final DateTime? endTime,
    final String? description,
    final String? categoryId,
  }) = _$ActivityLogCreateImpl;

  factory _ActivityLogCreate.fromJson(Map<String, dynamic> json) =
      _$ActivityLogCreateImpl.fromJson;

  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  String? get description;
  @override
  String? get categoryId;

  /// Create a copy of ActivityLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogCreateImplCopyWith<_$ActivityLogCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

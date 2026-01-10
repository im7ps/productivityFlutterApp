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

ActivityLogRead _$ActivityLogReadFromJson(Map<String, dynamic> json) {
  return _ActivityLogRead.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogRead {
  String get id => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogRead to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogReadCopyWith<ActivityLogRead> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogReadCopyWith<$Res> {
  factory $ActivityLogReadCopyWith(
    ActivityLogRead value,
    $Res Function(ActivityLogRead) then,
  ) = _$ActivityLogReadCopyWithImpl<$Res, ActivityLogRead>;
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
class _$ActivityLogReadCopyWithImpl<$Res, $Val extends ActivityLogRead>
    implements $ActivityLogReadCopyWith<$Res> {
  _$ActivityLogReadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogRead
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
abstract class _$$ActivityLogReadImplCopyWith<$Res>
    implements $ActivityLogReadCopyWith<$Res> {
  factory _$$ActivityLogReadImplCopyWith(
    _$ActivityLogReadImpl value,
    $Res Function(_$ActivityLogReadImpl) then,
  ) = __$$ActivityLogReadImplCopyWithImpl<$Res>;
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
class __$$ActivityLogReadImplCopyWithImpl<$Res>
    extends _$ActivityLogReadCopyWithImpl<$Res, _$ActivityLogReadImpl>
    implements _$$ActivityLogReadImplCopyWith<$Res> {
  __$$ActivityLogReadImplCopyWithImpl(
    _$ActivityLogReadImpl _value,
    $Res Function(_$ActivityLogReadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogRead
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
      _$ActivityLogReadImpl(
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
class _$ActivityLogReadImpl implements _ActivityLogRead {
  const _$ActivityLogReadImpl({
    required this.id,
    required this.startTime,
    this.endTime,
    this.description,
    this.categoryId,
  });

  factory _$ActivityLogReadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogReadImplFromJson(json);

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
    return 'ActivityLogRead(id: $id, startTime: $startTime, endTime: $endTime, description: $description, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogReadImpl &&
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

  /// Create a copy of ActivityLogRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogReadImplCopyWith<_$ActivityLogReadImpl> get copyWith =>
      __$$ActivityLogReadImplCopyWithImpl<_$ActivityLogReadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogReadImplToJson(this);
  }
}

abstract class _ActivityLogRead implements ActivityLogRead {
  const factory _ActivityLogRead({
    required final String id,
    required final DateTime startTime,
    final DateTime? endTime,
    final String? description,
    final String? categoryId,
  }) = _$ActivityLogReadImpl;

  factory _ActivityLogRead.fromJson(Map<String, dynamic> json) =
      _$ActivityLogReadImpl.fromJson;

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

  /// Create a copy of ActivityLogRead
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogReadImplCopyWith<_$ActivityLogReadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityLogUpdate _$ActivityLogUpdateFromJson(Map<String, dynamic> json) {
  return _ActivityLogUpdate.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogUpdate {
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogUpdateCopyWith<ActivityLogUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogUpdateCopyWith<$Res> {
  factory $ActivityLogUpdateCopyWith(
    ActivityLogUpdate value,
    $Res Function(ActivityLogUpdate) then,
  ) = _$ActivityLogUpdateCopyWithImpl<$Res, ActivityLogUpdate>;
  @useResult
  $Res call({
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class _$ActivityLogUpdateCopyWithImpl<$Res, $Val extends ActivityLogUpdate>
    implements $ActivityLogUpdateCopyWith<$Res> {
  _$ActivityLogUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _value.copyWith(
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$ActivityLogUpdateImplCopyWith<$Res>
    implements $ActivityLogUpdateCopyWith<$Res> {
  factory _$$ActivityLogUpdateImplCopyWith(
    _$ActivityLogUpdateImpl value,
    $Res Function(_$ActivityLogUpdateImpl) then,
  ) = __$$ActivityLogUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  });
}

/// @nodoc
class __$$ActivityLogUpdateImplCopyWithImpl<$Res>
    extends _$ActivityLogUpdateCopyWithImpl<$Res, _$ActivityLogUpdateImpl>
    implements _$$ActivityLogUpdateImplCopyWith<$Res> {
  __$$ActivityLogUpdateImplCopyWithImpl(
    _$ActivityLogUpdateImpl _value,
    $Res Function(_$ActivityLogUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? description = freezed,
    Object? categoryId = freezed,
  }) {
    return _then(
      _$ActivityLogUpdateImpl(
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$ActivityLogUpdateImpl implements _ActivityLogUpdate {
  const _$ActivityLogUpdateImpl({
    this.startTime,
    this.endTime,
    this.description,
    this.categoryId,
  });

  factory _$ActivityLogUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogUpdateImplFromJson(json);

  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final String? description;
  @override
  final String? categoryId;

  @override
  String toString() {
    return 'ActivityLogUpdate(startTime: $startTime, endTime: $endTime, description: $description, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogUpdateImpl &&
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

  /// Create a copy of ActivityLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogUpdateImplCopyWith<_$ActivityLogUpdateImpl> get copyWith =>
      __$$ActivityLogUpdateImplCopyWithImpl<_$ActivityLogUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogUpdateImplToJson(this);
  }
}

abstract class _ActivityLogUpdate implements ActivityLogUpdate {
  const factory _ActivityLogUpdate({
    final DateTime? startTime,
    final DateTime? endTime,
    final String? description,
    final String? categoryId,
  }) = _$ActivityLogUpdateImpl;

  factory _ActivityLogUpdate.fromJson(Map<String, dynamic> json) =
      _$ActivityLogUpdateImpl.fromJson;

  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  String? get description;
  @override
  String? get categoryId;

  /// Create a copy of ActivityLogUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogUpdateImplCopyWith<_$ActivityLogUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

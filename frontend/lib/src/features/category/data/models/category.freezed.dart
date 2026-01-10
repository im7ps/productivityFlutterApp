// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryCreate _$CategoryCreateFromJson(Map<String, dynamic> json) {
  return _CategoryCreate.fromJson(json);
}

/// @nodoc
mixin _$CategoryCreate {
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  /// Serializes this CategoryCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCreateCopyWith<CategoryCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCreateCopyWith<$Res> {
  factory $CategoryCreateCopyWith(
    CategoryCreate value,
    $Res Function(CategoryCreate) then,
  ) = _$CategoryCreateCopyWithImpl<$Res, CategoryCreate>;
  @useResult
  $Res call({String name, String icon, String color});
}

/// @nodoc
class _$CategoryCreateCopyWithImpl<$Res, $Val extends CategoryCreate>
    implements $CategoryCreateCopyWith<$Res> {
  _$CategoryCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? icon = null, Object? color = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryCreateImplCopyWith<$Res>
    implements $CategoryCreateCopyWith<$Res> {
  factory _$$CategoryCreateImplCopyWith(
    _$CategoryCreateImpl value,
    $Res Function(_$CategoryCreateImpl) then,
  ) = __$$CategoryCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String icon, String color});
}

/// @nodoc
class __$$CategoryCreateImplCopyWithImpl<$Res>
    extends _$CategoryCreateCopyWithImpl<$Res, _$CategoryCreateImpl>
    implements _$$CategoryCreateImplCopyWith<$Res> {
  __$$CategoryCreateImplCopyWithImpl(
    _$CategoryCreateImpl _value,
    $Res Function(_$CategoryCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? icon = null, Object? color = null}) {
    return _then(
      _$CategoryCreateImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryCreateImpl implements _CategoryCreate {
  const _$CategoryCreateImpl({
    required this.name,
    this.icon = 'circle',
    this.color = 'blue',
  });

  factory _$CategoryCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryCreateImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String color;

  @override
  String toString() {
    return 'CategoryCreate(name: $name, icon: $icon, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryCreateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, icon, color);

  /// Create a copy of CategoryCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryCreateImplCopyWith<_$CategoryCreateImpl> get copyWith =>
      __$$CategoryCreateImplCopyWithImpl<_$CategoryCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryCreateImplToJson(this);
  }
}

abstract class _CategoryCreate implements CategoryCreate {
  const factory _CategoryCreate({
    required final String name,
    final String icon,
    final String color,
  }) = _$CategoryCreateImpl;

  factory _CategoryCreate.fromJson(Map<String, dynamic> json) =
      _$CategoryCreateImpl.fromJson;

  @override
  String get name;
  @override
  String get icon;
  @override
  String get color;

  /// Create a copy of CategoryCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryCreateImplCopyWith<_$CategoryCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryRead _$CategoryReadFromJson(Map<String, dynamic> json) {
  return _CategoryRead.fromJson(json);
}

/// @nodoc
mixin _$CategoryRead {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  /// Serializes this CategoryRead to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryReadCopyWith<CategoryRead> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryReadCopyWith<$Res> {
  factory $CategoryReadCopyWith(
    CategoryRead value,
    $Res Function(CategoryRead) then,
  ) = _$CategoryReadCopyWithImpl<$Res, CategoryRead>;
  @useResult
  $Res call({String id, String name, String icon, String color});
}

/// @nodoc
class _$CategoryReadCopyWithImpl<$Res, $Val extends CategoryRead>
    implements $CategoryReadCopyWith<$Res> {
  _$CategoryReadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryReadImplCopyWith<$Res>
    implements $CategoryReadCopyWith<$Res> {
  factory _$$CategoryReadImplCopyWith(
    _$CategoryReadImpl value,
    $Res Function(_$CategoryReadImpl) then,
  ) = __$$CategoryReadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String icon, String color});
}

/// @nodoc
class __$$CategoryReadImplCopyWithImpl<$Res>
    extends _$CategoryReadCopyWithImpl<$Res, _$CategoryReadImpl>
    implements _$$CategoryReadImplCopyWith<$Res> {
  __$$CategoryReadImplCopyWithImpl(
    _$CategoryReadImpl _value,
    $Res Function(_$CategoryReadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? color = null,
  }) {
    return _then(
      _$CategoryReadImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryReadImpl implements _CategoryRead {
  const _$CategoryReadImpl({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory _$CategoryReadImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryReadImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String icon;
  @override
  final String color;

  @override
  String toString() {
    return 'CategoryRead(id: $id, name: $name, icon: $icon, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryReadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon, color);

  /// Create a copy of CategoryRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryReadImplCopyWith<_$CategoryReadImpl> get copyWith =>
      __$$CategoryReadImplCopyWithImpl<_$CategoryReadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryReadImplToJson(this);
  }
}

abstract class _CategoryRead implements CategoryRead {
  const factory _CategoryRead({
    required final String id,
    required final String name,
    required final String icon,
    required final String color,
  }) = _$CategoryReadImpl;

  factory _CategoryRead.fromJson(Map<String, dynamic> json) =
      _$CategoryReadImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  String get color;

  /// Create a copy of CategoryRead
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryReadImplCopyWith<_$CategoryReadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryUpdate _$CategoryUpdateFromJson(Map<String, dynamic> json) {
  return _CategoryUpdate.fromJson(json);
}

/// @nodoc
mixin _$CategoryUpdate {
  String? get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this CategoryUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryUpdateCopyWith<CategoryUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryUpdateCopyWith<$Res> {
  factory $CategoryUpdateCopyWith(
    CategoryUpdate value,
    $Res Function(CategoryUpdate) then,
  ) = _$CategoryUpdateCopyWithImpl<$Res, CategoryUpdate>;
  @useResult
  $Res call({String? name, String? icon, String? color});
}

/// @nodoc
class _$CategoryUpdateCopyWithImpl<$Res, $Val extends CategoryUpdate>
    implements $CategoryUpdateCopyWith<$Res> {
  _$CategoryUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? icon = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryUpdateImplCopyWith<$Res>
    implements $CategoryUpdateCopyWith<$Res> {
  factory _$$CategoryUpdateImplCopyWith(
    _$CategoryUpdateImpl value,
    $Res Function(_$CategoryUpdateImpl) then,
  ) = __$$CategoryUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? icon, String? color});
}

/// @nodoc
class __$$CategoryUpdateImplCopyWithImpl<$Res>
    extends _$CategoryUpdateCopyWithImpl<$Res, _$CategoryUpdateImpl>
    implements _$$CategoryUpdateImplCopyWith<$Res> {
  __$$CategoryUpdateImplCopyWithImpl(
    _$CategoryUpdateImpl _value,
    $Res Function(_$CategoryUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? icon = freezed,
    Object? color = freezed,
  }) {
    return _then(
      _$CategoryUpdateImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryUpdateImpl implements _CategoryUpdate {
  const _$CategoryUpdateImpl({this.name, this.icon, this.color});

  factory _$CategoryUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryUpdateImplFromJson(json);

  @override
  final String? name;
  @override
  final String? icon;
  @override
  final String? color;

  @override
  String toString() {
    return 'CategoryUpdate(name: $name, icon: $icon, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryUpdateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, icon, color);

  /// Create a copy of CategoryUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryUpdateImplCopyWith<_$CategoryUpdateImpl> get copyWith =>
      __$$CategoryUpdateImplCopyWithImpl<_$CategoryUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryUpdateImplToJson(this);
  }
}

abstract class _CategoryUpdate implements CategoryUpdate {
  const factory _CategoryUpdate({
    final String? name,
    final String? icon,
    final String? color,
  }) = _$CategoryUpdateImpl;

  factory _CategoryUpdate.fromJson(Map<String, dynamic> json) =
      _$CategoryUpdateImpl.fromJson;

  @override
  String? get name;
  @override
  String? get icon;
  @override
  String? get color;

  /// Create a copy of CategoryUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryUpdateImplCopyWith<_$CategoryUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

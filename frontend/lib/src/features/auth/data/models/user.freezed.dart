// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) {
  return _UserCreate.fromJson(json);
}

/// @nodoc
mixin _$UserCreate {
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this UserCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCreateCopyWith<UserCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCreateCopyWith<$Res> {
  factory $UserCreateCopyWith(
    UserCreate value,
    $Res Function(UserCreate) then,
  ) = _$UserCreateCopyWithImpl<$Res, UserCreate>;
  @useResult
  $Res call({String username, String email, String password});
}

/// @nodoc
class _$UserCreateCopyWithImpl<$Res, $Val extends UserCreate>
    implements $UserCreateCopyWith<$Res> {
  _$UserCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserCreateImplCopyWith<$Res>
    implements $UserCreateCopyWith<$Res> {
  factory _$$UserCreateImplCopyWith(
    _$UserCreateImpl value,
    $Res Function(_$UserCreateImpl) then,
  ) = __$$UserCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String email, String password});
}

/// @nodoc
class __$$UserCreateImplCopyWithImpl<$Res>
    extends _$UserCreateCopyWithImpl<$Res, _$UserCreateImpl>
    implements _$$UserCreateImplCopyWith<$Res> {
  __$$UserCreateImplCopyWithImpl(
    _$UserCreateImpl _value,
    $Res Function(_$UserCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _$UserCreateImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCreateImpl implements _UserCreate {
  const _$UserCreateImpl({
    required this.username,
    required this.email,
    required this.password,
  });

  factory _$UserCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCreateImplFromJson(json);

  @override
  final String username;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'UserCreate(username: $username, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCreateImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, email, password);

  /// Create a copy of UserCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCreateImplCopyWith<_$UserCreateImpl> get copyWith =>
      __$$UserCreateImplCopyWithImpl<_$UserCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCreateImplToJson(this);
  }
}

abstract class _UserCreate implements UserCreate {
  const factory _UserCreate({
    required final String username,
    required final String email,
    required final String password,
  }) = _$UserCreateImpl;

  factory _UserCreate.fromJson(Map<String, dynamic> json) =
      _$UserCreateImpl.fromJson;

  @override
  String get username;
  @override
  String get email;
  @override
  String get password;

  /// Create a copy of UserCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCreateImplCopyWith<_$UserCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPublic _$UserPublicFromJson(Map<String, dynamic> json) {
  return _UserPublic.fromJson(json);
}

/// @nodoc
mixin _$UserPublic {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserPublic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPublicCopyWith<UserPublic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPublicCopyWith<$Res> {
  factory $UserPublicCopyWith(
    UserPublic value,
    $Res Function(UserPublic) then,
  ) = _$UserPublicCopyWithImpl<$Res, UserPublic>;
  @useResult
  $Res call({String id, String username, String email, DateTime createdAt});
}

/// @nodoc
class _$UserPublicCopyWithImpl<$Res, $Val extends UserPublic>
    implements $UserPublicCopyWith<$Res> {
  _$UserPublicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPublicImplCopyWith<$Res>
    implements $UserPublicCopyWith<$Res> {
  factory _$$UserPublicImplCopyWith(
    _$UserPublicImpl value,
    $Res Function(_$UserPublicImpl) then,
  ) = __$$UserPublicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String username, String email, DateTime createdAt});
}

/// @nodoc
class __$$UserPublicImplCopyWithImpl<$Res>
    extends _$UserPublicCopyWithImpl<$Res, _$UserPublicImpl>
    implements _$$UserPublicImplCopyWith<$Res> {
  __$$UserPublicImplCopyWithImpl(
    _$UserPublicImpl _value,
    $Res Function(_$UserPublicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$UserPublicImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPublicImpl implements _UserPublic {
  const _$UserPublicImpl({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory _$UserPublicImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPublicImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String email;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserPublic(id: $id, username: $username, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPublicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, email, createdAt);

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPublicImplCopyWith<_$UserPublicImpl> get copyWith =>
      __$$UserPublicImplCopyWithImpl<_$UserPublicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPublicImplToJson(this);
  }
}

abstract class _UserPublic implements UserPublic {
  const factory _UserPublic({
    required final String id,
    required final String username,
    required final String email,
    required final DateTime createdAt,
  }) = _$UserPublicImpl;

  factory _UserPublic.fromJson(Map<String, dynamic> json) =
      _$UserPublicImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get email;
  @override
  DateTime get createdAt;

  /// Create a copy of UserPublic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPublicImplCopyWith<_$UserPublicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserCreate with _$UserCreate {
  const factory UserCreate({
    required String username,
    required String email,
    required String password,
  }) = _UserCreate;

  factory UserCreate.fromJson(Map<String, dynamic> json) => _$UserCreateFromJson(json);
}

@freezed
class UserPublic with _$UserPublic {
  const factory UserPublic({
    required String id,
    required String username,
    required String email,
    required DateTime createdAt,
  }) = _UserPublic;

  factory UserPublic.fromJson(Map<String, dynamic> json) => _$UserPublicFromJson(json);
}

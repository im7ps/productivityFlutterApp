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
    required bool isOnboardingCompleted,
    required int dailyReachedGoal,
    required int statStrength,
    required int statEndurance,
    required int statIntelligence,
    required int statFocus,
  }) = _UserPublic;

  factory UserPublic.fromJson(Map<String, dynamic> json) => _$UserPublicFromJson(json);
}

@freezed
class UserUpdate with _$UserUpdate {
  const factory UserUpdate({
    String? username,
    String? email,
    String? password,
    bool? isOnboardingCompleted,
    int? statStrength,
    int? statEndurance,
    int? statIntelligence,
    int? statFocus,
  }) = _UserUpdate;

  factory UserUpdate.fromJson(Map<String, dynamic> json) => _$UserUpdateFromJson(json);
}
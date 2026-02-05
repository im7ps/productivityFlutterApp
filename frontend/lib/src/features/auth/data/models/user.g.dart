// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCreateImpl _$$UserCreateImplFromJson(Map<String, dynamic> json) =>
    _$UserCreateImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$UserCreateImplToJson(_$UserCreateImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };

_$UserPublicImpl _$$UserPublicImplFromJson(Map<String, dynamic> json) =>
    _$UserPublicImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isOnboardingCompleted: json['is_onboarding_completed'] as bool,
      dailyReachedGoal: (json['daily_reached_goal'] as num).toInt(),
      statStrength: (json['stat_strength'] as num).toInt(),
      statEndurance: (json['stat_endurance'] as num).toInt(),
      statIntelligence: (json['stat_intelligence'] as num).toInt(),
      statFocus: (json['stat_focus'] as num).toInt(),
    );

Map<String, dynamic> _$$UserPublicImplToJson(_$UserPublicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'created_at': instance.createdAt.toIso8601String(),
      'is_onboarding_completed': instance.isOnboardingCompleted,
      'daily_reached_goal': instance.dailyReachedGoal,
      'stat_strength': instance.statStrength,
      'stat_endurance': instance.statEndurance,
      'stat_intelligence': instance.statIntelligence,
      'stat_focus': instance.statFocus,
    };

_$UserUpdateImpl _$$UserUpdateImplFromJson(Map<String, dynamic> json) =>
    _$UserUpdateImpl(
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      isOnboardingCompleted: json['is_onboarding_completed'] as bool?,
      statStrength: (json['stat_strength'] as num?)?.toInt(),
      statEndurance: (json['stat_endurance'] as num?)?.toInt(),
      statIntelligence: (json['stat_intelligence'] as num?)?.toInt(),
      statFocus: (json['stat_focus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserUpdateImplToJson(_$UserUpdateImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'is_onboarding_completed': instance.isOnboardingCompleted,
      'stat_strength': instance.statStrength,
      'stat_endurance': instance.statEndurance,
      'stat_intelligence': instance.statIntelligence,
      'stat_focus': instance.statFocus,
    };

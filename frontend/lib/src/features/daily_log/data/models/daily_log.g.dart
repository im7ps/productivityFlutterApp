// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyLogCreateImpl _$$DailyLogCreateImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogCreateImpl(
      day: json['day'] as String,
      sleepHours: (json['sleep_hours'] as num?)?.toDouble() ?? 0,
      sleepQuality: (json['sleep_quality'] as num?)?.toInt() ?? 5,
      moodScore: (json['mood_score'] as num?)?.toInt() ?? 5,
      dietQuality: (json['diet_quality'] as num?)?.toInt() ?? 5,
      exerciseMinutes: (json['exercise_minutes'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$DailyLogCreateImplToJson(
  _$DailyLogCreateImpl instance,
) => <String, dynamic>{
  'day': instance.day,
  'sleep_hours': instance.sleepHours,
  'sleep_quality': instance.sleepQuality,
  'mood_score': instance.moodScore,
  'diet_quality': instance.dietQuality,
  'exercise_minutes': instance.exerciseMinutes,
  'note': instance.note,
};

_$DailyLogReadImpl _$$DailyLogReadImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogReadImpl(
      id: json['id'] as String,
      day: json['day'] as String,
      sleepHours: (json['sleep_hours'] as num).toDouble(),
      sleepQuality: (json['sleep_quality'] as num).toInt(),
      moodScore: (json['mood_score'] as num).toInt(),
      dietQuality: (json['diet_quality'] as num).toInt(),
      exerciseMinutes: (json['exercise_minutes'] as num).toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$DailyLogReadImplToJson(_$DailyLogReadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'sleep_hours': instance.sleepHours,
      'sleep_quality': instance.sleepQuality,
      'mood_score': instance.moodScore,
      'diet_quality': instance.dietQuality,
      'exercise_minutes': instance.exerciseMinutes,
      'note': instance.note,
    };

_$DailyLogUpdateImpl _$$DailyLogUpdateImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogUpdateImpl(
      sleepHours: (json['sleep_hours'] as num?)?.toDouble(),
      sleepQuality: (json['sleep_quality'] as num?)?.toInt(),
      moodScore: (json['mood_score'] as num?)?.toInt(),
      dietQuality: (json['diet_quality'] as num?)?.toInt(),
      exerciseMinutes: (json['exercise_minutes'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$DailyLogUpdateImplToJson(
  _$DailyLogUpdateImpl instance,
) => <String, dynamic>{
  'sleep_hours': instance.sleepHours,
  'sleep_quality': instance.sleepQuality,
  'mood_score': instance.moodScore,
  'diet_quality': instance.dietQuality,
  'exercise_minutes': instance.exerciseMinutes,
  'note': instance.note,
};

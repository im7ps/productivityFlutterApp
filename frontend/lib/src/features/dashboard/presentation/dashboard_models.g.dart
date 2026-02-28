// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskUIModelImpl _$$TaskUIModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskUIModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: const IconDataConverter().fromJson(
        json['icon'] as Map<String, dynamic>,
      ),
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      isCompleted: json['is_completed'] as bool? ?? false,
      status: json['status'] as String? ?? "COMPLETED",
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      satisfaction: (json['satisfaction'] as num).toInt(),
      category: json['category'] as String,
    );

Map<String, dynamic> _$$TaskUIModelImplToJson(_$TaskUIModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': const IconDataConverter().toJson(instance.icon),
      'color': const ColorConverter().toJson(instance.color),
      'is_completed': instance.isCompleted,
      'status': instance.status,
      'duration_minutes': instance.durationMinutes,
      'difficulty': instance.difficulty,
      'satisfaction': instance.satisfaction,
      'category': instance.category,
    };

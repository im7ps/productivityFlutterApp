// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityLogImpl _$$ActivityLogImplFromJson(Map<String, dynamic> json) =>
    _$ActivityLogImpl(
      id: json['id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      description: json['description'] as String?,
      categoryId: json['category_id'] as String?,
    );

Map<String, dynamic> _$$ActivityLogImplToJson(_$ActivityLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'description': instance.description,
      'category_id': instance.categoryId,
    };

_$ActivityLogCreateImpl _$$ActivityLogCreateImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityLogCreateImpl(
  startTime: DateTime.parse(json['start_time'] as String),
  endTime: json['end_time'] == null
      ? null
      : DateTime.parse(json['end_time'] as String),
  description: json['description'] as String?,
  categoryId: json['category_id'] as String?,
);

Map<String, dynamic> _$$ActivityLogCreateImplToJson(
  _$ActivityLogCreateImpl instance,
) => <String, dynamic>{
  'start_time': instance.startTime.toIso8601String(),
  'end_time': instance.endTime?.toIso8601String(),
  'description': instance.description,
  'category_id': instance.categoryId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActionImpl _$$ActionImplFromJson(Map<String, dynamic> json) => _$ActionImpl(
  id: json['id'] as String,
  startTime: DateTime.parse(json['start_time'] as String),
  endTime: json['end_time'] == null
      ? null
      : DateTime.parse(json['end_time'] as String),
  description: json['description'] as String?,
  fulfillmentScore: (json['fulfillment_score'] as num).toInt(),
  userId: json['user_id'] as String,
  dimensionId: json['dimension_id'] as String,
  dimension: json['dimension'] == null
      ? null
      : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ActionImplToJson(_$ActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'description': instance.description,
      'fulfillment_score': instance.fulfillmentScore,
      'user_id': instance.userId,
      'dimension_id': instance.dimensionId,
      'dimension': instance.dimension?.toJson(),
    };

_$ActionCreateImpl _$$ActionCreateImplFromJson(Map<String, dynamic> json) =>
    _$ActionCreateImpl(
      description: json['description'] as String?,
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      dimensionId: json['dimension_id'] as String,
      fulfillmentScore: (json['fulfillment_score'] as num).toInt(),
    );

Map<String, dynamic> _$$ActionCreateImplToJson(_$ActionCreateImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'start_time': instance.startTime?.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'dimension_id': instance.dimensionId,
      'fulfillment_score': instance.fulfillmentScore,
    };

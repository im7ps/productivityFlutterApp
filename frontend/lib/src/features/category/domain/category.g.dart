// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      dimension: json['dimension'] as String? ?? 'mind',
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'dimension': instance.dimension,
    };

_$CategoryCreateImpl _$$CategoryCreateImplFromJson(Map<String, dynamic> json) =>
    _$CategoryCreateImpl(
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'circle',
      color: json['color'] as String? ?? 'blue',
      dimension: json['dimension'] as String? ?? 'mind',
    );

Map<String, dynamic> _$$CategoryCreateImplToJson(
  _$CategoryCreateImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
  'dimension': instance.dimension,
};

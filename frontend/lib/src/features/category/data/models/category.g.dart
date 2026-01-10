// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryCreateImpl _$$CategoryCreateImplFromJson(Map<String, dynamic> json) =>
    _$CategoryCreateImpl(
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'circle',
      color: json['color'] as String? ?? 'blue',
    );

Map<String, dynamic> _$$CategoryCreateImplToJson(
  _$CategoryCreateImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
};

_$CategoryReadImpl _$$CategoryReadImplFromJson(Map<String, dynamic> json) =>
    _$CategoryReadImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$$CategoryReadImplToJson(_$CategoryReadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
    };

_$CategoryUpdateImpl _$$CategoryUpdateImplFromJson(Map<String, dynamic> json) =>
    _$CategoryUpdateImpl(
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$CategoryUpdateImplToJson(
  _$CategoryUpdateImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'icon': instance.icon,
  'color': instance.color,
};

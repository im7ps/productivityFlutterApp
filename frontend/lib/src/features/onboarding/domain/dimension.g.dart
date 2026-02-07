// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dimension.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DimensionImpl _$$DimensionImplFromJson(Map<String, dynamic> json) =>
    _$DimensionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['icon_path'] as String,
    );

Map<String, dynamic> _$$DimensionImplToJson(_$DimensionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_path': instance.iconPath,
    };

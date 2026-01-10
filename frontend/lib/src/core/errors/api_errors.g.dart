// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationErrorImpl _$$ValidationErrorImplFromJson(
  Map<String, dynamic> json,
) => _$ValidationErrorImpl(
  loc: json['loc'] as List<dynamic>,
  msg: json['msg'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$$ValidationErrorImplToJson(
  _$ValidationErrorImpl instance,
) => <String, dynamic>{
  'loc': instance.loc,
  'msg': instance.msg,
  'type': instance.type,
};

_$HTTPValidationErrorImpl _$$HTTPValidationErrorImplFromJson(
  Map<String, dynamic> json,
) => _$HTTPValidationErrorImpl(
  detail: (json['detail'] as List<dynamic>)
      .map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$HTTPValidationErrorImplToJson(
  _$HTTPValidationErrorImpl instance,
) => <String, dynamic>{
  'detail': instance.detail.map((e) => e.toJson()).toList(),
};

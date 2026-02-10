import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

enum TaskSortOrder { recommended, effort, satisfaction }

@freezed
class TaskUIModel with _$TaskUIModel {
  const factory TaskUIModel({
    required String id,
    required String title,
    @IconDataConverter() required IconData icon,
    @ColorConverter() required Color color,
    @Default(false) bool isCompleted,
    required int difficulty,
    required int satisfaction,
    required String category,
  }) = _TaskUIModel;

  factory TaskUIModel.fromJson(Map<String, dynamic> json) =>
      _$TaskUIModelFromJson(json);
}

class IconDataConverter implements JsonConverter<IconData, Map<String, dynamic>> {
  const IconDataConverter();

  @override
  IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['iconCode'] as int,
      fontFamily: json['iconFamily'] as String?,
      fontPackage: json['iconPackage'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson(IconData icon) {
    return {
      'iconCode': icon.codePoint,
      'iconFamily': icon.fontFamily,
      'iconPackage': icon.fontPackage,
    };
  }
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  /// Creates a TaskUIModel from backend Action JSON, mapping category to icon/color
  factory TaskUIModel.fromActionJson(Map<String, dynamic> json) {
    final category = json['category'] as String? ?? 'Dovere';

    IconData icon;
    Color color;

    switch (category.toLowerCase()) {
      case 'passione':
        icon = FontAwesomeIcons.guitar;
        color = Colors.green;
        break;
      case 'energia':
        icon = FontAwesomeIcons.bolt;
        color = Colors.orange;
        break;
      case 'relazioni':
        icon = FontAwesomeIcons.peopleGroup;
        color = Colors.blue;
        break;
      case 'anima':
        icon = FontAwesomeIcons.heart;
        color = Colors.pink;
        break;
      case 'dovere':
      default:
        icon = FontAwesomeIcons.briefcase;
        color = Colors.red;
    }

    return TaskUIModel(
      id: json['id'] as String,
      title: json['description'] as String? ?? 'Senza Titolo',
      icon: icon,
      color: color,
      difficulty: json['difficulty'] as int? ?? 3,
      satisfaction: json['fulfillment_score'] as int? ?? 3,
      category: category,
      isCompleted: json['status'] == 'COMPLETED',
    );
  }
}

class IconDataConverter
    implements JsonConverter<IconData, Map<String, dynamic>> {
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
  //TODO: verificare cambio da colo.value a color.hashCode
  int toJson(Color color) => color.hashCode;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String icon,
    required String color,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class CategoryCreate with _$CategoryCreate {
  const factory CategoryCreate({
    required String name,
    @Default('circle') String icon,
    @Default('blue') String color,
  }) = _CategoryCreate;

  factory CategoryCreate.fromJson(Map<String, dynamic> json) => _$CategoryCreateFromJson(json);
}

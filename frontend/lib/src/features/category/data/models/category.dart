import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class CategoryCreate with _$CategoryCreate {
  const factory CategoryCreate({
    required String name,
    @Default('circle') String icon,
    @Default('blue') String color,
  }) = _CategoryCreate;

  factory CategoryCreate.fromJson(Map<String, dynamic> json) => _$CategoryCreateFromJson(json);
}

@freezed
class CategoryRead with _$CategoryRead {
  const factory CategoryRead({
    required String id,
    required String name,
    required String icon,
    required String color,
  }) = _CategoryRead;

  factory CategoryRead.fromJson(Map<String, dynamic> json) => _$CategoryReadFromJson(json);
}

@freezed
class CategoryUpdate with _$CategoryUpdate {
  const factory CategoryUpdate({
    String? name,
    String? icon,
    String? color,
  }) = _CategoryUpdate;

  factory CategoryUpdate.fromJson(Map<String, dynamic> json) => _$CategoryUpdateFromJson(json);
}

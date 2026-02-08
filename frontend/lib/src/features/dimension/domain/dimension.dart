import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimension.freezed.dart';
part 'dimension.g.dart';

@freezed
class Dimension with _$Dimension {
  const factory Dimension({
    required String id, // Slug: energy, clarity, etc.
    required String name,
    String? description,
  }) = _Dimension;

  factory Dimension.fromJson(Map<String, dynamic> json) => _$DimensionFromJson(json);
}

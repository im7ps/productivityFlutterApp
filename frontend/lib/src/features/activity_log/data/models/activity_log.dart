import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLogCreate with _$ActivityLogCreate {
  const factory ActivityLogCreate({
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  }) = _ActivityLogCreate;

  factory ActivityLogCreate.fromJson(Map<String, dynamic> json) => _$ActivityLogCreateFromJson(json);
}

@freezed
class ActivityLogRead with _$ActivityLogRead {
  const factory ActivityLogRead({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  }) = _ActivityLogRead;

  factory ActivityLogRead.fromJson(Map<String, dynamic> json) => _$ActivityLogReadFromJson(json);
}

@freezed
class ActivityLogUpdate with _$ActivityLogUpdate {
  const factory ActivityLogUpdate({
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  }) = _ActivityLogUpdate;

  factory ActivityLogUpdate.fromJson(Map<String, dynamic> json) => _$ActivityLogUpdateFromJson(json);
}

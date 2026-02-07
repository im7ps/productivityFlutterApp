import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required DateTime startTime,
    DateTime? endTime,
    String? description,
    String? categoryId,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);
}

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

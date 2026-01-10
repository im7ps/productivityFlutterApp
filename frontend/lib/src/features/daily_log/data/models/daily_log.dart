import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_log.freezed.dart';
part 'daily_log.g.dart';

@freezed
class DailyLogCreate with _$DailyLogCreate {
  const factory DailyLogCreate({
    required String day, // Format: YYYY-MM-DD
    @Default(0) double sleepHours,
    @Default(5) int sleepQuality,
    @Default(5) int moodScore,
    @Default(5) int dietQuality,
    @Default(0) int exerciseMinutes,
    String? note,
  }) = _DailyLogCreate;

  factory DailyLogCreate.fromJson(Map<String, dynamic> json) => _$DailyLogCreateFromJson(json);
}

@freezed
class DailyLogRead with _$DailyLogRead {
  const factory DailyLogRead({
    required String id,
    required String day,
    required double sleepHours,
    required int sleepQuality,
    required int moodScore,
    required int dietQuality,
    required int exerciseMinutes,
    String? note,
  }) = _DailyLogRead;

  factory DailyLogRead.fromJson(Map<String, dynamic> json) => _$DailyLogReadFromJson(json);
}

@freezed
class DailyLogUpdate with _$DailyLogUpdate {
  const factory DailyLogUpdate({
    double? sleepHours,
    int? sleepQuality,
    int? moodScore,
    int? dietQuality,
    int? exerciseMinutes,
    String? note,
  }) = _DailyLogUpdate;

  factory DailyLogUpdate.fromJson(Map<String, dynamic> json) => _$DailyLogUpdateFromJson(json);
}

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/failure.dart';
import '../../../core/networking/dio_provider.dart';
import '../domain/activity_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'activity_repository.g.dart';

@riverpod
ActivityRepository activityRepository(Ref ref) {
  return ActivityRepository(dio: ref.watch(dioProvider));
}

class ActivityRepository {
  final Dio _dio;

  ActivityRepository({required Dio dio}) : _dio = dio;

  TaskEither<Failure, List<ActivityLog>> fetchActivityLogs() {
    return TaskEither.tryCatch(
      () async {
        final response = await _dio.get('/api/v1/activity-logs');
        return (response.data as List)
            .map((e) => ActivityLog.fromJson(e))
            .toList();
      },
            (error, stackTrace) {
              if (error is DioException) {
                 return Failure.network(error.message ?? 'Network Error');
              }
              return Failure.unknown(error.toString());
            },    );
  }

  TaskEither<Failure, ActivityLog> createLog(ActivityLogCreate data) {
    return TaskEither.tryCatch(
      () async {
        final response = await _dio.post(
          '/api/v1/activity-logs',
          data: data.toJson(),
        );
        return ActivityLog.fromJson(response.data);
      },
            (error, stackTrace) {
              if (error is DioException) {
                 return Failure.network(error.message ?? 'Network Error');
              }
              return Failure.unknown(error.toString());
            },    );
  }
}

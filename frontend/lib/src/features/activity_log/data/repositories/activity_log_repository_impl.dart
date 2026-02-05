import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/networking/dio_provider.dart';
import '../../../../core/networking/api_request.dart';
import '../models/activity_log.dart';
import '../../domain/activity_log_repository.dart';

part 'activity_log_repository_impl.g.dart';

@riverpod
ActivityLogRepository activityLogRepository(Ref ref) {
  return ActivityLogRepositoryImpl(ref.watch(dioProvider));
}

class ActivityLogRepositoryImpl implements ActivityLogRepository {
  final Dio _dio;

  ActivityLogRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<ActivityLogRead>>> getActivityLogs() {
    return makeRequest(
      () => _dio.get('/api/v1/activity-logs'),
      (data) {
        final List<dynamic> list = data;
        return list.map((e) => ActivityLogRead.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, ActivityLogRead>> createActivityLog(ActivityLogCreate activityLog) {
    return makeRequest(
      () => _dio.post(
        '/api/v1/activity-logs',
        data: activityLog.toJson(),
      ),
      (data) => ActivityLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, ActivityLogRead>> getActivityLog(String id) {
    return makeRequest(
      () => _dio.get('/api/v1/activity-logs/$id'),
      (data) => ActivityLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, ActivityLogRead>> updateActivityLog({
    required String id,
    required ActivityLogUpdate activityLog,
  }) {
    return makeRequest(
      () => _dio.put(
        '/api/v1/activity-logs/$id',
        data: activityLog.toJson(),
      ),
      (data) => ActivityLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, void>> deleteActivityLog(String id) {
    return makeRequest(
      () => _dio.delete('/api/v1/activity-logs/$id'),
      (_) => null,
    );
  }
}

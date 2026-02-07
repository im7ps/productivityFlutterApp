import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/networking/dio_provider.dart';
import '../../../../core/networking/api_request.dart';
import '../models/daily_log.dart';
import '../../domain/daily_log_repository.dart';

part 'daily_log_repository_impl.g.dart';

@riverpod
DailyLogRepository dailyLogRepository(Ref ref) {
  return DailyLogRepositoryImpl(ref.watch(dioProvider));
}

class DailyLogRepositoryImpl implements DailyLogRepository {
  final Dio _dio;

  DailyLogRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<DailyLogRead>>> getDailyLogs() {
    return makeRequest(() => _dio.get('/api/v1/daily-logs'), (data) {
      final List<dynamic> list = data;
      return list.map((e) => DailyLogRead.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<Failure, DailyLogRead>> createDailyLog(
    DailyLogCreate dailyLog,
  ) {
    return makeRequest(
      () => _dio.post('/api/v1/daily-logs', data: dailyLog.toJson()),
      (data) => DailyLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, DailyLogRead>> getDailyLog(String id) {
    return makeRequest(
      () => _dio.get('/api/v1/daily-logs/$id'),
      (data) => DailyLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, DailyLogRead>> updateDailyLog({
    required String id,
    required DailyLogUpdate dailyLog,
  }) {
    return makeRequest(
      () => _dio.put('/api/v1/daily-logs/$id', data: dailyLog.toJson()),
      (data) => DailyLogRead.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, void>> deleteDailyLog(String id) {
    return makeRequest(() => _dio.delete('/api/v1/daily-logs/$id'), (_) => ());
  }
}

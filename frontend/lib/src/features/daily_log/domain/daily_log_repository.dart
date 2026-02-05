import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../data/models/daily_log.dart';

abstract class DailyLogRepository {
  Future<Either<Failure, List<DailyLogRead>>> getDailyLogs();
  Future<Either<Failure, DailyLogRead>> createDailyLog(DailyLogCreate dailyLog);
  Future<Either<Failure, DailyLogRead>> getDailyLog(String id);
  Future<Either<Failure, DailyLogRead>> updateDailyLog({
    required String id,
    required DailyLogUpdate dailyLog,
  });
  Future<Either<Failure, void>> deleteDailyLog(String id);
}

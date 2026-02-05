import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../data/models/activity_log.dart';

abstract class ActivityLogRepository {
  Future<Either<Failure, List<ActivityLogRead>>> getActivityLogs();
  Future<Either<Failure, ActivityLogRead>> createActivityLog(ActivityLogCreate activityLog);
  Future<Either<Failure, ActivityLogRead>> getActivityLog(String id);
  Future<Either<Failure, ActivityLogRead>> updateActivityLog({
    required String id,
    required ActivityLogUpdate activityLog,
  });
  Future<Either<Failure, void>> deleteActivityLog(String id);
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/activity_log.dart';
import '../data/repositories/activity_log_repository_impl.dart';

part 'activity_logs_provider.g.dart';

@riverpod
class ActivityLogsNotifier extends _$ActivityLogsNotifier {
  @override
  Future<List<ActivityLogRead>> build() async {
    final repository = ref.watch(activityLogRepositoryProvider);
    final result = await repository.getActivityLogs();
    
    return result.fold(
      (failure) => throw failure,
      (logs) => logs,
    );
  }

  Future<void> addLog(ActivityLogCreate log) async {
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<ActivityLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(activityLogRepositoryProvider);
    final result = await repository.createActivityLog(log);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<ActivityLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (newLog) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData([...currentList, newLog]);
      },
    );
  }

  Future<void> deleteLog(String id) async {
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<ActivityLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(activityLogRepositoryProvider);
    final result = await repository.deleteActivityLog(id);

    result.fold(
      (failure) {
         state = AsyncError(failure, StackTrace.current);
         if (previousState.hasValue) {
           state = AsyncError<List<ActivityLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (_) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.where((l) => l.id != id).toList());
      },
    );
  }

  Future<void> updateLog({required String id, required ActivityLogUpdate update}) async {
    final previousState = state;
    state = const AsyncLoading();
     if (previousState.hasValue) {
      state = AsyncLoading<List<ActivityLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(activityLogRepositoryProvider);
    final result = await repository.updateActivityLog(id: id, activityLog: update);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<ActivityLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (updatedLog) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.map((l) => l.id == id ? updatedLog : l).toList());
      },
    );
  }
}

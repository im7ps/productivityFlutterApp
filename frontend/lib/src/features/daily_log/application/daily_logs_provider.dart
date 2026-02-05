import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/daily_log.dart';
import '../data/repositories/daily_log_repository_impl.dart';

part 'daily_logs_provider.g.dart';

@riverpod
class DailyLogsNotifier extends _$DailyLogsNotifier {
  @override
  Future<List<DailyLogRead>> build() async {
    final repository = ref.watch(dailyLogRepositoryProvider);
    final result = await repository.getDailyLogs();
    
    return result.fold(
      (failure) => throw failure, // Riverpod catches this and sets AsyncError
      (logs) => logs,
    );
  }

  Future<void> addLog(DailyLogCreate log) async {
    // Optimistically set loading state while keeping previous data
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<DailyLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(dailyLogRepositoryProvider);
    final result = await repository.createDailyLog(log);

    result.fold(
      (failure) {
        // Revert to previous state with error
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<DailyLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (newLog) {
        final currentList = previousState.valueOrNull ?? [];
        // Add new log and sort? Or just append. 
        // Assuming backend returns sorted or we don't care about order for now.
        // Usually daily logs are by date. Let's prepend or append.
        state = AsyncData([...currentList, newLog]);
      },
    );
  }

  Future<void> deleteLog(String id) async {
    final previousState = state;
    state = const AsyncLoading();
    if (previousState.hasValue) {
      state = AsyncLoading<List<DailyLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(dailyLogRepositoryProvider);
    final result = await repository.deleteDailyLog(id);

    result.fold(
      (failure) {
         state = AsyncError(failure, StackTrace.current);
         if (previousState.hasValue) {
           state = AsyncError<List<DailyLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (_) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.where((l) => l.id != id).toList());
      },
    );
  }

  Future<void> updateLog({required String id, required DailyLogUpdate update}) async {
    final previousState = state;
    state = const AsyncLoading();
     if (previousState.hasValue) {
      state = AsyncLoading<List<DailyLogRead>>().copyWithPrevious(previousState);
    }

    final repository = ref.read(dailyLogRepositoryProvider);
    final result = await repository.updateDailyLog(id: id, dailyLog: update);

    result.fold(
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        if (previousState.hasValue) {
           state = AsyncError<List<DailyLogRead>>(failure, StackTrace.current).copyWithPrevious(previousState);
        }
      },
      (updatedLog) {
        final currentList = previousState.valueOrNull ?? [];
        state = AsyncData(currentList.map((l) => l.id == id ? updatedLog : l).toList());
      },
    );
  }
}

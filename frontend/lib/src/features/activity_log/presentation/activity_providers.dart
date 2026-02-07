import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/activity_log.dart';
import '../data/activity_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'activity_providers.g.dart';

@riverpod
Future<List<ActivityLog>> activityLogList(Ref ref) async {
  final repository = ref.watch(activityRepositoryProvider);
  final result = await repository.fetchActivityLogs().run();

  return result.fold(
    (failure) => throw Exception(failure.displayMessage),
    (logs) => logs,
  );
}

@riverpod
class ActivityCreateController extends _$ActivityCreateController {
  @override
  FutureOr<void> build() {
    // Initial state is idle (AsyncData(null))
  }

  Future<bool> createActivity({
    required DateTime startTime,
    String? description,
    String? categoryId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(activityRepositoryProvider);

    final dto = ActivityLogCreate(
      startTime: startTime,
      description: description,
      categoryId: categoryId,
    );

    final result = await repository.createLog(dto).run();

    return result.fold(
      (failure) {
        state = AsyncError(failure.displayMessage, StackTrace.current);
        return false;
      },
      (success) {
        state = const AsyncData(null);
        // Invalida la lista per forzare il refresh
        ref.invalidate(activityLogListProvider);
        return true;
      },
    );
  }
}

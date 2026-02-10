import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../action/data/action_repository.dart';
import '../../action/domain/action.dart';
import '../../../core/storage/local_storage_service.dart';
import 'dashboard_models.dart';

export 'dashboard_models.dart';

part 'dashboard_providers.g.dart';

@riverpod
class TaskSort extends _$TaskSort {
  @override
  TaskSortOrder build() => TaskSortOrder.recommended;

  void setSortOrder(TaskSortOrder order) => state = order;
}

@riverpod
class TaskList extends _$TaskList {
  @override
  Future<List<TaskUIModel>> build() async {
    final storage = ref.watch(localStorageServiceProvider);
    return await storage.loadTasks();
  }

  Future<void> _save(List<TaskUIModel> newState) async {
    state = AsyncValue.data(newState);
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveTasks(newState);
  }

  Future<void> toggleCompletion(String id) async {
    final currentTasks = state.valueOrNull ?? [];
    final newState = [
      for (final task in currentTasks)
        if (task.id == id)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
    await _save(newState);
  }

  Future<void> addTasks(List<TaskUIModel> newTasks) async {
    final currentTasks = state.valueOrNull ?? [];
    final tasksWithIds = newTasks
        .map(
          (t) => t.id.isEmpty
              ? t.copyWith(id: DateTime.now().microsecondsSinceEpoch.toString())
              : t,
        )
        .toList();

    final newState = [...currentTasks, ...tasksWithIds];
    await _save(newState);
  }

  Future<void> updateTask(TaskUIModel updatedTask) async {
    final currentTasks = state.valueOrNull ?? [];
    final newState = [
      for (final task in currentTasks)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
    await _save(newState);
  }

  Future<void> concludeCheckpoint() async {
    final repo = ref.read(actionRepositoryProvider);
    final storage = ref.read(localStorageServiceProvider);
    final currentTasks = state.valueOrNull ?? [];

    try {
      for (final task in currentTasks) {
        final status = task.isCompleted ? "COMPLETED" : "FAILED";

        await repo.createAction(
          ActionCreate(
            description: task.title,
            category: task.category,
            difficulty: task.difficulty,
            fulfillmentScore: task.satisfaction,
            dimensionId: _mapCategoryToDimensionId(task.category),
            startTime: DateTime.now(),
            status: status,
          ),
        );
      }

      await storage.clearTasks();
      state = const AsyncValue.data([]);
    } catch (e) {
      debugPrint("Errore durante Sync Checkpoint: $e");
      rethrow;
    }
  }

  String _mapCategoryToDimensionId(String category) {
    switch (category.toLowerCase()) {
      case 'passione':
        return 'passion';
      case 'dovere':
        return 'duties';
      case 'energia':
        return 'energy';
      case 'anima':
        return 'soul';
      case 'relazioni':
        return 'relationships';
      default:
        return 'duties';
    }
  }
}

@riverpod
List<TaskUIModel> filteredTasks(FilteredTasksRef ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final sort = ref.watch(taskSortProvider);

  return tasksAsync.when(
    data: (tasks) {
      List<TaskUIModel> sortedList = List.from(tasks);
      switch (sort) {
        case TaskSortOrder.effort:
          sortedList.sort((a, b) => b.difficulty.compareTo(a.difficulty));
          break;
        case TaskSortOrder.satisfaction:
          sortedList.sort((a, b) => b.satisfaction.compareTo(a.satisfaction));
          break;
        case TaskSortOrder.recommended:
          break;
      }
      return sortedList;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
double rank(RankRef ref) {
  final tasksAsync = ref.watch(taskListProvider);
  return tasksAsync.maybeWhen(
    data: (tasks) {
      if (tasks.isEmpty) return 0.0;
      final completed = tasks.where((t) => t.isCompleted).length;
      return (completed * 0.25).clamp(0.0, 1.0);
    },
    orElse: () => 0.0,
  );
}

@riverpod
String rankLabel(RankLabelRef ref) {
  final score = ref.watch(rankProvider);
  if (score >= 1.0) return "GOD";
  if (score >= 0.75) return "S";
  if (score >= 0.50) return "A";
  if (score >= 0.25) return "B";
  return "C";
}

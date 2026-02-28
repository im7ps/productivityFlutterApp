import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
class CurrentCategory extends _$CurrentCategory {
  @override
  int build() => 0; // Index 0 is 'Generali'

  void setIndex(int index) => state = index;
}

@riverpod
class CategoryOrder extends _$CategoryOrder {
  @override
  Future<List<String>> build() async {
    final storage = ref.watch(localStorageServiceProvider);
    return await storage.loadCategoryOrder();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final currentOrder = state.valueOrNull ?? [];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<String> newList = List.from(currentOrder);
    final String item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
    
    state = AsyncValue.data(newList);
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveCategoryOrder(newList);
  }

  Future<void> updateOrder(List<String> newOrder) async {
    state = AsyncValue.data(newOrder);
    final storage = ref.read(localStorageServiceProvider);
    await storage.saveCategoryOrder(newOrder);
  }
}

@riverpod
List<CategoryInfo> availableCategories(Ref ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final tasks = tasksAsync.valueOrNull ?? [];
  final customOrderAsync = ref.watch(categoryOrderProvider);
  final customOrder = customOrderAsync.valueOrNull ?? [];

  // Map to store unique categories found in tasks
  final Map<String, CategoryInfo> foundCategories = {
    'general': const CategoryInfo(
      id: 'general',
      label: 'GENERALI',
      icon: Icons.dashboard_rounded,
      color: Colors.white,
    ),
  };

  for (final task in tasks) {
    final catId = task.category.toLowerCase();
    if (!foundCategories.containsKey(catId)) {
      foundCategories[catId] = CategoryInfo(
        id: catId,
        label: task.category.toUpperCase(),
        icon: task.icon,
        color: task.color,
      );
    }
  }

  final List<CategoryInfo> orderedCategories = [];
  
  // 1. Always start with General
  if (foundCategories.containsKey('general')) {
    orderedCategories.add(foundCategories['general']!);
  }

  // 2. Add categories from custom order if they exist in current tasks
  for (final catId in customOrder) {
    if (catId != 'general' && foundCategories.containsKey(catId)) {
      orderedCategories.add(foundCategories[catId]!);
    }
  }

  // 3. Add any remaining categories not in custom order
  final remainingCats = foundCategories.keys.where(
    (id) => id != 'general' && !customOrder.contains(id),
  ).toList()..sort();

  for (final catId in remainingCats) {
    orderedCategories.add(foundCategories[catId]!);
  }

  return orderedCategories;
}

@riverpod
class TaskList extends _$TaskList {
  @override
  Future<List<TaskUIModel>> build() async {
    final storage = ref.watch(localStorageServiceProvider);
    final localTasks = await storage.loadTasks();
    
    // Al caricamento, proviamo a sincronizzare con il backend per recuperare task create via chat
    // Usiamo microtask per non bloccare il build
    Future.microtask(() => syncWithBackend());
    
    return localTasks;
  }

  Future<void> syncWithBackend() async {
    final repo = ref.read(actionRepositoryProvider);
    final currentTasks = state.valueOrNull ?? [];
    
    debugPrint("DEBUG: TaskList.syncWithBackend - START");
    debugPrint("DEBUG: TaskList.syncWithBackend - Local tasks count: ${currentTasks.length}");

    try {
      final remoteActions = await repo.getUserActions(limit: 20);
      debugPrint("DEBUG: TaskList.syncWithBackend - Received ${remoteActions.length} actions from backend");
      
      final List<TaskUIModel> updatedList = List.from(currentTasks);
      bool changed = false;

      for (final action in remoteActions) {
        debugPrint("DEBUG: TaskList.syncWithBackend - Inspecting Remote Action: '${action.description}' [Status: ${action.status}, ID: ${action.id}]");
        
        if (action.status == "IN_PROGRESS") {
          final alreadyExists = updatedList.any((t) {
            final idMatch = t.id == action.id;
            final descMatch = t.title.toLowerCase() == (action.description ?? "").toLowerCase() && t.status == "IN_PROGRESS";
            return idMatch || descMatch;
          });
          
          if (!alreadyExists) {
            debugPrint("DEBUG: TaskList.syncWithBackend - !! ADDING NEW TASK TO DASHBOARD: ${action.description}");
            updatedList.add(TaskUIModel.fromActionJson({
              'id': action.id,
              'description': action.description,
              'category': action.category,
              'difficulty': action.difficulty,
              'fulfillment_score': action.fulfillmentScore,
              'status': action.status,
              'duration_minutes': action.durationMinutes,
            }));
            changed = true;
          } else {
            debugPrint("DEBUG: TaskList.syncWithBackend - Task already exists in local list, skipping.");
          }
        }
      }

      if (changed) {
        debugPrint("DEBUG: TaskList.syncWithBackend - UPDATING STATE AND STORAGE. New count: ${updatedList.length}");
        await _save(updatedList);
      } else {
        debugPrint("DEBUG: TaskList.syncWithBackend - NO CHANGES APPLIED.");
      }
    } catch (e) {
      debugPrint("DEBUG: TaskList.syncWithBackend - CRITICAL ERROR: $e");
    }
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
        return 'passione';
      case 'dovere':
        return 'dovere';
      case 'energia':
        return 'energia';
      case 'anima':
        return 'anima';
      case 'relazioni':
        return 'relazioni';
      default:
        return 'dovere';
    }
  }
}

@riverpod
List<TaskUIModel> tasksByCategory(Ref ref, String categoryId) {
  final tasksAsync = ref.watch(taskListProvider);
  final sort = ref.watch(taskSortProvider);

  return tasksAsync.when(
    data: (tasks) {
      Iterable<TaskUIModel> filtered = tasks;
      if (categoryId != 'general') {
        filtered = tasks.where(
          (t) => t.category.toLowerCase() == categoryId,
        );
      }

      List<TaskUIModel> sortedList = List.from(filtered);
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
double rankByCategory(Ref ref, String categoryId) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.maybeWhen(
    data: (tasks) {
      Iterable<TaskUIModel> relevantTasks = tasks;
      if (categoryId != 'general') {
        relevantTasks = tasks.where(
          (t) => t.category.toLowerCase() == categoryId,
        );
      }

      if (relevantTasks.isEmpty) return 0.0;
      final completed = relevantTasks.where((t) => t.isCompleted).length;

      return (completed * 0.25).clamp(0.0, 1.0);
    },
    orElse: () => 0.0,
  );
}

@riverpod
String rankLabelByCategory(Ref ref, String categoryId) {
  final score = ref.watch(rankByCategoryProvider(categoryId));
  if (score >= 1.0) return "GOD";
  if (score >= 0.75) return "S";
  if (score >= 0.50) return "A";
  if (score >= 0.25) return "B";
  return "C";
}

@riverpod
List<TaskUIModel> filteredTasks(Ref ref) {
  final categories = ref.watch(availableCategoriesProvider);
  final currentCatIndex = ref.watch(currentCategoryProvider);

  if (currentCatIndex >= categories.length) return [];
  final currentCat = categories[currentCatIndex];

  return ref.watch(tasksByCategoryProvider(currentCat.id));
}

@riverpod
double rank(Ref ref) {
  final categories = ref.watch(availableCategoriesProvider);
  final currentCatIndex = ref.watch(currentCategoryProvider);

  if (currentCatIndex >= categories.length) return 0.0;
  final currentCat = categories[currentCatIndex];

  return ref.watch(rankByCategoryProvider(currentCat.id));
}

@riverpod
String rankLabel(Ref ref) {
  final categories = ref.watch(availableCategoriesProvider);
  final currentCatIndex = ref.watch(currentCategoryProvider);

  if (currentCatIndex >= categories.length) return "C";
  final currentCat = categories[currentCatIndex];

  return ref.watch(rankLabelByCategoryProvider(currentCat.id));
}


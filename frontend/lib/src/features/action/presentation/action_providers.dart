import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart'; // Required for Color
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Required for FontAwesomeIcons
import 'package:whativedone/src/features/dashboard/presentation/dashboard_models.dart'; // Required for TaskUIModel
import '../data/action_repository.dart';
import '../domain/action.dart' as domain_action; // Alias for domain Action

part 'action_providers.g.dart';

@riverpod
Future<List<domain_action.Action>> actionList(Ref ref) async {
  final repo = ref.watch(actionRepositoryProvider);
  final actions = await repo.getActions();
  return actions;
}

@riverpod
class ActionCreateController extends _$ActionCreateController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<domain_action.Action?> createAction({
    required String dimensionId,
    required int fulfillmentScore,
    String? description,
    DateTime? startTime,
  }) async {
    final repo = ref.read(actionRepositoryProvider);
    state = const AsyncValue.loading();

    final actionIn = domain_action.ActionCreate(
      dimensionId: dimensionId,
      fulfillmentScore: fulfillmentScore,
      description: description,
      startTime: startTime,
    );

    final result = await AsyncValue.guard(() => repo.createAction(actionIn));
    state = result;

    if (!state.hasError && result.value != null) {
      ref.invalidate(actionListProvider);
      return result.value;
    }
    return null;
  }

  Future<void> deleteAction(String actionId) async {
    final repo = ref.read(actionRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.deleteAction(actionId));
    if (!state.hasError) {
      ref.invalidate(actionListProvider);
    }
  }
}

// Hardcoded initial data from portfolio_screen.dart
final _initialAllTasks = [
  TaskUIModel(
      id: '1',
      title: "Suonare Chitarra",
      category: "Passione",
      difficulty: 2,
      satisfaction: 4,
      icon: FontAwesomeIcons.guitar,
      color: Colors.green),
  TaskUIModel(
      id: '2',
      title: "Pulire Scrivania",
      category: "Dovere",
      difficulty: 3,
      satisfaction: 3,
      icon: FontAwesomeIcons.broom,
      color: Colors.red),
  TaskUIModel(
      id: '3',
      title: "Corsa 5km",
      category: "Energia",
      difficulty: 5,
      satisfaction: 4,
      icon: FontAwesomeIcons.personRunning,
      color: Colors.orange),
  TaskUIModel(
      id: '4',
      title: "Meditazione",
      category: "Energia",
      difficulty: 1,
      satisfaction: 4,
      icon: FontAwesomeIcons.brain,
      color: Colors.orange),
  TaskUIModel(
      id: '5',
      title: "Pagare Bollette",
      category: "Dovere",
      difficulty: 2,
      satisfaction: 2,
      icon: FontAwesomeIcons.fileInvoiceDollar,
      color: Colors.red),
  TaskUIModel(
      id: '6',
      title: "Chiamata Amico",
      category: "Relazioni",
      difficulty: 1,
      satisfaction: 4,
      icon: FontAwesomeIcons.phone,
      color: Colors.blue),
];

class AllTasksNotifier extends StateNotifier<List<TaskUIModel>> {
  AllTasksNotifier() : super(_initialAllTasks);

  void addTask(TaskUIModel task) {
    state = [...state, task];
  }

  void removeTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  void updateTask(TaskUIModel updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  // Add more methods here for remove, edit, etc., as needed later
}

final allTasksProvider =
    StateNotifierProvider<AllTasksNotifier, List<TaskUIModel>>(
  (ref) => AllTasksNotifier(),
);

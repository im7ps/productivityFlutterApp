import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TaskSortOrder { recommended, effort, satisfaction }

class TaskUIModel {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final int difficulty; 
  final int satisfaction; 
  final String category;

  TaskUIModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.isCompleted = false,
    required this.difficulty,
    required this.satisfaction,
    required this.category,
  });

  TaskUIModel copyWith({bool? isCompleted}) {
    return TaskUIModel(
      id: id,
      title: title,
      icon: icon,
      color: color,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty,
      satisfaction: satisfaction,
      category: category,
    );
  }
}

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<TaskUIModel>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<TaskUIModel>> {
  TaskListNotifier() : super([
    TaskUIModel(id: '1', title: 'Allenamento', icon: FontAwesomeIcons.bolt, color: Colors.orange, isCompleted: true, difficulty: 4, satisfaction: 5, category: 'Energia'),
    TaskUIModel(id: '2', title: 'Chitarra', icon: FontAwesomeIcons.guitar, color: Colors.purple, isCompleted: false, difficulty: 2, satisfaction: 5, category: 'Passione'),
    TaskUIModel(id: '3', title: 'Lettura', icon: FontAwesomeIcons.bookOpen, color: Colors.blue, isCompleted: false, difficulty: 1, satisfaction: 3, category: 'Dovere'),
  ]);

  void toggleCompletion(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isCompleted: !task.isCompleted) else task
    ];
  }

  void addTasks(List<TaskUIModel> newTasks) {
    state = [...state, ...newTasks];
  }
}

// Provider per l'ordinamento
final taskSortProvider = StateProvider<TaskSortOrder>((ref) => TaskSortOrder.recommended);

// Provider filtrato
final filteredTasksProvider = Provider<List<TaskUIModel>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final sort = ref.watch(taskSortProvider);

  List<TaskUIModel> sortedList = List.from(tasks);
  switch (sort) {
    case TaskSortOrder.effort:
      sortedList.sort((a, b) => b.difficulty.compareTo(a.difficulty));
      break;
    case TaskSortOrder.satisfaction:
      sortedList.sort((a, b) => b.satisfaction.compareTo(a.satisfaction));
      break;
    case TaskSortOrder.recommended:
      // Mantieni ordine di inserimento o logica custom
      break;
  }
  return sortedList;
});

final rankProvider = Provider<double>((ref) {
  final tasks = ref.watch(taskListProvider);
  if (tasks.isEmpty) return 0.0;
  final completed = tasks.where((t) => t.isCompleted).length;
  return (completed * 0.25).clamp(0.0, 1.0); 
});

final rankLabelProvider = Provider<String>((ref) {
  final score = ref.watch(rankProvider);
  if (score >= 1.0) return "S+";
  if (score >= 0.75) return "A";
  if (score >= 0.50) return "B";
  if (score >= 0.25) return "C";
  return "D";
});

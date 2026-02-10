import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/dashboard/presentation/dashboard_models.dart';

part 'local_storage_service.g.dart';

@riverpod
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService();
}

class LocalStorageService {
  static const String _tasksKey = 'day0_tasks_v1';
  static const String _lastCheckpointKey = 'day0_last_checkpoint';

  Future<List<TaskUIModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_tasksKey);
    
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => TaskUIModel.fromJson(json)).toList();
    } catch (e) {
      print("Error loading local tasks: $e");
      return [];
    }
  }

  Future<void> saveTasks(List<TaskUIModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, jsonString);
  }

  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}

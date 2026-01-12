import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../src/core/storage/storage_provider.dart';
import '../domain/quiz_model.dart';
import '../domain/quiz_state.dart';

part 'quiz_controller.g.dart';

@riverpod
class QuizController extends _$QuizController {
  
  @override
  FutureOr<QuizState> build() async {
    // 1. Recupera l'istanza di SharedPreferences
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    
    // 2. Tenta di recuperare lo stato salvato
    final savedIndex = prefs.getInt(StorageKeys.quizIndex);
    final savedStatsString = prefs.getString(StorageKeys.quizStats);

    if (savedIndex != null && savedStatsString != null) {
      try {
        final Map<String, dynamic> statsMap = jsonDecode(savedStatsString);
        // Cast sicuro: jsonDecode ritorna dynamic, dobbiamo assicurarci che siano int
        final Map<String, int> typedStats = statsMap.map((key, value) => MapEntry(key, value as int));
        
        return QuizState(
          currentQuestionIndex: savedIndex,
          accumulatedStats: typedStats,
        );
      } catch (e) {
        // Se il parsing fallisce, resetta
        return const QuizState();
      }
    }

    return const QuizState();
  }

  Future<void> answerQuestion(QuizAnswer answer, int totalQuestions) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Calcola nuove stats
    final newStats = Map<String, int>.from(currentState.accumulatedStats);
    answer.statModifiers.forEach((key, value) {
      newStats[key] = (newStats[key] ?? 10) + value;
    });

    final nextIndex = currentState.currentQuestionIndex + 1;
    final isFinished = nextIndex >= totalQuestions;

    // Aggiorna lo stato in memoria
    final newState = currentState.copyWith(
      currentQuestionIndex: isFinished ? currentState.currentQuestionIndex : nextIndex,
      accumulatedStats: newStats,
      isFinished: isFinished,
    );
    
    state = AsyncData(newState);

    // Salva su disco (Fire and forget, ma meglio se await se vogliamo certezza)
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setInt(StorageKeys.quizIndex, newState.currentQuestionIndex);
    await prefs.setString(StorageKeys.quizStats, jsonEncode(newState.accumulatedStats));
  }

  Future<void> clearProgress() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(StorageKeys.quizIndex);
    await prefs.remove(StorageKeys.quizStats);
    state = const AsyncData(QuizState());
  }
}

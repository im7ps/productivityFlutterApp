import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/quiz_model.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

part 'onboarding_providers.g.dart';

// 1. Fetch Quiz Configuration
@riverpod
Future<QuizManifest> quizManifest(QuizManifestRef ref) async {
  final repo = ref.watch(onboardingRepositoryProvider);
  final result = await repo.getQuizManifest();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (manifest) => manifest,
  );
}

// 2. Manage User Answers
@riverpod
class OnboardingAnswers extends _$OnboardingAnswers {
  @override
  Map<String, int> build() {
    return {};
  }

  void selectAnswer(String questionId, int value) {
    state = {...state, questionId: value};
  }

  int? getAnswer(String questionId) => state[questionId];
}

// 3. Manage Submission Side-Effect
@riverpod
class OnboardingSubmitController extends _$OnboardingSubmitController {
  @override
  FutureOr<OnboardingResult?> build() {
    return null; // Initial state: no result yet
  }

  Future<bool> submit() async {
    state = const AsyncLoading();
    
    final answersMap = ref.read(onboardingAnswersProvider);
    // Convert Map to List<QuizAnswer>
    final answersList = answersMap.entries
        .map((e) => QuizAnswer(questionId: e.key, selectedValue: e.value))
        .toList();
    
    final submission = QuizSubmission(answers: answersList);
    
    final repo = ref.read(onboardingRepositoryProvider);
    final result = await repo.submitQuiz(submission);
    
    return result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (successResult) {
        state = AsyncData(successResult);
        return true;
      },
    );
  }
}

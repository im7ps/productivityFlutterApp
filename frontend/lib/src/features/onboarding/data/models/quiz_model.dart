import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

@freezed
class QuizOption with _$QuizOption {
  const factory QuizOption({
    required int value,
    required String label,
    String? description,
  }) = _QuizOption;

  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String text,
    required List<QuizOption> options,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
class QuizCategory with _$QuizCategory {
  const factory QuizCategory({
    required String id,
    required String title,
    required String description,
    required List<QuizQuestion> questions,
  }) = _QuizCategory;

  factory QuizCategory.fromJson(Map<String, dynamic> json) =>
      _$QuizCategoryFromJson(json);
}

@freezed
class QuizManifest with _$QuizManifest {
  const factory QuizManifest({
    required List<QuizCategory> categories,
  }) = _QuizManifest;

  factory QuizManifest.fromJson(Map<String, dynamic> json) =>
      _$QuizManifestFromJson(json);
}

// --- SUBMISSION ---

@freezed
class QuizAnswer with _$QuizAnswer {
  const factory QuizAnswer({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'selected_value') required int selectedValue,
  }) = _QuizAnswer;

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}

@freezed
class QuizSubmission with _$QuizSubmission {
  const factory QuizSubmission({
    required List<QuizAnswer> answers,
  }) = _QuizSubmission;

  factory QuizSubmission.fromJson(Map<String, dynamic> json) =>
      _$QuizSubmissionFromJson(json);
}

// --- RESULT ---

@freezed
class OnboardingResult with _$OnboardingResult {
  const factory OnboardingResult({
    // User object might be complex, simplified for now as Map or we reuse User model if available.
    // Assuming backend returns "user" field. We can use dynamic for now or map it later.
    required Map<String, dynamic> user, 
    required String message,
    @JsonKey(name: 'stats_gained') required Map<String, int> statsGained,
  }) = _OnboardingResult;

  factory OnboardingResult.fromJson(Map<String, dynamic> json) =>
      _$OnboardingResultFromJson(json);
}

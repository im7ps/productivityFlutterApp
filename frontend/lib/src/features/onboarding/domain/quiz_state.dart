import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_state.freezed.dart';
part 'quiz_state.g.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    @Default(0) int currentQuestionIndex,
    @Default({
      'stat_strength': 10,
      'stat_endurance': 10,
      'stat_intelligence': 10,
      'stat_focus': 10,
    }) Map<String, int> accumulatedStats,
    @Default(false) bool isFinished,
  }) = _QuizState;

  factory QuizState.fromJson(Map<String, dynamic> json) => _$QuizStateFromJson(json);
}

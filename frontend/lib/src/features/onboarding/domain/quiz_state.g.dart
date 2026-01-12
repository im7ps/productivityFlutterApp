// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizStateImpl _$$QuizStateImplFromJson(Map<String, dynamic> json) =>
    _$QuizStateImpl(
      currentQuestionIndex:
          (json['current_question_index'] as num?)?.toInt() ?? 0,
      accumulatedStats:
          (json['accumulated_stats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {
            'stat_strength': 10,
            'stat_endurance': 10,
            'stat_intelligence': 10,
            'stat_focus': 10,
          },
      isFinished: json['is_finished'] as bool? ?? false,
    );

Map<String, dynamic> _$$QuizStateImplToJson(_$QuizStateImpl instance) =>
    <String, dynamic>{
      'current_question_index': instance.currentQuestionIndex,
      'accumulated_stats': instance.accumulatedStats,
      'is_finished': instance.isFinished,
    };

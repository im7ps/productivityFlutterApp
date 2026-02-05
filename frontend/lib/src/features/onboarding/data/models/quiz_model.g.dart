// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizOptionImpl _$$QuizOptionImplFromJson(Map<String, dynamic> json) =>
    _$QuizOptionImpl(
      value: (json['value'] as num).toInt(),
      label: json['label'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$QuizOptionImplToJson(_$QuizOptionImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'description': instance.description,
    };

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

_$QuizCategoryImpl _$$QuizCategoryImplFromJson(Map<String, dynamic> json) =>
    _$QuizCategoryImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizCategoryImplToJson(_$QuizCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };

_$QuizManifestImpl _$$QuizManifestImplFromJson(Map<String, dynamic> json) =>
    _$QuizManifestImpl(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => QuizCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizManifestImplToJson(_$QuizManifestImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      questionId: json['question_id'] as String,
      selectedValue: (json['selected_value'] as num).toInt(),
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'selected_value': instance.selectedValue,
    };

_$QuizSubmissionImpl _$$QuizSubmissionImplFromJson(Map<String, dynamic> json) =>
    _$QuizSubmissionImpl(
      answers: (json['answers'] as List<dynamic>)
          .map((e) => QuizAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizSubmissionImplToJson(
  _$QuizSubmissionImpl instance,
) => <String, dynamic>{
  'answers': instance.answers.map((e) => e.toJson()).toList(),
};

_$OnboardingResultImpl _$$OnboardingResultImplFromJson(
  Map<String, dynamic> json,
) => _$OnboardingResultImpl(
  user: UserPublic.fromJson(json['user'] as Map<String, dynamic>),
  message: json['message'] as String,
  statsGained: Map<String, int>.from(json['stats_gained'] as Map),
);

Map<String, dynamic> _$$OnboardingResultImplToJson(
  _$OnboardingResultImpl instance,
) => <String, dynamic>{
  'user': instance.user.toJson(),
  'message': instance.message,
  'stats_gained': instance.statsGained,
};

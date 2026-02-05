import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/networking/dio_provider.dart';
import '../../../../core/networking/api_request.dart';
import '../../data/models/quiz_model.dart';
import '../../domain/repositories/onboarding_repository.dart';

part 'onboarding_repository_impl.g.dart';

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return OnboardingRepositoryImpl(dio);
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  final Dio _dio;

  OnboardingRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, QuizManifest>> getQuizManifest() {
    return makeRequest(
      () => _dio.get('/api/v1/onboarding/quiz'),
      (data) => QuizManifest.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, OnboardingResult>> submitQuiz(
    QuizSubmission submission,
  ) {
    return makeRequest(
      () => _dio.post(
        '/api/v1/onboarding/submit',
        data: submission.toJson(),
      ),
      (data) => OnboardingResult.fromJson(data),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/networking/dio_provider.dart';
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
  Future<Either<Failure, QuizManifest>> getQuizManifest() async {
    try {
      final response = await _dio.get('/api/v1/onboarding/quiz');
      return Right(QuizManifest.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Unknown Dio Error', e.response?.statusCode),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnboardingResult>> submitQuiz(
    QuizSubmission submission,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/onboarding/submit',
        data: submission.toJson(),
      );
      return Right(OnboardingResult.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Unknown Dio Error', e.response?.statusCode),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

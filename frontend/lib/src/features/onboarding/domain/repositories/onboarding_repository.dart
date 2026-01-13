import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/quiz_model.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, QuizManifest>> getQuizManifest();
  Future<Either<Failure, OnboardingResult>> submitQuiz(QuizSubmission submission);
}

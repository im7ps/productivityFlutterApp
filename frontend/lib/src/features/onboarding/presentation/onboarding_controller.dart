import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/onboarding_repository.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<bool> build() async {
    final repo = ref.watch(onboardingRepositoryProvider);
    return repo.isOnboardingSeen();
  }

  Future<void> completeOnboarding() async {
    final repo = ref.read(onboardingRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await repo.setOnboardingSeen();
      return true;
    });
  }
}

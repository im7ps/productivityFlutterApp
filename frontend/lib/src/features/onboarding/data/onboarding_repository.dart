import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_provider.dart';

part 'onboarding_repository.g.dart';

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  // We use requireValue because we assume SharedPreferences is initialized at app startup
  // or we handle the loading state in the controller.
  // Actually, sharedPreferencesProvider is a Future, so let's handle it gracefully.
  // But for a simple repo, we might just want to await it or use `ref.watch`.
  // To keep it simple and synchronous where possible in usage, let's just return the class
  // and let methods be async.
  return OnboardingRepository(ref);
}

class OnboardingRepository {
  final Ref _ref;
  static const _onboardingSeenKey = 'onboarding_seen';

  OnboardingRepository(this._ref);

  Future<void> setOnboardingSeen() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_onboardingSeenKey, true);
  }

  Future<bool> isOnboardingSeen() async {
    final prefs = await _ref.read(sharedPreferencesProvider.future);
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../data/models/user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  Future<UserPublic?> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    final loginResult = await repository.login(username: username, password: password);

    return await loginResult.fold(
      (failure) {
        state = AsyncError(failure.displayMessage, StackTrace.current);
        return null;
      },
      (token) async {
        // Login successful, now fetch user
        final userResult = await repository.getCurrentUser();
        return userResult.fold(
          (failure) {
             state = AsyncError("Login successful but failed to fetch profile: ${failure.displayMessage}", StackTrace.current);
             return null;
          },
          (user) {
            state = const AsyncData(null);
            return user;
          }
        );
      },
    );
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.signUp(
      username: username,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = AsyncError(failure.displayMessage, StackTrace.current);
        return false;
      },
      (user) {
        state = const AsyncData(null);
        return true;
      },
    );
  }

  Future<void> completeOnboarding(Map<String, int> stats) async {
    state = const AsyncLoading();

    // Costruiamo il payload per l'aggiornamento
    final updateData = UserUpdate(
      isOnboardingCompleted: true,
      statStrength: stats['stat_strength'],
      statEndurance: stats['stat_endurance'],
      statIntelligence: stats['stat_intelligence'],
      statFocus: stats['stat_focus'],
    );

    final repository = ref.read(authRepositoryProvider);

    final result = await repository.updateUser(updateData);

    state = result.fold(
      (failure) => AsyncError(failure.displayMessage, StackTrace.current),
      (success) => const AsyncData(null),
    );

    if (state.hasError) {
      throw Exception(state.error.toString());
    }
  }
}

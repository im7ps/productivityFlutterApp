import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../data/models/user.dart';
import 'auth_state_provider.dart';

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
            // Invalida l'auth state per triggerare il redirect del router
            ref.invalidate(authStateProvider);
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
        // Anche dopo il signup potremmo voler invalidare se facciamo auto-login
        // In questo caso il controller fa solo signup, l'utente dovrà fare login.
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    ref.invalidate(authStateProvider);
    state = const AsyncData(null);
  }
}

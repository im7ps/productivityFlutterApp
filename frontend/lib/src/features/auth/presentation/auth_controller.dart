import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> completeOnboarding(Map<String, int> stats) async {
    state = const AsyncLoading();
    
    // Costruiamo il payload per l'aggiornamento
    final updateData = {
      'is_onboarding_completed': true,
      ...stats,
    };

    final repository = ref.read(authRepositoryProvider);
    
    // Nota: AuthRepository.updateUser deve essere implementato
    final result = await repository.updateUser(updateData);

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (success) => const AsyncData(null),
    );
    
    if (state.hasError) {
        throw Exception(state.error);
    }
  }
}

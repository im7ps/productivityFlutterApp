import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/storage_provider.dart';

part 'auth_state_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<bool> build() async {
    final storage = ref.watch(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  Future<void> updateAuthState() async {
    ref.invalidateSelf();
  }
}

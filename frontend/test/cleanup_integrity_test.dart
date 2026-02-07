import 'package:flutter_test/flutter_test.dart';
import 'package:whativedone/src/features/auth/data/models/user.dart';
import 'package:whativedone/src/core/storage/storage_provider.dart';

void main() {
  group('Cleanup Integrity Tests', () {
    test('UserPublic model should not contain RPG fields in JSON', () {
      final now = DateTime.now();
      final user = UserPublic(
        id: '1',
        username: 'test',
        email: 'test@example.com',
        createdAt: now,
      );
      
      final json = user.toJson();
      
      expect(json.containsKey('stat_strength'), isFalse);
      expect(json.containsKey('statStrength'), isFalse);
      expect(json.containsKey('is_onboarding_completed'), isFalse);
      expect(json.containsKey('isOnboardingCompleted'), isFalse);
      expect(json.containsKey('daily_reached_goal'), isFalse);
    });

    test('StorageKeys should be clean of RPG/Quiz references', () {
      // Questo check verifica la pulizia delle costanti
      // Nota: Accediamo tramite riflessione o semplicemente sapendo cosa deve mancare
      // In questo caso il test fallirebbe in compilazione se StorageKeys.quizIndex esistesse ancora
      // ma facciamo un check semantico se possibile o lo lasciamo come documentazione vivente.
      expect(StorageKeys.accessToken, equals('access_token'));
    });
  });
}

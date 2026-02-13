import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:whativedone/src/features/chat/presentation/chat_screen.dart';
import 'package:whativedone/src/features/chat/data/speech_to_text_provider.dart';
import 'package:whativedone/src/features/chat/data/permission_provider.dart';

class MockSpeechToText extends Mock implements SpeechToText {}
class MockPermissionService extends Mock implements PermissionService {}
class FakeSpeechListenOptions extends Fake implements SpeechListenOptions {}

void main() {
  late MockSpeechToText mockSpeech;
  late MockPermissionService mockPermission;

  setUpAll(() {
    registerFallbackValue(ListenMode.confirmation);
    registerFallbackValue(FakeSpeechListenOptions());
  });

  setUp(() {
    mockSpeech = MockSpeechToText();
    mockPermission = MockPermissionService();

    when(
      () => mockSpeech.initialize(
        onStatus: any(named: 'onStatus'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((_) async => true);

    when(() => mockSpeech.stop()).thenAnswer((_) async => {});
    
    when(() => mockPermission.requestMicrophonePermission()).thenAnswer((_) async => true);
  });

  testWidgets('ChatScreen shows mic button and title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speechToTextProvider.overrideWithValue(mockSpeech),
          permissionServiceProvider.overrideWithValue(mockPermission),
        ],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    expect(find.text('AI CONSULTANT'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
  });

  testWidgets('Microphone button starts listening and shows active state', (
    tester,
  ) async {
    when(
      () => mockSpeech.listen(
        onResult: any(named: 'onResult'),
        listenFor: any(named: 'listenFor'),
        pauseFor: any(named: 'pauseFor'),
        localeId: any(named: 'localeId'),
        onSoundLevelChange: any(named: 'onSoundLevelChange'),
        listenOptions: any(named: 'listenOptions'),
      ),
    ).thenAnswer((_) async => {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speechToTextProvider.overrideWithValue(mockSpeech),
          permissionServiceProvider.overrideWithValue(mockPermission),
        ],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    final micButton = find.byIcon(Icons.mic_none_rounded);
    await tester.tap(micButton);
    
    // Pump per processare la Future del toggleListening
    await tester.pump();
    await tester.pump(); 

    expect(find.byIcon(Icons.mic), findsOneWidget);
  });
}

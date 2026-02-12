import 'dart:async'; // Added for Completer
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whativedone/src/core/networking/network_exceptions.dart';
import 'package:whativedone/src/features/action/presentation/action_providers.dart';
import 'package:whativedone/src/features/consultant/data/consultant_repository.dart';
import 'package:whativedone/src/features/consultant/presentation/consultant_screen.dart';
import 'package:whativedone/src/features/consultant/presentation/widgets/consultant_card.dart';
import 'package:whativedone/src/features/dashboard/presentation/dashboard_models.dart';
import 'package:whativedone/l10n/app_localizations.dart';
import 'package:whativedone/src/core/storage/local_storage_service.dart';
import 'package:whativedone/src/features/dashboard/presentation/dashboard_providers.dart';

// Mocks
class MockConsultantRepository extends Mock implements ConsultantRepository {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

// We use the real one to avoid issues with StateNotifier mocking
class TestAllTasksNotifier extends AllTasksNotifier {
  TestAllTasksNotifier() : super();
}

// Dummy TaskUIModel for fallback
TaskUIModel _createDummyTask() => TaskUIModel(
  id: 'dummy',
  title: 'Dummy Task',
  category: 'Dovere',
  difficulty: 1,
  satisfaction: 1,
  icon: Icons.abc,
  color: Colors.white,
  isCompleted: false,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_createDummyTask());
    registerFallbackValue(StackTrace.empty);
  });

  group('ConsultantScreen', () {
    late MockConsultantRepository mockConsultantRepository;
    late TestAllTasksNotifier testAllTasksNotifier;
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockConsultantRepository = MockConsultantRepository();
      testAllTasksNotifier = TestAllTasksNotifier();
      mockLocalStorageService = MockLocalStorageService();

      // Default mock for fetchProposals
      when(
        () => mockConsultantRepository.fetchProposals(),
      ).thenAnswer((_) async => right([]));

      // Mock LocalStorageService
      when(() => mockLocalStorageService.loadTasks()).thenAnswer((_) async => []);
      when(() => mockLocalStorageService.saveTasks(any())).thenAnswer((_) async => {});
    });

    // Helper to pump the widget with necessary providers
    Future<void> pumpConsultantScreen(
      WidgetTester tester, {
      required List<TaskUIModel> proposals,
      bool isLoading = false,
      Object? error,
      Completer<Either<NetworkExceptions, List<TaskUIModel>>>? completer,
    }) async {
      if (isLoading) {
        // Return a future that doesn't complete to simulate persistent loading
        final loadingCompleter =
            completer ??
            Completer<Either<NetworkExceptions, List<TaskUIModel>>>();
        when(
          () => mockConsultantRepository.fetchProposals(),
        ).thenAnswer((_) => loadingCompleter.future);
      } else if (error != null) {
        when(() => mockConsultantRepository.fetchProposals()).thenAnswer(
          (_) async => left(
            error is NetworkExceptions
                ? error
                : NetworkExceptions.defaultError(error.toString()),
          ),
        );
      } else {
        when(
          () => mockConsultantRepository.fetchProposals(),
        ).thenAnswer((_) async => right(proposals));
      }

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Text('Dashboard')),
          ),
          GoRoute(
            path: '/consultant',
            builder: (context, state) => const ConsultantScreen(),
          ),
          GoRoute(
            path: '/portfolio',
            builder: (context, state) =>
                const Scaffold(body: Text('Portfolio')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consultantRepositoryProvider.overrideWithValue(
              mockConsultantRepository,
            ),
            allTasksProvider.overrideWith((ref) => testAllTasksNotifier),
            localStorageServiceProvider.overrideWithValue(mockLocalStorageService),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      // Navigate to consultant to have a history to pop from
      router.push('/consultant');
      await tester.pump(); // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Give it time to push

      if (!isLoading && error == null) {
        // Wait for data to load if not testing loading/error specifically
        await tester.pump();
      }
    }

    testWidgets('displays loading indicator when proposals are loading', (
      tester,
    ) async {
      await pumpConsultantScreen(tester, proposals: [], isLoading: true);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when proposals fail to load', (
      tester,
    ) async {
      final testError = NetworkExceptions.defaultError('Failed to fetch');
      await pumpConsultantScreen(tester, proposals: [], error: testError);

      // Use textContaining because multi-line strings can be tricky with find.text
      expect(find.textContaining('Failed to fetch'), findsOneWidget);
    });

    testWidgets('displays proposals when successfully loaded', (tester) async {
      final mockProposals = [
        TaskUIModel(
          id: '1',
          title: 'Test Task 1',
          category: 'Dovere',
          difficulty: 1,
          satisfaction: 1,
          icon: Icons.abc,
          color: Colors.red,
          isCompleted: false,
        ),
        TaskUIModel(
          id: '2',
          title: 'Test Task 2',
          category: 'Passione',
          difficulty: 2,
          satisfaction: 2,
          icon: Icons.abc,
          color: Colors.blue,
          isCompleted: false,
        ),
      ];
      await pumpConsultantScreen(tester, proposals: mockProposals);

      expect(find.text('TEST TASK 1'), findsOneWidget); // Uppercase in widget
      expect(find.text('TEST TASK 2'), findsOneWidget);
      expect(find.byType(ConsultantCard), findsNWidgets(2));
    });

    testWidgets('toggling a proposal selects/deselects it', (tester) async {
      // Increase surface size to ensure buttons are clickable
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final mockProposals = [
        TaskUIModel(
          id: '1',
          title: 'Test Task 1',
          category: 'Dovere',
          difficulty: 1,
          satisfaction: 1,
          icon: Icons.abc,
          color: Colors.red,
          isCompleted: false,
        ),
      ];
      await pumpConsultantScreen(tester, proposals: mockProposals);

      final cardFinder = find.byType(ConsultantCard);
      expect(tester.widget<ConsultantCard>(cardFinder).isSelected, isFalse);

      await tester.tap(cardFinder);
      await tester.pump();
      expect(tester.widget<ConsultantCard>(cardFinder).isSelected, isTrue);

      await tester.tap(cardFinder);
      await tester.pump();
      expect(tester.widget<ConsultantCard>(cardFinder).isSelected, isFalse);
    });

    testWidgets('confirm button consumes selected proposals and updates state', (
      tester,
    ) async {
      // Increase surface size to ensure FAB is clickable
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final mockProposals = [
        TaskUIModel(
          id: '1',
          title: 'Test Task 1',
          category: 'Dovere',
          difficulty: 1,
          satisfaction: 1,
          icon: Icons.abc,
          color: Colors.red,
          isCompleted: false,
        ),
      ];
      final newMockProposals = [
        TaskUIModel(
          id: '3',
          title: 'New Task 3',
          category: 'Energia',
          difficulty: 3,
          satisfaction: 3,
          icon: Icons.abc,
          color: Colors.green,
          isCompleted: false,
        ),
      ];

      when(
        () => mockConsultantRepository.consumeProposal(any()),
      ).thenAnswer((_) async => right(newMockProposals));

      await pumpConsultantScreen(tester, proposals: mockProposals);

      // Select the card
      await tester.tap(find.byType(ConsultantCard));
      await tester.pumpAndSettle(); // Wait for selection animation

      // Tap the confirm button
      final fabFinder = find.byIcon(Icons.check_rounded);
      expect(fabFinder, findsOneWidget);

      // AnimatedScale might prevent hit testing at the very start of the animation
      // so we pump a bit more and then tap.
      await tester.tap(fabFinder, warnIfMissed: false);

      // Handle async and animations
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify consumeProposal was called
      verify(() => mockConsultantRepository.consumeProposal(any())).called(1);
      
      // Verify task was added to allTasks (portfolio)
      expect(testAllTasksNotifier.state.any((t) => t.id == '1'), isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whativedone/src/features/daily_log/application/daily_logs_provider.dart';
import 'package:whativedone/src/features/daily_log/data/repositories/daily_log_repository_impl.dart';
import 'package:whativedone/src/features/daily_log/domain/daily_log_repository.dart';
import 'package:whativedone/src/features/daily_log/data/models/daily_log.dart';
import 'package:whativedone/src/core/errors/failure.dart';

class MockDailyLogRepository extends Mock implements DailyLogRepository {}

void main() {
  late MockDailyLogRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockDailyLogRepository();
    container = ProviderContainer(
      overrides: [dailyLogRepositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);
  });

  group('DailyLogsNotifier', () {
    test(
      'initial state should be AsyncLoading then AsyncData on success',
      () async {
        final logs = [
          const DailyLogRead(
            id: '1',
            day: '2026-02-05',
            sleepHours: 8,
            sleepQuality: 4,
            moodScore: 4,
            dietQuality: 3,
            exerciseMinutes: 30,
          ),
        ];

        when(
          () => mockRepository.getDailyLogs(),
        ).thenAnswer((_) async => Right(logs));

        // Wait for build to complete
        final result = await container.read(dailyLogsNotifierProvider.future);

        expect(result, logs);
        expect(
          container.read(dailyLogsNotifierProvider),
          isA<AsyncData<List<DailyLogRead>>>(),
        );
        verify(() => mockRepository.getDailyLogs()).called(1);
      },
    );

    test('should set AsyncError when repository fails', () async {
      const failure = Failure.server('Server Error');

      when(
        () => mockRepository.getDailyLogs(),
      ).thenAnswer((_) async => const Left(failure));

      // Build the notifier and wait for error
      try {
        await container.read(dailyLogsNotifierProvider.future);
      } catch (e) {
        // Riverpod throws the error in .future
      }

      final state = container.read(dailyLogsNotifierProvider);
      expect(state, isA<AsyncError>());
      expect(state.error, failure);
    });

    test('addLog should update state with new log on success', () async {
      // 1. Initial build
      when(
        () => mockRepository.getDailyLogs(),
      ).thenAnswer((_) async => const Right([]));

      await container.read(dailyLogsNotifierProvider.future);

      // 2. Add log
      const newLogCreate = DailyLogCreate(day: '2026-02-05');
      const newLogRead = DailyLogRead(
        id: '2',
        day: '2026-02-05',
        sleepHours: 0,
        sleepQuality: 5,
        moodScore: 5,
        dietQuality: 5,
        exerciseMinutes: 0,
      );

      when(
        () => mockRepository.createDailyLog(newLogCreate),
      ).thenAnswer((_) async => const Right(newLogRead));

      await container
          .read(dailyLogsNotifierProvider.notifier)
          .addLog(newLogCreate);

      final state = container.read(dailyLogsNotifierProvider);
      expect(state.value, [newLogRead]);
      verify(() => mockRepository.createDailyLog(newLogCreate)).called(1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whativedone/src/features/action/data/action_repository.dart';
import 'package:whativedone/src/features/action/domain/action.dart' as domain;
import 'package:whativedone/src/features/dimension/data/dimension_repository.dart';
import 'package:whativedone/src/features/dimension/domain/dimension.dart';
import 'package:whativedone/src/features/dashboard/presentation/dashboard_providers.dart';

class MockActionRepository extends Mock implements ActionRepository {}
class MockDimensionRepository extends Mock implements DimensionRepository {}

void main() {
  late MockActionRepository mockActionRepo;
  late MockDimensionRepository mockDimRepo;
  late ProviderContainer container;

  setUp(() {
    mockActionRepo = MockActionRepository();
    mockDimRepo = MockDimensionRepository();
    container = ProviderContainer(
      overrides: [
        actionRepositoryProvider.overrideWithValue(mockActionRepo),
        dimensionRepositoryProvider.overrideWithValue(mockDimRepo),
      ],
    );
    addTearDown(container.dispose);
  });

  group('dimensionEnergyProvider', () {
    test('calculates and normalizes levels correctly', () async {
      final dimensions = [
        const Dimension(id: 'energy', name: 'Energia'),
        const Dimension(id: 'soul', name: 'Anima'),
      ];

      final actions = [
        domain.Action(
          id: '1',
          userId: 'u1',
          dimensionId: 'energy',
          fulfillmentScore: 5,
          startTime: DateTime.now(),
        ),
        domain.Action(
          id: '2',
          userId: 'u1',
          dimensionId: 'energy',
          fulfillmentScore: 3,
          startTime: DateTime.now(),
        ),
        domain.Action(
          id: '3',
          userId: 'u1',
          dimensionId: 'soul',
          fulfillmentScore: 4,
          startTime: DateTime.now(),
        ),
      ];

      when(() => mockDimRepo.getDimensions()).thenAnswer((_) async => dimensions);
      when(() => mockActionRepo.getActions()).thenAnswer((_) async => actions);

      final levels = await container.read(dimensionEnergyProvider.future);

      // energy: (5 + 3) / 20 = 8 / 20 = 0.4
      expect(levels['energy'], 0.4);
      // soul: 4 / 20 = 0.2
      expect(levels['soul'], 0.2);
    });

    test('clamps levels at 1.0', () async {
      final dimensions = [const Dimension(id: 'energy', name: 'Energia')];
      final actions = [
        domain.Action(
          id: '1',
          userId: 'u1',
          dimensionId: 'energy',
          fulfillmentScore: 25, // Over the 20 target
          startTime: DateTime.now(),
        ),
      ];

      when(() => mockDimRepo.getDimensions()).thenAnswer((_) async => dimensions);
      when(() => mockActionRepo.getActions()).thenAnswer((_) async => actions);

      final levels = await container.read(dimensionEnergyProvider.future);

      expect(levels['energy'], 1.0);
    });
  });
}

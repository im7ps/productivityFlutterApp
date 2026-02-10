import 'package:flutter_test/flutter_test.dart';
import 'package:whativedone/src/features/dashboard/domain/action_category_data.dart';

void main() {
  group('ActionCategory', () {
    test('fromLabel returns correct category for known labels', () {
      expect(ActionCategory.fromLabel('Corsa'), ActionCategory.run);
      expect(ActionCategory.fromLabel('Lavoro'), ActionCategory.work);
      expect(ActionCategory.fromLabel('Meditazione'), ActionCategory.meditate);
    });

    test('fromLabel is case insensitive', () {
      expect(ActionCategory.fromLabel('corsa'), ActionCategory.run);
      expect(ActionCategory.fromLabel('LAVORO'), ActionCategory.work);
    });

    test('fromLabel returns fallback for unknown labels', () {
      expect(ActionCategory.fromLabel('unknown_action'), ActionCategory.work);
    });

    test('getByDimension returns specific lists', () {
      final energyActions = ActionCategory.getByDimension('energy');
      expect(energyActions.contains(ActionCategory.run), isTrue);
      expect(energyActions.contains(ActionCategory.gym), isTrue);
      expect(energyActions.contains(ActionCategory.meditate), isFalse);

      final soulActions = ActionCategory.getByDimension('soul');
      expect(soulActions.contains(ActionCategory.meditate), isTrue);
      expect(soulActions.contains(ActionCategory.run), isFalse);
    });

    test('isKnown correctly identifies labels', () {
      expect(ActionCategory.isKnown('Corsa'), isTrue);
      expect(ActionCategory.isKnown('Pizza'), isFalse);
    });
  });
}

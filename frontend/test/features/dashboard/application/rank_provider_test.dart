import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whativedone/src/features/dashboard/presentation/dashboard_providers.dart';

class FakeTaskList extends TaskList {
  @override
  Future<List<TaskUIModel>> build() async => [];
}

class FakeCurrentCategory extends CurrentCategory {
  @override
  int build() => 0;
}

void main() {
  group('Rank Providers', () {
    test('rankProvider starts at 0.0', () async {
      final container = ProviderContainer(
        overrides: [
          availableCategoriesProvider.overrideWithValue([
            const CategoryInfo(id: 'general', label: 'G', icon: Icons.abc, color: Colors.red),
          ]),
          currentCategoryProvider.overrideWith(FakeCurrentCategory.new),
          taskListProvider.overrideWith(FakeTaskList.new),
        ],
      );
      addTearDown(container.dispose);

      await container.read(taskListProvider.future);
      
      expect(container.read(rankProvider), 0.0);
    });

    test('rankLabelProvider returns C for 0.0', () {
      final container = ProviderContainer(
        overrides: [
          availableCategoriesProvider.overrideWithValue([
            const CategoryInfo(id: 'general', label: 'G', icon: Icons.abc, color: Colors.red),
          ]),
          currentCategoryProvider.overrideWith(FakeCurrentCategory.new),
          rankByCategoryProvider('general').overrideWithValue(0.0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(rankLabelProvider), 'C');
    });

    test('rankLabelProvider returns GOD for 1.0', () {
      final container = ProviderContainer(
        overrides: [
          availableCategoriesProvider.overrideWithValue([
            const CategoryInfo(id: 'general', label: 'G', icon: Icons.abc, color: Colors.red),
          ]),
          currentCategoryProvider.overrideWith(FakeCurrentCategory.new),
          rankByCategoryProvider('general').overrideWithValue(1.0),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(rankLabelProvider), 'GOD');
    });
  });
}

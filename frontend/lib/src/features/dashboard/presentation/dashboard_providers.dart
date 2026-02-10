import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../action/presentation/action_providers.dart';
import '../../dimension/presentation/dimension_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<Map<String, double>> dimensionEnergy(Ref ref) async {
  // Watch pending futures
  final actions = await ref.watch(actionListProvider.future);
  final dimensions = await ref.watch(dimensionsListProvider.future);

  // Initialize levels with 0.0 for all known dimensions
  final Map<String, double> levels = {for (var dim in dimensions) dim.id: 0.0};

  // Logic: Sum fulfillment scores for today's actions
  // Note: Assuming actionListProvider returns actions relevant for the view (e.g. Today)
  for (var action in actions) {
    if (levels.containsKey(action.dimensionId)) {
      levels[action.dimensionId] =
          (levels[action.dimensionId]! + action.fulfillmentScore);
    }
  }

  // Normalize (Daily Target: 20 points)
  // 20 points = 1.0 (Full)
  levels.updateAll((key, val) => (val / 20.0).clamp(0.0, 1.0));

  return levels;
}

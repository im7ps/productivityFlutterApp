import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/action_repository.dart';
import '../domain/action.dart';

part 'action_providers.g.dart';

@riverpod
Future<List<Action>> actionList(Ref ref) async {
  final repo = ref.watch(actionRepositoryProvider);
  final actions = await repo.getActions();
  return actions;
}

@riverpod
class ActionCreateController extends _$ActionCreateController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<Action?> createAction({
    required String dimensionId,
    required int fulfillmentScore,
    String? description,
    DateTime? startTime,
  }) async {
    final repo = ref.read(actionRepositoryProvider);
    state = const AsyncValue.loading();

    final actionIn = ActionCreate(
      dimensionId: dimensionId,
      fulfillmentScore: fulfillmentScore,
      description: description,
      startTime: startTime,
    );

    final result = await AsyncValue.guard(() => repo.createAction(actionIn));
    state = result;

    if (!state.hasError && result.value != null) {
      ref.invalidate(actionListProvider);
      return result.value;
    }
    return null;
  }

  Future<void> deleteAction(String actionId) async {
    final repo = ref.read(actionRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repo.deleteAction(actionId));
    if (!state.hasError) {
      ref.invalidate(actionListProvider);
    }
  }
}

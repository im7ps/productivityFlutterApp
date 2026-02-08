import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/action_repository.dart';
import '../domain/action.dart';

part 'action_providers.g.dart';

@riverpod
Future<List<Action>> actionList(ActionListRef ref) async {
  final repo = ref.watch(actionRepositoryProvider);
  final actions = await repo.getActions();
  print("DEBUG: Fetched ${actions.length} actions from backend");
  for (var a in actions) {
    print("DEBUG: Action ID: ${a.id}, Dim: ${a.dimensionId}, Score: ${a.fulfillmentScore}");
  }
  return actions;
}

@riverpod
class ActionCreateController extends _$ActionCreateController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<bool> createAction({
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

    state = await AsyncValue.guard(() => repo.createAction(actionIn));
    
    if (!state.hasError) {
      // Forziamo il refresh del SSOT (Single Source of Truth)
      ref.invalidate(actionListProvider);
      return true;
    }
    return false;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import '../data/consultant_repository.dart'; // For ConsultantRepository and providers
import '../../action/presentation/action_providers.dart'; // For allTasksProvider

// Provider per gestire la selezione delle missioni nel Consulente
final selectedMissionsProvider = StateProvider.autoDispose<Set<String>>(
  (ref) => {},
);

// Notifier per gestire la lista di proposte del consulente
class ConsultantProposalsNotifier
    extends StateNotifier<AsyncValue<List<TaskUIModel>>> {
  final ConsultantRepository _repository;

  ConsultantProposalsNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    loadProposals();
  }

  Future<void> loadProposals() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchProposals();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (proposals) => AsyncValue.data(proposals),
    );
  }

  Future<void> consumeProposal(String proposalId, {required Ref ref}) async {
    // Capture current proposals before setting state to loading
    final currentProposals = state.value;

    state = const AsyncValue.loading();
    final result = await _repository.consumeProposal(proposalId);

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (newProposals) {
        // Find the consumed task from the captured proposals
        final consumedTask = currentProposals?.firstWhere(
          (task) => task.id == proposalId,
        );

        if (consumedTask != null) {
          // 1. ADD DIRECTLY TO TODAY'S ARSENAL (Dashboard)
          ref.read(taskListProvider.notifier).addTasks([consumedTask]);

          // 2. SYNC WITH PORTFOLIO (Avoid duplicates by title)
          final portfolio = ref.read(allTasksProvider);
          final existsInPortfolio = portfolio.any(
            (t) => t.title.toLowerCase() == consumedTask.title.toLowerCase(),
          );

          if (!existsInPortfolio) {
            ref.read(allTasksProvider.notifier).addTask(consumedTask);
          }
        }
        return AsyncValue.data(newProposals);
      },
    );
  }
}

final consultantProposalsProvider =
    StateNotifierProvider.autoDispose<
      ConsultantProposalsNotifier,
      AsyncValue<List<TaskUIModel>>
    >((ref) {
      final repository = ref.watch(consultantRepositoryProvider);
      return ConsultantProposalsNotifier(repository);
    });

// Logica per confermare e aggiungere alla home (aggiornata)
final missionConfirmProvider = Provider((ref) {
  return (Set<String> selectedIds) async {
    // No BuildContext here
    final consultantProposals = ref.read(consultantProposalsProvider).value;

    if (consultantProposals == null) {
      return Future.value(
        [],
      ); // Explicitly return an empty list wrapped in a Future
    }

    final List<TaskUIModel> consumedTasks =
        []; // To store tasks that were successfully consumed

    for (final id in selectedIds) {
      final taskToConsume = consultantProposals.firstWhere(
        (task) => task.id == id,
      );
      await ref
          .read(consultantProposalsProvider.notifier)
          .consumeProposal(id, ref: ref);
      consumedTasks.add(taskToConsume); // Add to list for UI feedback
    }

    ref.invalidate(
      selectedMissionsProvider,
    ); // Clear selection after processing
    return consumedTasks; // Return list of consumed tasks for UI to show feedback
  };
});

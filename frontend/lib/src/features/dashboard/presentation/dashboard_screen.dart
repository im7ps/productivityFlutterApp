import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../action/presentation/action_providers.dart';
import '../../auth/presentation/auth_controller.dart';
import 'widgets/add_action_modal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddActionModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionsAsync = ref.watch(actionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("What I've Done"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Rivedi Manifesto',
            onPressed: () => context.push('/onboarding'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: actionsAsync.when(
        data: (actions) {
          if (actions.isEmpty) {
            return const Center(child: Text(AppStrings.noActivitiesToday));
          }
          return ListView.builder(
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return ListTile(
                leading: _getDimensionIcon(action.dimensionId),
                title: Text(action.description ?? AppStrings.actionUntitled),
                subtitle: Text(
                  'Fulfillment: ${action.fulfillmentScore}/5 • ${action.startTime.hour}:${action.startTime.minute.toString().padLeft(2, '0')}',
                ),
                trailing: Text(action.dimension?.name ?? ''),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('${AppStrings.errorGeneric}: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getDimensionIcon(String dimensionId) {
    switch (dimensionId) {
      case 'energy':
        return const Icon(Icons.bolt, color: Colors.orange);
      case 'clarity':
        return const Icon(Icons.lightbulb_outline, color: Colors.blue);
      case 'relationships':
        return const Icon(Icons.favorite_border, color: Colors.red);
      case 'soul':
        return const Icon(Icons.auto_awesome, color: Colors.purple);
      default:
        return const Icon(Icons.circle_outlined);
    }
  }
}

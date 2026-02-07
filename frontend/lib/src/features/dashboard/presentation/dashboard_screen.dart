import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../activity_log/presentation/activity_providers.dart';
import '../../auth/presentation/auth_controller.dart';
import 'widgets/add_activity_modal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Importante per la tastiera
      builder: (_) => const AddActivityModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityLogsAsync = ref.watch(activityLogListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: activityLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text(AppStrings.noActivitiesToday));
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(log.description ?? AppStrings.activityUntitled),
                subtitle: Text(
                  '${log.startTime.hour}:${log.startTime.minute.toString().padLeft(2, '0')}',
                ),
                // trailing: Text(log.category?.name ?? ''), // TODO: Join category data
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
}

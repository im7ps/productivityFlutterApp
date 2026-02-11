import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import 'dashboard_providers.dart';
import 'widgets/day0/rank_widget.dart';
import 'widgets/day0/checkpoint_bar.dart';
import 'widgets/day0/identity_grid.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showTaskDetail(BuildContext context, WidgetRef ref, TaskUIModel task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: task.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(task.icon, size: 48, color: task.color),
            const SizedBox(height: 16),
            Text(
              task.title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: task.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "CATEGORIA: ${task.category.toUpperCase()}",
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatChip(
                  context,
                  "Fatica",
                  task.difficulty.toString(),
                  Icons.fitness_center,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  context,
                  "Soddisfazione",
                  task.satisfaction.toString(),
                  Icons.star,
                ),
              ],
            ),
            const SizedBox(height: 32), // Spazio finale senza bottoni
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            "$label: $value",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
    Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasks = ref.watch(filteredTasksProvider);
    final rankScore = ref.watch(rankProvider);
    final rankLabel = ref.watch(rankLabelProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${l10n.dashboardTitle}: $rankLabel",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            RankWidget(score: rankScore, rankLabel: rankLabel),
            const SizedBox(height: 40),
            const CheckpointBar(
              progress: 0.6,
              currentBlock: "Pranzo",
              nextBlock: "Cena",
            ),
            const SizedBox(height: 48),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.arsenalTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  PopupMenuButton<TaskSortOrder>(
                    icon: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Colors.white70,
                    ),
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: theme.colorScheme.surface,
                    onSelected: (order) =>
                        ref.read(taskSortProvider.notifier).setSortOrder(order),
                    itemBuilder: (context) => [
                      _buildMenuItem(
                        TaskSortOrder.recommended,
                        "Consigliato",
                        Icons.auto_awesome,
                      ),
                      _buildMenuItem(
                        TaskSortOrder.effort,
                        "Per Fatica",
                        Icons.fitness_center,
                      ),
                      _buildMenuItem(
                        TaskSortOrder.satisfaction,
                        "Per Soddisfazione",
                        Icons.star,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            IdentityGrid(
              tasks: tasks,
              onTaskLongPress: (task) => _showTaskDetail(context, ref, task),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => context.push('/consultant'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(FontAwesomeIcons.boltLightning, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PopupMenuItem<TaskSortOrder> _buildMenuItem(
    TaskSortOrder value,
    String text,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

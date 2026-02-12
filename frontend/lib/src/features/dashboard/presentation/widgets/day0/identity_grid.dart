import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../dashboard_providers.dart';

class IdentityGrid extends ConsumerWidget {
  final List<TaskUIModel> tasks;
  final Function(TaskUIModel) onTaskLongPress;
  final Function(TaskUIModel) onTaskTap;

  const IdentityGrid({
    super.key,
    required this.tasks,
    required this.onTaskLongPress,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "Nessuna missione assegnata.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final categoryColor = _getCategoryColor(task.category);
        final theme = Theme.of(context);

        return GestureDetector(
          onTap: () => onTaskTap(task),
          onLongPress: () => onTaskLongPress(task),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: task.isCompleted 
                  ? categoryColor.withValues(alpha: 0.2) 
                  : theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: task.isCompleted 
                    ? categoryColor.withValues(alpha: 0.5) 
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                if (task.isCompleted)
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  task.icon,
                  color: task.isCompleted 
                      ? categoryColor 
                      : categoryColor.withValues(alpha: 0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'dovere':
        return AppColors.dovere;
      case 'passione':
        return AppColors.passione;
      case 'energia':
        return AppColors.energia;
      case 'anima':
        return AppColors.anima;
      case 'relazioni':
        return AppColors.relazioni;
      default:
        return AppColors.neutral;
    }
  }
}

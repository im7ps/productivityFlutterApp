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

        final isInProgress = task.status == "IN_PROGRESS";
        final isCompleted = task.status == "COMPLETED";

        return GestureDetector(
          onTap: () => onTaskTap(task),
          onLongPress: () => onTaskLongPress(task),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isCompleted 
                  ? categoryColor.withValues(alpha: 0.2) 
                  : isInProgress
                      ? categoryColor.withValues(alpha: 0.1)
                      : theme.cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted 
                    ? categoryColor.withValues(alpha: 0.5) 
                    : isInProgress
                        ? categoryColor
                        : Colors.transparent,
                width: isInProgress ? 3 : 2,
              ),
              boxShadow: [
                if (isCompleted || isInProgress)
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.3),
                    blurRadius: isInProgress ? 16 : 12,
                    spreadRadius: isInProgress ? 3 : 2,
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
                  color: (isCompleted || isInProgress)
                      ? categoryColor 
                      : categoryColor.withValues(alpha: 0.4),
                  size: 24,
                ),
                if (isInProgress)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (task.durationMinutes != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Text(
                      "${task.durationMinutes}'",
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: (isCompleted || isInProgress) ? categoryColor : AppColors.grey,
                      ),
                    ),
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

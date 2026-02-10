import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard_providers.dart';

class IdentityGrid extends ConsumerWidget {
  final List<TaskUIModel> tasks;
  final Function(TaskUIModel) onTaskLongPress;

  const IdentityGrid({
    super.key,
    required this.tasks,
    required this.onTaskLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "Nessuna missione assegnata.\nUsa il fulmine per attivarne una.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack, // Recuperiamo l'effetto rimbalzo
          tween: Tween<double>(begin: 0, end: task.isCompleted ? 1.0 : 0.0),
          builder: (context, value, child) {
            // Calcoliamo i valori in modo sicuro
            final shadowBlur = (value * 12).clamp(0.0, double.infinity);
            final opacity = (value * 0.15 + 0.05).clamp(0.0, 1.0);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(taskListProvider.notifier).toggleCompletion(task.id);
              },
              onLongPress: () {
                HapticFeedback.heavyImpact();
                onTaskLongPress(task);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? task.color.withValues(alpha: opacity)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: task.isCompleted
                        ? task.color.withValues(alpha: value.clamp(0.2, 1.0))
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.1),
                    width: task.isCompleted ? 2 : 1,
                  ),
                  boxShadow: shadowBlur > 0
                      ? [
                          BoxShadow(
                            color: task.color.withValues(
                              alpha: (value * 0.4).clamp(0.0, 1.0),
                            ),
                            blurRadius: shadowBlur,
                            spreadRadius: value,
                          ),
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: Icon(
                        task.icon,
                        color: task.isCompleted
                            ? task.color
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.3),
                        size: 24,
                      ),
                    ),
                    if (task.isCompleted)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: task.color,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

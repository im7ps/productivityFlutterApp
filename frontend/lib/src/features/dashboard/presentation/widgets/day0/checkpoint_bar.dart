import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';

class CheckpointBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0 of the current block
  final String currentBlock;
  final String nextBlock;

  const CheckpointBar({
    super.key,
    required this.progress,
    required this.currentBlock,
    required this.nextBlock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/checkpoint-review'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentBlock,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                "➔ $nextBlock",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.energia,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.energia.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RankWidget extends StatelessWidget {
  final double score; // 0.0 to 1.0
  final String rankLabel;
  final VoidCallback? onTap;

  const RankWidget({
    super.key,
    required this.score,
    required this.rankLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 12.0,
        percent: score,
        animation: true,
        animationDuration: 1000,
        curve: Curves.easeOutCubic,
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rankLabel,
              style: theme.textTheme.displayMedium,
            ),
            Text(
              "RANK ATTUALE",
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
      ),
    );
  }
}

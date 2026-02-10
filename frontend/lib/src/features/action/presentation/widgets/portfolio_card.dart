import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class PortfolioCard extends StatelessWidget {
  final String title;
  final String category; // 'Dovere', 'Passione', 'Energia'
  final int completionCount;
  final double avgSatisfaction; // 1-5
  final VoidCallback onTap;

  const PortfolioCard({
    super.key,
    required this.title,
    required this.category,
    required this.completionCount,
    required this.avgSatisfaction,
    required this.onTap,
  });

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'dovere': return AppTheme.duty;
      case 'passione': return AppTheme.passion;
      case 'energia': return AppTheme.energy;
      default: return AppTheme.primary;
    }
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'dovere': return FontAwesomeIcons.broom;
      case 'passione': return FontAwesomeIcons.guitar;
      case 'energia': return FontAwesomeIcons.bolt;
      default: return FontAwesomeIcons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getCategoryColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getCategoryIcon(), color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.rotate, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          "$completionCount volte",
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          avgSatisfaction.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: Text(
                  "SCEGLI",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

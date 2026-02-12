import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ConsultantCard extends StatelessWidget {
  final String title;
  final String reason;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final int fatigue;
  final int satisfaction;
  final VoidCallback onTap;

  const ConsultantCard({
    super.key,
    required this.title,
    required this.reason,
    required this.icon,
    required this.color,
    this.isSelected = false,
    required this.fatigue,
    required this.satisfaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100, // Fixed height for uniform dimensions
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.energia : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
               BoxShadow(
                color: AppColors.energia.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge("Fatica: $fatigue", color),
                const SizedBox(height: 6),
                _buildBadge("Soddisfazione: $satisfaction", color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

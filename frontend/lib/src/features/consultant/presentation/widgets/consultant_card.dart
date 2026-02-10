import 'package:flutter/material.dart';

class ConsultantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String reason;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ConsultantCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.reason,
    required this.icon,
    required this.color,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.2), 
            width: isSelected ? 3 : 1
          ),
          boxShadow: isSelected 
            ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 1)] 
            : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reason,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24)
            else
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }
}

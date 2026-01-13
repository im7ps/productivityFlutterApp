import 'package:flutter/material.dart';

class StatSummaryRow extends StatelessWidget {
  final String label;
  final int totalValue;
  final int delta;
  final IconData icon;

  const StatSummaryRow({
    super.key,
    required this.label,
    required this.totalValue,
    required this.delta,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Base stat is always 10 in our current logic
    const int baseValue = 10;
    final bool isPositive = delta >= 0;
    final Color deltaColor = isPositive ? Colors.green : Colors.red;
    final String sign = isPositive ? '+' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          // Visualizzazione Totale
          Text(
            '$totalValue',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
          ),
          const SizedBox(width: 8),
          // Visualizzazione Breakdown (10 + X)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: deltaColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: deltaColor.withOpacity(0.5)),
            ),
            child: Text(
              '($baseValue $sign $delta)',
              style: TextStyle(
                color: deltaColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

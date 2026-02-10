import 'package:flutter/material.dart';
import 'visual_fulfillment_selector.dart';

class DailyPulseSelector extends StatelessWidget {
  final int sleepScore;
  final int moodScore;
  final int energyScore;
  final ValueChanged<int> onSleepChanged;
  final ValueChanged<int> onMoodChanged;
  final ValueChanged<int> onEnergyChanged;

  const DailyPulseSelector({
    super.key,
    required this.sleepScore,
    required this.moodScore,
    required this.energyScore,
    required this.onSleepChanged,
    required this.onMoodChanged,
    required this.onEnergyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseRow(
            icon: Icons.bedtime_outlined,
            color: Colors.indigoAccent,
            value: sleepScore,
            onChanged: onSleepChanged,
            semanticsLabel: "Qualità del sonno",
          ),
          const SizedBox(height: 16),
          _PulseRow(
            icon: Icons.face_outlined,
            color: Colors.tealAccent,
            value: moodScore,
            onChanged: onMoodChanged,
            semanticsLabel: "Umore del giorno",
          ),
          const SizedBox(height: 16),
          _PulseRow(
            icon: Icons.bolt,
            color: Colors.amberAccent,
            value: energyScore,
            onChanged: onEnergyChanged,
            semanticsLabel: "Livello di energia",
          ),
        ],
      ),
    );
  }
}

class _PulseRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final ValueChanged<int> onChanged;
  final String semanticsLabel;

  const _PulseRow({
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: Row(
        children: [
          // 15-20% Width for Icon
          SizedBox(
            width: 48,
            child: Icon(
              icon,
              color: color.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
          // 80% Width for Selector
          Expanded(
            child: VisualFulfillmentSelector(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              // We keep it abstract, or use the same icon inside the current dot
              icon: icon, 
            ),
          ),
        ],
      ),
    );
  }
}

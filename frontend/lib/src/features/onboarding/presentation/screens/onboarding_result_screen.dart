import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/quiz_model.dart';
import '../widgets/stat_summary_row.dart';

class OnboardingResultScreen extends ConsumerWidget {
  final OnboardingResult result;

  const OnboardingResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mappa le chiavi delle stats dal backend ai nomi leggibili e icone
    // Backend keys: stat_strength, stat_endurance, stat_intelligence, stat_focus
    final statsConfig = [
      {'key': 'stat_strength', 'label': 'Forza', 'icon': Icons.fitness_center},
      {'key': 'stat_endurance', 'label': 'Resistenza', 'icon': Icons.directions_run},
      {'key': 'stat_intelligence', 'label': 'Intelligenza', 'icon': Icons.psychology},
      {'key': 'stat_focus', 'label': 'Focus', 'icon': Icons.filter_center_focus},
    ];

    // User data from result
    final user = result.user;
    final statsGained = result.statsGained;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Il tuo Personaggio'),
        automaticallyImplyLeading: false, // Prevent going back to quiz
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              "Profilo Completato!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              "Ecco le statistiche iniziali basate sulle tue abitudini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            // Stats Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: statsConfig.map((config) {
                    final key = config['key'] as String;
                    final label = config['label'] as String;
                    final icon = config['icon'] as IconData;
                    
                    // Access properties based on key
                    final int total = switch (key) {
                      'stat_strength' => user.statStrength,
                      'stat_endurance' => user.statEndurance,
                      'stat_intelligence' => user.statIntelligence,
                      'stat_focus' => user.statFocus,
                      _ => 10,
                    };
                    
                    final delta = statsGained[key] ?? 0;

                    return StatSummaryRow(
                      label: label,
                      totalValue: total,
                      delta: delta,
                      icon: icon,
                    );
                  }).toList(),
                ),
              ),
            ),

            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/'); // Navigate to Home
                },
                child: const Text("INIZIA L'AVVENTURA"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

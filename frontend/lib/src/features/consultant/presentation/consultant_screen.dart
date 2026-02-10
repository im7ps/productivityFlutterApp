import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/consultant_card.dart';
import 'consultant_providers.dart';

class ConsultantScreen extends ConsumerWidget {
  const ConsultantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIds = ref.watch(selectedMissionsProvider);

    final proposals = [
      (id: 'c1', title: "Dovere", subtitle: "Rifare il Letto", reason: "Ordine esterno = Ordine interno.", icon: FontAwesomeIcons.bed, color: AppTheme.duty),
      (id: 'c2', title: "Passione", subtitle: "Chitarra (15m)", reason: "Sei più creativo ora.", icon: FontAwesomeIcons.guitar, color: AppTheme.passion),
      (id: 'c3', title: "Energia", subtitle: "HIIT Rapido", reason: "Scarica la tensione.", icon: FontAwesomeIcons.boltLightning, color: AppTheme.energy),
      (id: 'c4', title: "Anima", subtitle: "Diario (5m)", reason: "Fissa i pensieri.", icon: FontAwesomeIcons.bookOpen, color: Colors.purple),
      (id: 'c5', title: "Relazioni", subtitle: "Chiama Mamma", reason: "Non la senti da 3gg.", icon: FontAwesomeIcons.phone, color: Colors.blue),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "MISSION BRIEFING",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Le 5 priorità tattiche rilevate per te.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  itemCount: proposals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final p = proposals[index];
                    final isSelected = selectedIds.contains(p.id);
                    return ConsultantCard(
                      title: p.title,
                      subtitle: p.subtitle,
                      reason: p.reason,
                      icon: p.icon,
                      color: p.color,
                      isSelected: isSelected,
                      onTap: () {
                        final current = ref.read(selectedMissionsProvider);
                        if (isSelected) {
                           ref.read(selectedMissionsProvider.notifier).state = {...current}..remove(p.id);
                        } else {
                           ref.read(selectedMissionsProvider.notifier).state = {...current}..add(p.id);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Bottoni Galletti in fondo
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bottone Portfolio (Libro)
                FloatingActionButton(
                  heroTag: 'portfolio',
                  onPressed: () => context.push('/portfolio'),
                  backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: CircleBorder(side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                  child: const Icon(FontAwesomeIcons.book),
                ),
                
                // Bottone Conferma (Check) con animazione Scale
                AnimatedScale(
                  scale: selectedIds.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: FloatingActionButton(
                    heroTag: 'confirm',
                    onPressed: selectedIds.isEmpty 
                      ? null 
                      : () => ref.read(missionConfirmProvider)(context),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.check_rounded, size: 32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

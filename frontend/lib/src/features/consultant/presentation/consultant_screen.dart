import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final proposalsAsyncValue = ref.watch(consultantProposalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "IL CONSULENTE",
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.grey),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: proposalsAsyncValue.when(
        data: (proposals) {
          final displayedProposals = proposals.take(5).toList();

          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                itemCount: displayedProposals.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = displayedProposals[index];
                  return SizedBox(
                    height: 100, // Forcing height here as well
                    child: ConsultantCard(
                      title: p.title,
                      reason: "Ottimale ora",
                      icon: p.icon,
                      color: p.color,
                      isSelected: selectedIds.contains(p.id),
                      fatigue: p.difficulty,
                      satisfaction: p.satisfaction,
                      onTap: () {
                        final current = ref.read(selectedMissionsProvider);
                        if (selectedIds.contains(p.id)) {
                          ref.read(selectedMissionsProvider.notifier).state =
                              {...current}..remove(p.id);
                        } else {
                          ref.read(selectedMissionsProvider.notifier).state =
                              {...current}..add(p.id);
                        }
                      },
                    ),
                  );
                },
              ),
              
              // Bottom Action Buttons
              Positioned(
                left: 24,
                right: 24,
                bottom: 40,
                child: Row(
                  children: [
                    // Portfolio Button
                    _circularActionButton(
                      onPressed: () => context.push('/portfolio'),
                      icon: Icons.library_books_rounded,
                      gradient: AppColors.primaryGradient,
                    ),
                    const SizedBox(width: 16),
                    // Refresh Proposals Button
                    _circularActionButton(
                      onPressed: () => ref.read(consultantProposalsProvider.notifier).loadProposals(),
                      icon: Icons.casino_rounded, // Dice icon for "randomize/refresh"
                      gradient: const LinearGradient(
                        colors: [AppColors.anima, AppColors.relazioni],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // AI Chat Button
                    _circularActionButton(
                      onPressed: () => context.push('/chat'),
                      icon: Icons.chat_bubble_rounded,
                      gradient: const LinearGradient(
                        colors: [AppColors.neutral, AppColors.dovere],
                      ),
                    ),
                    const Spacer(),
                    // Confirm Button (Conditional)
                    if (selectedIds.isNotEmpty)
                      _circularActionButton(
                        onPressed: () async {
                          await ref.read(missionConfirmProvider)(selectedIds);
                          if (context.mounted) context.pop();
                        },
                        icon: Icons.check_rounded,
                        gradient: const LinearGradient(
                          colors: [AppColors.energia, Color(0xFF248A3D)],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.anima)),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _circularActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

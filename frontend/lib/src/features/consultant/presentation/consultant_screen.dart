import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import 'widgets/consultant_card.dart';
import 'consultant_providers.dart';

class ConsultantScreen extends ConsumerWidget {
  const ConsultantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIds = ref.watch(selectedMissionsProvider);
    final proposalsAsyncValue = ref.watch(
      consultantProposalsProvider,
    ); // Watch the proposals provider
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.missionBriefingTitle,
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: proposalsAsyncValue.when(
        data: (proposals) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tacticalPriorities,
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
                          subtitle:
                              p.category, // Using category as subtitle for now
                          reason: "Motivazione placeholder.", // Placeholder
                          icon: p.icon,
                          color: p.color,
                          isSelected: isSelected,
                          onTap: () {
                            final current = ref.read(selectedMissionsProvider);
                            if (isSelected) {
                              ref
                                  .read(selectedMissionsProvider.notifier)
                                  .state = {...current}
                                ..remove(p.id);
                            } else {
                              ref
                                  .read(selectedMissionsProvider.notifier)
                                  .state = {...current}
                                ..add(p.id);
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
                      backgroundColor: theme.colorScheme.surface.withValues(
                        alpha: 0.8,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
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
                            : () async {
                                // Made onPressed async
                                final consumedTasks = await ref.read(
                                  missionConfirmProvider,
                                )(selectedIds); // Pass selectedIds

                                if (!context.mounted) {
                                  return; // Check if widget is still mounted
                                }

                                for (final task in consumedTasks) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.addedToArsenal(task.title),
                                      ),
                                    ),
                                  );
                                }
                                context
                                    .pop(); // Pop the screen after processing
                              },
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_controller.dart';
import 'dashboard_providers.dart';
import 'widgets/day0/rank_widget.dart';
import 'widgets/day0/checkpoint_bar.dart';
import 'widgets/day0/identity_grid.dart';

class DashboardPageContent extends ConsumerWidget {
  final CategoryInfo category;
  final Function(TaskUIModel) onTaskLongPress;
  final PageController pageController;
  final int initialPage;

  const DashboardPageContent({
    super.key,
    required this.category,
    required this.onTaskLongPress,
    required this.pageController,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksByCategoryProvider(category.id));
    final rankScore = ref.watch(rankByCategoryProvider(category.id));
    final rankLabel = ref.watch(rankLabelByCategoryProvider(category.id));
    final categories = ref.watch(availableCategoriesProvider);
    final currentCatIndex = ref.watch(currentCategoryProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          RankWidget(score: rankScore, rankLabel: rankLabel),
          const SizedBox(height: 30),
          // Category Indicators (Inside PageContent - As requested in the "beautiful" version)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(categories.length, (i) {
              final mid = categories.length ~/ 2;
              final catIndex =
                  (i - mid + categories.length) % categories.length;
              final cat = categories[catIndex];
              final isSelected = catIndex == currentCatIndex;
              final isGeneral = cat.id == 'general';

              return GestureDetector(
                onTap: () {
                  final currentPage =
                      pageController.page?.round() ?? initialPage;
                  final currentPos =
                      (currentPage - initialPage) % categories.length;
                  final positiveCurrentPos =
                      (currentPos + categories.length) % categories.length;
                  final diff = catIndex - positiveCurrentPos;

                  int targetDiff = diff;
                  if (diff.abs() > categories.length / 2) {
                    targetDiff = diff > 0
                        ? diff - categories.length
                        : diff + categories.length;
                  }

                  pageController.animateToPage(
                    currentPage + targetDiff,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.all(isGeneral ? 10 : 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cat.color.withValues(alpha: 0.2)
                        : isGeneral
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? cat.color
                          : isGeneral
                          ? Colors.white24
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Icon(
                    cat.icon,
                    size: isGeneral ? 20 : 16,
                    color: isSelected
                        ? cat.color
                        : isGeneral
                        ? Colors.white70
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          const CheckpointBar(
            progress: 0.6,
            currentBlock: "Pranzo",
            nextBlock: "Cena",
          ),
          const SizedBox(height: 20),
          // Small Consultant Button
          ElevatedButton(
            onPressed: () => context.push('/consultant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 4,
            ),
            child: const Icon(FontAwesomeIcons.boltLightning, size: 20),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.arsenalTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                PopupMenuButton<TaskSortOrder>(
                  icon: const Icon(
                    Icons.filter_list,
                    size: 20,
                    color: Colors.white70,
                  ),
                  offset: const Offset(0, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: theme.colorScheme.surface,
                  onSelected: (order) =>
                      ref.read(taskSortProvider.notifier).setSortOrder(order),
                  itemBuilder: (context) => [
                    _buildMenuItem(
                      TaskSortOrder.recommended,
                      "Consigliato",
                      Icons.auto_awesome,
                    ),
                    _buildMenuItem(
                      TaskSortOrder.effort,
                      "Per Fatica",
                      Icons.fitness_center,
                    ),
                    _buildMenuItem(
                      TaskSortOrder.satisfaction,
                      "Per Soddisfazione",
                      Icons.star,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          IdentityGrid(tasks: tasks, onTaskLongPress: onTaskLongPress),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  PopupMenuItem<TaskSortOrder> _buildMenuItem(
    TaskSortOrder value,
    String text,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late PageController _pageController;
  static const int _initialPage = 5000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showTaskDetail(BuildContext context, WidgetRef ref, TaskUIModel task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: task.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(task.icon, size: 48, color: task.color),
            const SizedBox(height: 16),
            Text(
              task.title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: task.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "CATEGORIA: ${task.category.toUpperCase()}",
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatChip(
                  context,
                  "Fatica",
                  task.difficulty.toString(),
                  Icons.fitness_center,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  context,
                  "Soddisfazione",
                  task.satisfaction.toString(),
                  Icons.star,
                ),
              ],
            ),
            const SizedBox(height: 32), // Spazio finale senza bottoni
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            "$label: $value",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(availableCategoriesProvider);
    final currentCatIndex = ref.watch(currentCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categories.isEmpty ? "" : categories[currentCatIndex].label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.boltLightning,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "DAY 0",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text("Impostazioni"),
              onTap: () {
                context.pop(); // Chiude il drawer
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_rounded),
              title: const Text("Ordina Categorie"),
              onTap: () {
                context.pop(); // Chiude il drawer
                context.push('/categories');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Esci",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                context.pop(); // Chiude il drawer
                ref.read(authControllerProvider.notifier).logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          if (categories.isEmpty) return;
          final normalizedIndex = (index - _initialPage) % categories.length;
          final positiveIndex =
              (normalizedIndex + categories.length) % categories.length;
          ref.read(currentCategoryProvider.notifier).setIndex(positiveIndex);
        },
        itemBuilder: (context, index) {
          if (categories.isEmpty) return const SizedBox.shrink();
          final normalizedIndex = (index - _initialPage) % categories.length;
          final positiveIndex =
              (normalizedIndex + categories.length) % categories.length;
          final category = categories[positiveIndex];

          return DashboardPageContent(
            category: category,
            onTaskLongPress: (task) => _showTaskDetail(context, ref, task),
            pageController: _pageController,
            initialPage: _initialPage,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import 'action_providers.dart'; // Import allTasksProvider

import 'widgets/portfolio_card.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  String _selectedFilter = 'Tutti';
  final List<String> _filters = [
    'Tutti',
    'Passione',
    'Dovere',
    'Energia',
    'Relazioni',
    'Anima',
  ];

  final List<IconData> _availableIcons = const [
    // Add this list
    FontAwesomeIcons.guitar,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.book,
    FontAwesomeIcons.phone,
    FontAwesomeIcons.laptopCode,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.featherPointed,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.seedling,
  ];

  void _showTaskDetail(
    String title,
    String category,
    int difficulty,
    int satisfaction,
    IconData icon,
    Color color,
    String taskId, // Add taskId for deletion
    WidgetRef ref, // Add ref to access Riverpod providers
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      Navigator.pop(context); // Dismiss detail modal
                      // Call _showCreateTaskModal for editing
                      _showCreateTaskModal(
                        task: TaskUIModel(
                          id: taskId,
                          title: title,
                          category: category,
                          difficulty: difficulty,
                          satisfaction: satisfaction,
                          icon: icon,
                          color: color,
                          isCompleted:
                              false, // Assuming edit doesn't change completion status for now
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text("Conferma Eliminazione"),
                            content: Text(
                              "Sei sicuro di voler eliminare la missione '$title'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(
                                  dialogContext,
                                ).pop(), // Dismiss dialog
                                child: const Text("Annulla"),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(allTasksProvider.notifier)
                                      .removeTask(taskId);
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(); // Dismiss confirmation dialog
                                  Navigator.pop(
                                    context,
                                  ); // Dismiss detail modal
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Missione '$title' eliminata!",
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Elimina",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Categoria: $category",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatChip(
                  "Fatica",
                  difficulty.toString(),
                  Icons.fitness_center,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  "Soddisfazione",
                  satisfaction.toString(),
                  Icons.star,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final newTask = TaskUIModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    icon: icon,
                    color: color,
                    difficulty: difficulty,
                    satisfaction: satisfaction,
                    category: category,
                    isCompleted: false,
                  );

                  ref.read(taskListProvider.notifier).addTasks([newTask]);

                  Navigator.pop(context);
                  context.go('/');

                  ScaffoldMessenger.of(
                    context,
                  ).hideCurrentSnackBar(); // Hide any existing snackbars
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Missione '$title' aggiunta all'arsenale!"),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("AGGIUNGI ALLA GIORNATA"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            "$label: $value",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskModal({TaskUIModel? task}) {
    // Modified signature
    String newTitle = task?.title ?? ""; // Pre-fill
    String newCategory = task?.category ?? "Dovere"; // Pre-fill
    double newDifficulty = (task?.difficulty ?? 3).toDouble(); // Pre-fill
    double newSatisfaction = (task?.satisfaction ?? 3).toDouble(); // Pre-fill
    bool showTitleError = false;
    IconData selectedIcon =
        task?.icon ?? FontAwesomeIcons.circle; // Pre-fill or default

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task != null
                        ? "MODIFICA MISSIONE"
                        : "NUOVA MISSIONE", // Dynamic title
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    autofocus: true,
                    controller: TextEditingController(text: newTitle)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: newTitle.length),
                      ), // Pre-fill and set cursor
                    decoration: InputDecoration(
                      labelText: "TITOLO",
                      hintText: "Es. Leggere 10 pagine",
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white10,
                      errorText: showTitleError
                          ? "Il titolo non può essere vuoto."
                          : null,
                    ),
                    onChanged: (val) {
                      setStateModal(() {
                        newTitle = val;
                        if (showTitleError && val.isNotEmpty) {
                          showTitleError = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Icon Selection GridView
                  Text("ICONA", style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 8),
                  SizedBox(
                    // Constrain height for the GridView
                    height: 80, // Adjust as needed
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, // Single row
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _availableIcons.length,
                      itemBuilder: (context, index) {
                        final icon = _availableIcons[index];
                        return GestureDetector(
                          onTap: () {
                            setStateModal(() {
                              selectedIcon = icon;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIcon == icon
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withValues(alpha: 0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedIcon == icon
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white10,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: selectedIcon == icon
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "CATEGORIA",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                          "Dovere",
                          "Passione",
                          "Energia",
                          "Anima",
                          "Relazioni",
                        ].map((cat) {
                          final isSelected = newCategory == cat;
                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat),
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Icon(Icons.check, size: 16.0),
                                  )
                                else
                                  const SizedBox(
                                    width: 20.0,
                                  ), // Reserve space even when not selected
                              ],
                            ),
                            selected: isSelected,
                            showCheckmark:
                                false, // Explicitly disable default checkmark
                            onSelected: (sel) {
                              if (sel) setStateModal(() => newCategory = cat);
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSliderRow(
                    "FATICA",
                    newDifficulty,
                    (val) => setStateModal(() => newDifficulty = val),
                  ),
                  const SizedBox(height: 16),
                  _buildSliderRow(
                    "SODDISFAZIONE",
                    newSatisfaction,
                    (val) => setStateModal(() => newSatisfaction = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (newTitle.isEmpty) {
                          setStateModal(() {
                            showTitleError = true;
                          });
                          return;
                        }

                        final newTask = TaskUIModel(
                          id:
                              task?.id ??
                              DateTime.now().millisecondsSinceEpoch
                                  .toString(), // Preserve ID if editing
                          title: newTitle,
                          icon: selectedIcon, // Use selected icon
                          color:
                              Colors.grey, // Sarà calcolato dal provider o qui
                          difficulty: newDifficulty.round(),
                          satisfaction: newSatisfaction.round(),
                          category: newCategory,
                          isCompleted:
                              task?.isCompleted ??
                              false, // Preserve isCompleted if editing
                        );

                        if (task != null) {
                          // Editing existing task
                          ref
                              .read(allTasksProvider.notifier)
                              .updateTask(newTask);
                        } else {
                          // Creating new task
                          ref.read(allTasksProvider.notifier).addTask(newTask);
                        }

                        Navigator.pop(context);
                        context.go('/');

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Missione '$newTitle' ${task != null ? 'modificata!' : 'forgiata!'}",
                            ), // Dynamic message
                          ),
                        );
                      },
                      icon: Icon(
                        task != null ? Icons.save : Icons.add,
                      ), // Dynamic icon
                      label: Text(
                        task != null ? "SALVA MODIFICHE" : "CREA E AGGIUNGI",
                      ), // Dynamic label
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              value.round().toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allTasks = ref.watch(allTasksProvider); // Watch allTasksProvider

    final filteredTasks = _selectedFilter == 'Tutti'
        ? allTasks
        : allTasks.where((t) => t.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          // Allows Scaffold.of(context) to find the Scaffold
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "PORTFOLIO",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                _showCreateTaskModal(), // Call without a task to create new
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Portfolio'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                context.go(
                  '/portfolio',
                ); // Navigate to Portfolio (current screen)
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Impostazioni'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // TODO: Navigate to Account
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info (Onboarding)'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // TODO: Navigate to Onboarding info
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_help),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // TODO: Navigate to FAQ
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Esci dall\'app'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // TODO: Implement logout logic
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                  labelStyle: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.white : null,
                  ),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final t = filteredTasks[index];
                return PortfolioCard(
                  title: t.title,
                  category: t.category,
                  completionCount:
                      0, // Placeholder, as TaskUIModel doesn't have 'count' yet
                  avgSatisfaction: t.satisfaction
                      .toDouble(), // Use TaskUIModel's satisfaction
                  onTap: () => _showTaskDetail(
                    t.title,
                    t.category,
                    t.difficulty, // Use actual difficulty
                    t.satisfaction, // Use actual satisfaction
                    t.icon,
                    t.color,
                    t.id, // Pass taskId
                    ref, // Pass ref
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

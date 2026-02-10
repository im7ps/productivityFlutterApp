import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import 'widgets/portfolio_card.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  String _selectedFilter = 'Tutti';
  final List<String> _filters = ['Tutti', 'Passione', 'Dovere', 'Energia', 'Relazioni', 'Anima'];

  void _showTaskDetail(String title, String category, int difficulty, int satisfaction, IconData icon, Color color) {
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
                _buildStatChip("Fatica", difficulty.toString(), Icons.fitness_center),
                const SizedBox(width: 12),
                _buildStatChip("Soddisfazione", satisfaction.toString(), Icons.star),
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
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Missione '$title' aggiunta all'arsenale!")),
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
          Text("$label: $value", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showCreateTaskModal() {
    String newTitle = "";
    String newCategory = "Dovere";
    double newDifficulty = 3.0;
    double newSatisfaction = 3.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NUOVA MISSIONE", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "TITOLO",
                  hintText: "Es. Leggere 10 pagine",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                onChanged: (val) => newTitle = val,
              ),
              const SizedBox(height: 24),
              Text("CATEGORIA", style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ["Dovere", "Passione", "Energia", "Anima", "Relazioni"].map((cat) {
                  final isSelected = newCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (sel) {
                      if (sel) setStateModal(() => newCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              _buildSliderRow("FATICA", newDifficulty, (val) => setStateModal(() => newDifficulty = val)),
              const SizedBox(height: 16),
              _buildSliderRow("SODDISFAZIONE", newSatisfaction, (val) => setStateModal(() => newSatisfaction = val)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (newTitle.isEmpty) return;
                    
                    final newTask = TaskUIModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: newTitle,
                      icon: FontAwesomeIcons.circle, // Default
                      color: Colors.grey, // Sarà calcolato dal provider o qui
                      difficulty: newDifficulty.round(),
                      satisfaction: newSatisfaction.round(),
                      category: newCategory,
                      isCompleted: false,
                    );
                    
                    // Invia al provider
                    ref.read(taskListProvider.notifier).addTasks([newTask]);
                    
                    Navigator.pop(context);
                    context.go('/');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Missione '$newTitle' forgiata!")),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("CREA E AGGIUNGI"),
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
    );
  }

  Widget _buildSliderRow(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(value.round().toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
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

    final allTasks = [
      (title: "Suonare Chitarra", category: "Passione", count: 42, sat: 4.8, diff: 2, icon: FontAwesomeIcons.guitar, color: Colors.green),
      (title: "Pulire Scrivania", category: "Dovere", count: 15, sat: 3.5, diff: 3, icon: FontAwesomeIcons.broom, color: Colors.red),
      (title: "Corsa 5km", category: "Energia", count: 8, sat: 4.9, diff: 5, icon: FontAwesomeIcons.personRunning, color: Colors.orange),
      (title: "Meditazione", category: "Energia", count: 20, sat: 4.2, diff: 1, icon: FontAwesomeIcons.brain, color: Colors.orange),
      (title: "Pagare Bollette", category: "Dovere", count: 3, sat: 2.1, diff: 2, icon: FontAwesomeIcons.fileInvoiceDollar, color: Colors.red),
      (title: "Chiamata Amico", category: "Relazioni", count: 12, sat: 4.5, diff: 1, icon: FontAwesomeIcons.phone, color: Colors.blue),
    ];

    final filteredTasks = _selectedFilter == 'Tutti' 
        ? allTasks 
        : allTasks.where((t) => t.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PORTFOLIO",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateTaskModal,
          ),
        ],
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : null,
                  ),
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  completionCount: t.count,
                  avgSatisfaction: t.sat,
                  onTap: () => _showTaskDetail(t.title, t.category, t.diff, t.sat.toInt(), t.icon, t.color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

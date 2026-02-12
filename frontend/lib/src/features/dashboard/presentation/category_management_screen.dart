import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_providers.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(availableCategoriesProvider);
    final theme = Theme.of(context);

    // Filter out 'general' from the reorderable list as it should stay fixed at 0
    final reorderableCategories = categories
        .where((c) => c.id != 'general')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ORDINA CATEGORIE",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Trascina le categorie per cambiare l'ordine di visualizzazione nella Home.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
          // Fixed General Category
          ListTile(
            leading: const Icon(Icons.dashboard_rounded, color: Colors.white54),
            title: const Text("GENERALI (FISSO)"),
            trailing: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Colors.white24,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: reorderableCategories.length,
              onReorder: (oldIndex, newIndex) {
                // Adjust for the fact that we are only reordering a sublist
                // In the full list, these items start from index 1
                final fullOldIndex = oldIndex + 1;
                final fullNewIndex = newIndex + 1;

                final currentOrder = categories.map((c) => c.id).toList();
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final String item = currentOrder.removeAt(fullOldIndex);
                currentOrder.insert(
                  fullNewIndex - (fullOldIndex < fullNewIndex ? 0 : 0),
                  item,
                );

                // We need to handle the newIndex correctly after item removal
                // Simpler: calculate the new full order and update
                final List<String> newOrder = List.from(
                  categories.map((c) => c.id),
                );
                final String movedId = newOrder.removeAt(fullOldIndex);

                // If moving down, the removal shifted everything up
                if (oldIndex < newIndex) {
                  // Insertion index is already correct due to how ReorderableListView works with newIndex
                }

                newOrder.insert(newIndex + 1, movedId);
                ref.read(categoryOrderProvider.notifier).updateOrder(newOrder);
              },
              itemBuilder: (context, index) {
                final cat = reorderableCategories[index];
                return ListTile(
                  key: ValueKey(cat.id),
                  leading: Icon(cat.icon, color: cat.color),
                  title: Text(cat.label),
                  trailing: const Icon(
                    Icons.drag_handle_rounded,
                    color: Colors.white24,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../dashboard/dashboard_providers_mock.dart';
import '../../dashboard/presentation/dashboard_providers_mock.dart';
// import '../../consultant/presentation/consultant_screen.dart'; // Importa per evitare errori se necessario, ma qui definisco logica

// Provider per gestire la selezione delle missioni nel Consulente
final selectedMissionsProvider = StateProvider.autoDispose<Set<String>>(
  (ref) => {},
);

// Logica per confermare e aggiungere alla home
final missionConfirmProvider = Provider((ref) {
  return (BuildContext context) {
    final selectedIds = ref.read(selectedMissionsProvider);
    // In un'app reale qui recupereremmo le task complete dal repository
    // Per ora creiamo task mock basate sugli ID selezionati
    // Simuliamo il recupero da un "database"
    final allProposals = [
      TaskUIModel(
        id: 'c1',
        title: 'Rifare il Letto',
        icon: Icons.bed,
        color: Colors.red,
        difficulty: 1,
        satisfaction: 3,
        category: 'Dovere',
      ),
      TaskUIModel(
        id: 'c2',
        title: 'Chitarra (15m)',
        icon: Icons.music_note,
        color: Colors.green,
        difficulty: 2,
        satisfaction: 5,
        category: 'Passione',
      ),
      TaskUIModel(
        id: 'c3',
        title: 'HIIT (10m)',
        icon: Icons.bolt,
        color: Colors.orange,
        difficulty: 4,
        satisfaction: 4,
        category: 'Energia',
      ),
      TaskUIModel(
        id: 'c4',
        title: 'Diario (5m)',
        icon: Icons.book,
        color: Colors.purple,
        difficulty: 1,
        satisfaction: 4,
        category: 'Anima',
      ),
      TaskUIModel(
        id: 'c5',
        title: 'Chiama Mamma',
        icon: Icons.phone,
        color: Colors.blue,
        difficulty: 2,
        satisfaction: 5,
        category: 'Relazioni',
      ),
    ];

    final newTasks = allProposals
        .where((t) => selectedIds.contains(t.id))
        .toList();

    ref.read(taskListProvider.notifier).addTasks(newTasks);
    // Reset selezione e naviga indietro
    ref.invalidate(selectedMissionsProvider);
    Navigator.pop(context);
  };
});

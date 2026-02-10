import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../dashboard/presentation/dashboard_providers.dart';

// Provider per gestire la selezione delle missioni nel Consulente
final selectedMissionsProvider = StateProvider.autoDispose<Set<String>>((ref) => {});

// Logica per confermare e aggiungere alla home
final missionConfirmProvider = Provider((ref) {
  return (BuildContext context) {
    final selectedIds = ref.read(selectedMissionsProvider);
    
    // Lista proposte fissa (simula DB di consigli)
    final allProposals = [
       TaskUIModel(id: 'c1', title: 'Rifare il Letto', icon: FontAwesomeIcons.bed, color: Colors.red, difficulty: 1, satisfaction: 3, category: 'Dovere'),
       TaskUIModel(id: 'c2', title: 'Chitarra (15m)', icon: FontAwesomeIcons.guitar, color: Colors.green, difficulty: 2, satisfaction: 5, category: 'Passione'),
       TaskUIModel(id: 'c3', title: 'HIIT (10m)', icon: FontAwesomeIcons.bolt, color: Colors.orange, difficulty: 4, satisfaction: 4, category: 'Energia'),
       TaskUIModel(id: 'c4', title: 'Diario (5m)', icon: FontAwesomeIcons.bookOpen, color: Colors.purple, difficulty: 1, satisfaction: 4, category: 'Anima'),
       TaskUIModel(id: 'c5', title: 'Chiama Mamma', icon: FontAwesomeIcons.phone, color: Colors.blue, difficulty: 2, satisfaction: 5, category: 'Relazioni'),
    ];

    final newTasks = allProposals.where((t) => selectedIds.contains(t.id)).toList();
    
    ref.read(taskListProvider.notifier).addTasks(newTasks);
    
    ref.invalidate(selectedMissionsProvider);
    Navigator.pop(context);
  };
});

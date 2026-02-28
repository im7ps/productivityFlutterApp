import 'package:flutter/material.dart';

enum ActionCategory {
  // Energy (Physical/Health)
  run('Corsa', Icons.directions_run),
  gym('Palestra', Icons.fitness_center),
  walk('Camminata', Icons.directions_walk),
  sport('Sport', Icons.sports_basketball),
  sleep('Sonno', Icons.bedtime),
  eat('Cibo Sano', Icons.restaurant),
  water('Acqua', Icons.local_drink),
  
  // Clarity (Focus/Work)
  work('Lavoro', Icons.work),
  focus('Deep Work', Icons.psychology),
  plan('Planning', Icons.calendar_month),
  read('Lettura', Icons.menu_book),
  learn('Studio', Icons.school),
  write('Scrittura', Icons.edit),
  
  // Relationships (Social)
  family('Famiglia', Icons.family_restroom),
  friends('Amici', Icons.groups),
  partner('Partner', Icons.favorite),
  call('Chiamata', Icons.call),
  event('Evento', Icons.celebration),
  help('Aiuto', Icons.volunteer_activism),
  
  // Soul (Spirit/Self)
  meditate('Meditazione', Icons.self_improvement),
  journal('Journaling', Icons.book),
  nature('Natura', Icons.park),
  art('Creatività', Icons.palette),
  music('Musica', Icons.music_note),
  gratitude('Gratitudine', Icons.handshake);

  final String label;
  final IconData icon;

  const ActionCategory(this.label, this.icon);

  static List<ActionCategory> getByDimension(String dimensionId) {
    switch (dimensionId.toLowerCase()) {
      case 'energia':
        return [run, gym, walk, sport, sleep, eat, water];
      case 'chiarezza':
        return [work, focus, plan, read, learn, write];
      case 'relazioni':
        return [family, friends, partner, call, event, help];
      case 'anima':
        return [meditate, journal, nature, art, music, gratitude];
      default:
        return values; // Fallback: all
    }
  }

  static ActionCategory fromLabel(String? label) {
    if (label == null) return work; // Default fallback
    try {
      return values.firstWhere(
        (e) => e.label.toLowerCase() == label.toLowerCase() || 
               e.name.toLowerCase() == label.toLowerCase()
      );
    } catch (_) {
      // Robust Fallback for unknown labels from backend
      return work; 
    }
  }
  
  // Helper to check if a label is known, useful for UI logic
  static bool isKnown(String? label) {
     if (label == null) return false;
     return values.any((e) => e.label.toLowerCase() == label.toLowerCase() || e.name.toLowerCase() == label.toLowerCase());
  }
}

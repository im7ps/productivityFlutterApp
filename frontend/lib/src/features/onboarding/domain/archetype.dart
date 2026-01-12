class Archetype {
  final String id;
  final String title;
  final String description;
  final String iconName; // Useremo icone standard per ora
  final Map<String, int> stats;

  const Archetype({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.stats,
  });
}

// Mock Data statici
const List<Archetype> availableArchetypes = [
  Archetype(
    id: 'sportivo',
    title: 'Lo Sportivo',
    description: 'Mens sana in corpore sano.\nLa tua forza risiede nell\'azione e nella resistenza fisica.',
    iconName: 'fitness_center',
    stats: {
      'stat_strength': 15,
      'stat_endurance': 15,
      'stat_intelligence': 5,
      'stat_focus': 5,
    },
  ),
  Archetype(
    id: 'studioso',
    title: 'Lo Studioso',
    description: 'La conoscenza è potere.\nAnalizzi il mondo con logica e concentrazione incrollabile.',
    iconName: 'school',
    stats: {
      'stat_strength': 5,
      'stat_endurance': 5,
      'stat_intelligence': 15,
      'stat_focus': 15,
    },
  ),
];

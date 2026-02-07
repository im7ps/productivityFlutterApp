import 'package:freezed_annotation/freezed_annotation.dart';

part 'dimension.freezed.dart';
part 'dimension.g.dart';

@freezed
class Dimension with _$Dimension {
  const factory Dimension({
    required String id,
    required String name,
    required String description,
    required String iconPath, // Or use IconData if preferred, but string is safer for JSON
  }) = _Dimension;

  factory Dimension.fromJson(Map<String, dynamic> json) => _$DimensionFromJson(json);

  static const body = Dimension(
    id: 'body',
    name: 'Corpo',
    description: 'Il tempio che ti permette di agire.',
    iconPath: 'assets/icons/body.svg',
  );

  static const mind = Dimension(
    id: 'mind',
    name: 'Mente',
    description: 'La chiarezza e la concentrazione.',
    iconPath: 'assets/icons/mind.svg',
  );

  static const emotions = Dimension(
    id: 'emotions',
    name: 'Emozioni',
    description: 'Il colore della tua giornata.',
    iconPath: 'assets/icons/emotions.svg',
  );

  static const spirit = Dimension(
    id: 'spirit',
    name: 'Spirito',
    description: 'Il perché profondo dietro ogni azione.',
    iconPath: 'assets/icons/spirit.svg',
  );

  static const all = [body, mind, emotions, spirit];
}

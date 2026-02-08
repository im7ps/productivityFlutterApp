import 'package:flutter/material.dart';

class AppTheme {
  // Colori "Bussola Emotiva"
  static const Color primaryDark = Color(0xFF1E1E2C);
  static const Color accentTeal = Color(0xFF64FFDA);
  static const Color surfaceDark = Color(0xFF2D2D44);
  static const Color textWhite = Colors.white;
  static const Color textDim = Colors.white70;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentTeal,
        brightness: Brightness.dark,
        surface: surfaceDark,
      ),
      textTheme: const TextTheme(
        // Per i titoli dell'onboarding e sezioni principali
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textWhite,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w300,
          color: textWhite,
          height: 1.4,
          letterSpacing: 0.2,
        ),
        // Per il corpo del testo cinematografico
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: textDim,
          height: 1.6,
        ),
        // Per i bottoni e label
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: textWhite,
        ),
      ),
    );
  }
}

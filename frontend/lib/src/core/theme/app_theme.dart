import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette "Giorno 0"
  static const Color background = Color(0xFF0F0F12);
  static const Color surface = Color(0xFF1C1C21);
  static const Color primary = Color(0xFF6366F1); // Indigo energico

  // Colori delle Dimensioni
  static const Color duty = Color(0xFFEF4444); // Rosso (Dovere)
  static const Color passion = Color(0xFF10B981); // Smeraldo (Passione)
  static const Color energy = Color(0xFFF59E0B); // Ambra (Energia)

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        onSurface: textPrimary,
        secondary: passion,
      ),
      textTheme:
          GoogleFonts.interTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
              ),
              headlineMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                color: textSecondary,
                height: 1.5,
              ),
            ),
          ).copyWith(
            // Font speciale per il Rank e i numeri
            displayMedium: GoogleFonts.bebasNeue(
              fontSize: 84,
              color: primary,
              letterSpacing: 4,
            ),
          ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}

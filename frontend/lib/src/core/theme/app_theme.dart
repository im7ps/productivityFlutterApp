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

  static ThemeData get lightTheme {
    const Color lightBackground = Color(0xFFF0F2F5); // Light background
    const Color lightSurface = Color(0xFFFFFFFF);    // Lighter surface
    const Color lightTextPrimary = Color(0xFF1F2937); // Dark text
    const Color lightTextSecondary = Color(0xFF4B5563); // Slightly lighter dark text

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        secondary: passion, // Keep consistent
      ),
      textTheme:
          GoogleFonts.interTextTheme(
            TextTheme( // Use TextTheme without const because colors are dynamic
              displayLarge: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                color: lightTextPrimary, // Adjust for light mode
              ),
              headlineMedium: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: lightTextPrimary, // Adjust for light mode
              ),
              bodyLarge: const TextStyle(
                fontSize: 16,
                color: lightTextSecondary, // Adjust for light mode
                height: 1.5,
              ),
            ),
          ).copyWith(
            displayMedium: GoogleFonts.bebasNeue(
              fontSize: 84,
              color: primary, // Primary color can be consistent
              letterSpacing: 4,
            ),
          ),
      cardTheme: CardThemeData(
        color: lightSurface, // Adjust for light mode
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Or lightSurface
        elevation: 0,
        centerTitle: false,
        // For light mode, AppBar title and icon colors might need to be dark
        iconTheme: IconThemeData(color: lightTextPrimary),
        actionsIconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(color: lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

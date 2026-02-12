import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Global Aesthetic Directives
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF8E8E93);

  // Category-Specific Accents
  static const Color dovere = Color(0xFF5E5CE6);
  static const Color passione = Color(0xFFFF453A);
  static const Color energia = Color(0xFF32D74B);
  static const Color anima = Color(0xFFBF5AF2);
  static const Color relazioni = Color(0xFFFF9F0A);
  static const Color neutral = Color(0xFF64D2FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [dovere, anima],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient rankGradient = RadialGradient(
    colors: [dovere, anima],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.dovere,
        surface: AppColors.surface,
        onSurface: AppColors.white,
        secondary: AppColors.anima,
        surfaceContainer: AppColors.background,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: AppColors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: AppColors.grey,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
      ).apply(bodyColor: AppColors.white, displayColor: AppColors.white),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.anima,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      colorScheme: const ColorScheme.light(
        primary: AppColors.dovere,
        surface: Colors.white,
        onSurface: Colors.black,
        secondary: AppColors.anima,
        surfaceContainer: Color(0xFFF2F2F7),
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ).apply(bodyColor: Colors.black, displayColor: Colors.black),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.anima,
        unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}

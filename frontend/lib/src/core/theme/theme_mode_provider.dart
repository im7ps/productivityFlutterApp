import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whativedone/src/core/storage/local_storage_service.dart';

// Key for storing theme preference in local storage
const _themeModeKey = 'themeMode';

// Enum to represent the theme choices
enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeExtension on AppThemeMode {
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  final LocalStorageService _localStorageService;

  ThemeModeNotifier(this._localStorageService) : super(AppThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final storedMode = await _localStorageService.getString(_themeModeKey);
    state = _stringToAppThemeMode(storedMode);
  }

  Future<void> setThemeMode(AppThemeMode newMode) async {
    state = newMode;
    await _localStorageService.setString(_themeModeKey, newMode.name);
  }

  AppThemeMode _stringToAppThemeMode(String? modeString) {
    if (modeString == null) return AppThemeMode.system;
    try {
      return AppThemeMode.values.firstWhere((e) => e.name == modeString);
    } catch (e) {
      return AppThemeMode.system; // Fallback
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) {
    final localStorageService = ref.watch(localStorageServiceProvider);
    return ThemeModeNotifier(localStorageService);
  },
);


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

/// Clés de stockage
const String _themeModeKey = 'theme_mode';
const String _appThemeTypeKey = 'app_theme_type';

/// Provider pour le mode de thème
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Notifier pour gérer le mode de thème
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Charge le mode de thème sauvegardé
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_themeModeKey);
      if (themeModeIndex != null && themeModeIndex < ThemeMode.values.length) {
        state = ThemeMode.values[themeModeIndex];
      }
    } catch (e) {
      debugPrint('[THEME] Error loading theme mode: $e');
    }
  }

  /// Change le mode de thème
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, mode.index);
      debugPrint('[THEME] Theme mode set to: $mode');
    } catch (e) {
      debugPrint('[THEME] Error saving theme mode: $e');
    }
  }

  /// Bascule entre les modes clair et sombre
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

/// Extension pour obtenir le label du mode de thème
extension ThemeModeExtension on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.system:
        return 'Automatique';
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

// ============================================
// PROVIDER POUR LE THÈME DE COULEURS
// ============================================

/// Provider pour le type de thème (palette de couleurs)
final appThemeTypeProvider =
    StateNotifierProvider<AppThemeTypeNotifier, AppThemeType>((ref) {
  return AppThemeTypeNotifier();
});

/// Notifier pour gérer le type de thème
class AppThemeTypeNotifier extends StateNotifier<AppThemeType> {
  AppThemeTypeNotifier() : super(AppThemeType.classique) {
    _loadThemeType();
  }

  /// Charge le type de thème sauvegardé
  Future<void> _loadThemeType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeTypeName = prefs.getString(_appThemeTypeKey);
      if (themeTypeName != null) {
        final themeType = AppThemeType.values.firstWhere(
          (t) => t.name == themeTypeName,
          orElse: () => AppThemeType.classique,
        );
        state = themeType;
      }
    } catch (e) {
      debugPrint('[THEME] Error loading theme type: $e');
    }
  }

  /// Change le type de thème
  Future<void> setThemeType(AppThemeType type) async {
    state = type;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_appThemeTypeKey, type.name);
      debugPrint('[THEME] Theme type set to: ${type.label}');
    } catch (e) {
      debugPrint('[THEME] Error saving theme type: $e');
    }
  }
}

/// Provider pour la luminosité de la plateforme (doit être mis à jour depuis le widget racine)
final platformBrightnessProvider = StateProvider<Brightness>((ref) {
  return Brightness.light;
});

/// Provider pour la luminosité résolue (prend en compte le mode thème et la luminosité plateforme)
final resolvedBrightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final platformBrightness = ref.watch(platformBrightnessProvider);

  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      return platformBrightness;
  }
});

/// Provider pour savoir si on est en mode sombre
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(resolvedBrightnessProvider) == Brightness.dark;
});

/// Provider pour la palette de couleurs actuelle (avec support dark mode automatique)
final currentPaletteProvider = Provider<AppColorPalette>((ref) {
  final themeType = ref.watch(appThemeTypeProvider);
  final brightness = ref.watch(resolvedBrightnessProvider);

  return AppThemes.getPaletteForBrightness(themeType, brightness);
});

/// Provider pour le ThemeData Flutter actuel
final appThemeDataProvider = Provider<ThemeData>((ref) {
  final palette = ref.watch(currentPaletteProvider);
  return AppThemes.generateThemeData(palette);
});

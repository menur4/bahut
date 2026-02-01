import 'package:flutter/material.dart';

/// Thèmes disponibles dans l'application
enum AppThemeType {
  classique('Classique', 'Bleu iOS élégant', Icons.phone_iphone),
  ocean('Océan', 'Bleu profond apaisant', Icons.water),
  foret('Forêt', 'Vert nature relaxant', Icons.park),
  sunset('Coucher de soleil', 'Orange chaleureux', Icons.wb_twilight),
  lavande('Lavande', 'Violet doux et moderne', Icons.local_florist),
  rose('Rose', 'Rose tendre et accueillant', Icons.favorite),
  minuit('Minuit', 'Sombre avec accent bleu', Icons.nightlight_round);

  final String label;
  final String description;
  final IconData icon;

  const AppThemeType(this.label, this.description, this.icon);
}

/// Palette de couleurs pour un thème
class AppColorPalette {
  // Couleurs principales
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color accent;

  // Couleurs sémantiques
  final Color success;
  final Color successLight;
  final Color error;
  final Color errorLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;

  // Couleurs de texte
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;
  final Color textInverse;

  // Couleurs de fond
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;
  final Color backgroundCard;

  // Couleurs de bordure
  final Color borderLight;
  final Color borderMedium;
  final Color borderDark;

  // Mode sombre ?
  final bool isDark;

  const AppColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.successLight,
    required this.error,
    required this.errorLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.textInverse,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.backgroundCard,
    required this.borderLight,
    required this.borderMedium,
    required this.borderDark,
    this.isDark = false,
  });

  /// Couleur pour une note selon sa valeur
  Color gradeColor(double grade, {double maxGrade = 20}) {
    final percentage = grade / maxGrade;
    if (percentage >= 0.8) return success; // >= 16/20 - Excellent
    if (percentage >= 0.6) return info; // >= 12/20 - Bien
    if (percentage >= 0.5) return warning; // >= 10/20 - Passable
    return error; // < 10/20 - Insuffisant
  }
}

/// Collection de tous les thèmes disponibles
class AppThemes {
  AppThemes._();

  // ============================================
  // THÈME CLASSIQUE (Bleu iOS)
  // ============================================
  static const classique = AppColorPalette(
    // Couleurs principales - Bleu iOS système
    primary: Color(0xFF007AFF),
    primaryLight: Color(0xFF5AC8FA),
    primaryDark: Color(0xFF0051A8),
    secondary: Color(0xFF5856D6),
    accent: Color(0xFFFF9500),

    // Sémantiques iOS
    success: Color(0xFF34C759),
    successLight: Color(0xFFE8F9ED),
    error: Color(0xFFFF3B30),
    errorLight: Color(0xFFFFEBEA),
    warning: Color(0xFFFF9500),
    warningLight: Color(0xFFFFF4E5),
    info: Color(0xFF007AFF),
    infoLight: Color(0xFFE5F1FF),

    // Texte
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF3C3C43),
    textTertiary: Color(0xFF8E8E93),
    textMuted: Color(0xFFC7C7CC),
    textInverse: Color(0xFFFFFFFF),

    // Fonds iOS
    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF2F2F7),
    backgroundTertiary: Color(0xFFE5E5EA),
    backgroundCard: Color(0xFFFFFFFF),

    // Bordures
    borderLight: Color(0xFFE5E5EA),
    borderMedium: Color(0xFFC7C7CC),
    borderDark: Color(0xFF8E8E93),
  );

  // ============================================
  // THÈME OCÉAN (Bleu profond)
  // ============================================
  static const ocean = AppColorPalette(
    primary: Color(0xFF0077B6),
    primaryLight: Color(0xFF00B4D8),
    primaryDark: Color(0xFF03045E),
    secondary: Color(0xFF0096C7),
    accent: Color(0xFF48CAE4),

    success: Color(0xFF06D6A0),
    successLight: Color(0xFFE6FAF5),
    error: Color(0xFFEF476F),
    errorLight: Color(0xFFFDE8ED),
    warning: Color(0xFFFFD166),
    warningLight: Color(0xFFFFF8E6),
    info: Color(0xFF118AB2),
    infoLight: Color(0xFFE7F4F8),

    textPrimary: Color(0xFF03045E),
    textSecondary: Color(0xFF023E8A),
    textTertiary: Color(0xFF0077B6),
    textMuted: Color(0xFF90E0EF),
    textInverse: Color(0xFFFFFFFF),

    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF0F9FF),
    backgroundTertiary: Color(0xFFCAF0F8),
    backgroundCard: Color(0xFFFFFFFF),

    borderLight: Color(0xFFCAF0F8),
    borderMedium: Color(0xFF90E0EF),
    borderDark: Color(0xFF48CAE4),
  );

  // ============================================
  // THÈME FORÊT (Vert nature)
  // ============================================
  static const foret = AppColorPalette(
    primary: Color(0xFF2D6A4F),
    primaryLight: Color(0xFF40916C),
    primaryDark: Color(0xFF1B4332),
    secondary: Color(0xFF52B788),
    accent: Color(0xFF95D5B2),

    success: Color(0xFF74C69D),
    successLight: Color(0xFFE9F5EF),
    error: Color(0xFFD62828),
    errorLight: Color(0xFFFBE9E9),
    warning: Color(0xFFF77F00),
    warningLight: Color(0xFFFEF0E5),
    info: Color(0xFF003566),
    infoLight: Color(0xFFE5EBF0),

    textPrimary: Color(0xFF1B4332),
    textSecondary: Color(0xFF2D6A4F),
    textTertiary: Color(0xFF40916C),
    textMuted: Color(0xFFB7E4C7),
    textInverse: Color(0xFFFFFFFF),

    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFF1F8F4),
    backgroundTertiary: Color(0xFFD8F3DC),
    backgroundCard: Color(0xFFFFFFFF),

    borderLight: Color(0xFFD8F3DC),
    borderMedium: Color(0xFFB7E4C7),
    borderDark: Color(0xFF95D5B2),
  );

  // ============================================
  // THÈME SUNSET (Orange chaleureux)
  // ============================================
  static const sunset = AppColorPalette(
    primary: Color(0xFFE85D04),
    primaryLight: Color(0xFFF48C06),
    primaryDark: Color(0xFFD00000),
    secondary: Color(0xFFFFBA08),
    accent: Color(0xFFFAA307),

    success: Color(0xFF38B000),
    successLight: Color(0xFFEAF6E5),
    error: Color(0xFFD00000),
    errorLight: Color(0xFFFAE5E5),
    warning: Color(0xFFFFBA08),
    warningLight: Color(0xFFFFF8E5),
    info: Color(0xFF3A86FF),
    infoLight: Color(0xFFEAF1FF),

    textPrimary: Color(0xFF370617),
    textSecondary: Color(0xFF6A040F),
    textTertiary: Color(0xFF9D0208),
    textMuted: Color(0xFFFFD5B8),
    textInverse: Color(0xFFFFFFFF),

    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFFFF5EB),
    backgroundTertiary: Color(0xFFFFE8D6),
    backgroundCard: Color(0xFFFFFFFF),

    borderLight: Color(0xFFFFE8D6),
    borderMedium: Color(0xFFFFD5B8),
    borderDark: Color(0xFFFAA307),
  );

  // ============================================
  // THÈME LAVANDE (Violet doux)
  // ============================================
  static const lavande = AppColorPalette(
    primary: Color(0xFF7B2CBF),
    primaryLight: Color(0xFF9D4EDD),
    primaryDark: Color(0xFF5A189A),
    secondary: Color(0xFFC77DFF),
    accent: Color(0xFFE0AAFF),

    success: Color(0xFF2EC4B6),
    successLight: Color(0xFFE9F8F7),
    error: Color(0xFFE71D36),
    errorLight: Color(0xFFFDE8EB),
    warning: Color(0xFFFF9F1C),
    warningLight: Color(0xFFFFF4E5),
    info: Color(0xFF7B2CBF),
    infoLight: Color(0xFFF3E8FA),

    textPrimary: Color(0xFF240046),
    textSecondary: Color(0xFF3C096C),
    textTertiary: Color(0xFF5A189A),
    textMuted: Color(0xFFE0AAFF),
    textInverse: Color(0xFFFFFFFF),

    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFFAF5FF),
    backgroundTertiary: Color(0xFFF3E8FA),
    backgroundCard: Color(0xFFFFFFFF),

    borderLight: Color(0xFFF3E8FA),
    borderMedium: Color(0xFFE0AAFF),
    borderDark: Color(0xFFC77DFF),
  );

  // ============================================
  // THÈME ROSE (Rose tendre)
  // ============================================
  static const rose = AppColorPalette(
    primary: Color(0xFFE91E63),
    primaryLight: Color(0xFFF06292),
    primaryDark: Color(0xFFC2185B),
    secondary: Color(0xFFFF80AB),
    accent: Color(0xFFFF4081),

    success: Color(0xFF4CAF50),
    successLight: Color(0xFFE8F5E9),
    error: Color(0xFFF44336),
    errorLight: Color(0xFFFFEBEE),
    warning: Color(0xFFFF9800),
    warningLight: Color(0xFFFFF3E0),
    info: Color(0xFF2196F3),
    infoLight: Color(0xFFE3F2FD),

    textPrimary: Color(0xFF880E4F),
    textSecondary: Color(0xFFAD1457),
    textTertiary: Color(0xFFC2185B),
    textMuted: Color(0xFFF8BBD9),
    textInverse: Color(0xFFFFFFFF),

    backgroundPrimary: Color(0xFFFFFFFF),
    backgroundSecondary: Color(0xFFFCE4EC),
    backgroundTertiary: Color(0xFFF8BBD9),
    backgroundCard: Color(0xFFFFFFFF),

    borderLight: Color(0xFFF8BBD9),
    borderMedium: Color(0xFFF48FB1),
    borderDark: Color(0xFFF06292),
  );

  // ============================================
  // THÈME MINUIT (Mode sombre élégant)
  // ============================================
  static const minuit = AppColorPalette(
    primary: Color(0xFF6366F1),
    primaryLight: Color(0xFF818CF8),
    primaryDark: Color(0xFF4F46E5),
    secondary: Color(0xFFA78BFA),
    accent: Color(0xFF22D3EE),

    success: Color(0xFF10B981),
    successLight: Color(0xFF1F3D31),
    error: Color(0xFFEF4444),
    errorLight: Color(0xFF3D1F1F),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFF3D331F),
    info: Color(0xFF6366F1),
    infoLight: Color(0xFF1F1F3D),

    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFFE5E7EB),
    textTertiary: Color(0xFF9CA3AF),
    textMuted: Color(0xFF4B5563),
    textInverse: Color(0xFF111827),

    backgroundPrimary: Color(0xFF111827),
    backgroundSecondary: Color(0xFF1F2937),
    backgroundTertiary: Color(0xFF374151),
    backgroundCard: Color(0xFF1F2937),

    borderLight: Color(0xFF374151),
    borderMedium: Color(0xFF4B5563),
    borderDark: Color(0xFF6B7280),

    isDark: true,
  );

  // ============================================
  // VARIANTES SOMBRES (DARK MODE)
  // ============================================

  // Classique Dark - Bleu iOS sur fond sombre
  static const classiqueDark = AppColorPalette(
    primary: Color(0xFF0A84FF), // iOS blue ajusté pour dark
    primaryLight: Color(0xFF64D2FF),
    primaryDark: Color(0xFF0051A8),
    secondary: Color(0xFF5E5CE6),
    accent: Color(0xFFFF9F0A),

    success: Color(0xFF30D158),
    successLight: Color(0xFF1A3D26),
    error: Color(0xFFFF453A),
    errorLight: Color(0xFF3D1A1A),
    warning: Color(0xFFFF9F0A),
    warningLight: Color(0xFF3D2E1A),
    info: Color(0xFF0A84FF),
    infoLight: Color(0xFF1A2A3D),

    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFEBEBF5),
    textTertiary: Color(0xFF8E8E93),
    textMuted: Color(0xFF48484A),
    textInverse: Color(0xFF000000),

    backgroundPrimary: Color(0xFF000000),
    backgroundSecondary: Color(0xFF1C1C1E),
    backgroundTertiary: Color(0xFF2C2C2E),
    backgroundCard: Color(0xFF1C1C1E),

    borderLight: Color(0xFF38383A),
    borderMedium: Color(0xFF48484A),
    borderDark: Color(0xFF636366),

    isDark: true,
  );

  // Océan Dark - Bleu profond sur fond sombre
  static const oceanDark = AppColorPalette(
    primary: Color(0xFF00B4D8),
    primaryLight: Color(0xFF48CAE4),
    primaryDark: Color(0xFF0077B6),
    secondary: Color(0xFF0096C7),
    accent: Color(0xFF90E0EF),

    success: Color(0xFF06D6A0),
    successLight: Color(0xFF1A3D33),
    error: Color(0xFFEF476F),
    errorLight: Color(0xFF3D1A25),
    warning: Color(0xFFFFD166),
    warningLight: Color(0xFF3D351A),
    info: Color(0xFF00B4D8),
    infoLight: Color(0xFF1A2F3D),

    textPrimary: Color(0xFFF0F9FF),
    textSecondary: Color(0xFFCAF0F8),
    textTertiary: Color(0xFF90E0EF),
    textMuted: Color(0xFF023E8A),
    textInverse: Color(0xFF03045E),

    backgroundPrimary: Color(0xFF03045E),
    backgroundSecondary: Color(0xFF0A1128),
    backgroundTertiary: Color(0xFF1B2838),
    backgroundCard: Color(0xFF0A1128),

    borderLight: Color(0xFF1B2838),
    borderMedium: Color(0xFF023E8A),
    borderDark: Color(0xFF0077B6),

    isDark: true,
  );

  // Forêt Dark - Vert nature sur fond sombre
  static const foretDark = AppColorPalette(
    primary: Color(0xFF52B788),
    primaryLight: Color(0xFF74C69D),
    primaryDark: Color(0xFF2D6A4F),
    secondary: Color(0xFF40916C),
    accent: Color(0xFF95D5B2),

    success: Color(0xFF74C69D),
    successLight: Color(0xFF1A3D28),
    error: Color(0xFFD62828),
    errorLight: Color(0xFF3D1A1A),
    warning: Color(0xFFF77F00),
    warningLight: Color(0xFF3D281A),
    info: Color(0xFF52B788),
    infoLight: Color(0xFF1A3D28),

    textPrimary: Color(0xFFF1F8F4),
    textSecondary: Color(0xFFD8F3DC),
    textTertiary: Color(0xFFB7E4C7),
    textMuted: Color(0xFF2D6A4F),
    textInverse: Color(0xFF1B4332),

    backgroundPrimary: Color(0xFF1B4332),
    backgroundSecondary: Color(0xFF0D2818),
    backgroundTertiary: Color(0xFF1A3D28),
    backgroundCard: Color(0xFF0D2818),

    borderLight: Color(0xFF1A3D28),
    borderMedium: Color(0xFF2D6A4F),
    borderDark: Color(0xFF40916C),

    isDark: true,
  );

  // Sunset Dark - Orange chaleureux sur fond sombre
  static const sunsetDark = AppColorPalette(
    primary: Color(0xFFF48C06),
    primaryLight: Color(0xFFFFBA08),
    primaryDark: Color(0xFFE85D04),
    secondary: Color(0xFFFAA307),
    accent: Color(0xFFFFD166),

    success: Color(0xFF38B000),
    successLight: Color(0xFF1A3D1A),
    error: Color(0xFFD00000),
    errorLight: Color(0xFF3D1A1A),
    warning: Color(0xFFFFBA08),
    warningLight: Color(0xFF3D351A),
    info: Color(0xFF3A86FF),
    infoLight: Color(0xFF1A253D),

    textPrimary: Color(0xFFFFF5EB),
    textSecondary: Color(0xFFFFE8D6),
    textTertiary: Color(0xFFFFD5B8),
    textMuted: Color(0xFF6A040F),
    textInverse: Color(0xFF370617),

    backgroundPrimary: Color(0xFF370617),
    backgroundSecondary: Color(0xFF1A0A0E),
    backgroundTertiary: Color(0xFF4D0A14),
    backgroundCard: Color(0xFF1A0A0E),

    borderLight: Color(0xFF4D0A14),
    borderMedium: Color(0xFF6A040F),
    borderDark: Color(0xFF9D0208),

    isDark: true,
  );

  // Lavande Dark - Violet doux sur fond sombre
  static const lavandeDark = AppColorPalette(
    primary: Color(0xFF9D4EDD),
    primaryLight: Color(0xFFC77DFF),
    primaryDark: Color(0xFF7B2CBF),
    secondary: Color(0xFFE0AAFF),
    accent: Color(0xFFC77DFF),

    success: Color(0xFF2EC4B6),
    successLight: Color(0xFF1A3D3A),
    error: Color(0xFFE71D36),
    errorLight: Color(0xFF3D1A1F),
    warning: Color(0xFFFF9F1C),
    warningLight: Color(0xFF3D2E1A),
    info: Color(0xFF9D4EDD),
    infoLight: Color(0xFF2A1A3D),

    textPrimary: Color(0xFFFAF5FF),
    textSecondary: Color(0xFFF3E8FA),
    textTertiary: Color(0xFFE0AAFF),
    textMuted: Color(0xFF5A189A),
    textInverse: Color(0xFF240046),

    backgroundPrimary: Color(0xFF240046),
    backgroundSecondary: Color(0xFF10002B),
    backgroundTertiary: Color(0xFF3C096C),
    backgroundCard: Color(0xFF10002B),

    borderLight: Color(0xFF3C096C),
    borderMedium: Color(0xFF5A189A),
    borderDark: Color(0xFF7B2CBF),

    isDark: true,
  );

  // Rose Dark - Rose tendre sur fond sombre
  static const roseDark = AppColorPalette(
    primary: Color(0xFFF06292),
    primaryLight: Color(0xFFFF80AB),
    primaryDark: Color(0xFFE91E63),
    secondary: Color(0xFFFF4081),
    accent: Color(0xFFFF80AB),

    success: Color(0xFF4CAF50),
    successLight: Color(0xFF1A3D1B),
    error: Color(0xFFF44336),
    errorLight: Color(0xFF3D1A1A),
    warning: Color(0xFFFF9800),
    warningLight: Color(0xFF3D2E1A),
    info: Color(0xFF2196F3),
    infoLight: Color(0xFF1A2A3D),

    textPrimary: Color(0xFFFCE4EC),
    textSecondary: Color(0xFFF8BBD9),
    textTertiary: Color(0xFFF48FB1),
    textMuted: Color(0xFFAD1457),
    textInverse: Color(0xFF880E4F),

    backgroundPrimary: Color(0xFF880E4F),
    backgroundSecondary: Color(0xFF4A0A2B),
    backgroundTertiary: Color(0xFF6D0D3C),
    backgroundCard: Color(0xFF4A0A2B),

    borderLight: Color(0xFF6D0D3C),
    borderMedium: Color(0xFFAD1457),
    borderDark: Color(0xFFC2185B),

    isDark: true,
  );

  /// Obtient la palette pour un type de thème donné (mode clair)
  static AppColorPalette getPalette(AppThemeType type) {
    switch (type) {
      case AppThemeType.classique:
        return classique;
      case AppThemeType.ocean:
        return ocean;
      case AppThemeType.foret:
        return foret;
      case AppThemeType.sunset:
        return sunset;
      case AppThemeType.lavande:
        return lavande;
      case AppThemeType.rose:
        return rose;
      case AppThemeType.minuit:
        return minuit;
    }
  }

  /// Obtient la palette sombre pour un type de thème donné
  static AppColorPalette getDarkPalette(AppThemeType type) {
    switch (type) {
      case AppThemeType.classique:
        return classiqueDark;
      case AppThemeType.ocean:
        return oceanDark;
      case AppThemeType.foret:
        return foretDark;
      case AppThemeType.sunset:
        return sunsetDark;
      case AppThemeType.lavande:
        return lavandeDark;
      case AppThemeType.rose:
        return roseDark;
      case AppThemeType.minuit:
        return minuit; // Minuit est déjà sombre
    }
  }

  /// Obtient la palette appropriée selon le mode (clair/sombre)
  static AppColorPalette getPaletteForBrightness(
    AppThemeType type,
    Brightness brightness,
  ) {
    if (brightness == Brightness.dark) {
      return getDarkPalette(type);
    }
    return getPalette(type);
  }

  /// Génère un ThemeData Flutter à partir d'une palette
  static ThemeData generateThemeData(AppColorPalette palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
      primaryColor: palette.primary,
      scaffoldBackgroundColor: palette.backgroundSecondary,
      colorScheme: ColorScheme(
        brightness: palette.isDark ? Brightness.dark : Brightness.light,
        primary: palette.primary,
        onPrimary: palette.textInverse,
        secondary: palette.secondary,
        onSecondary: palette.textInverse,
        error: palette.error,
        onError: palette.textInverse,
        surface: palette.backgroundCard,
        onSurface: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.backgroundPrimary,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: palette.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.borderLight),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.backgroundPrimary,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primary;
          }
          return palette.backgroundTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primary.withValues(alpha: 0.5);
          }
          return palette.borderMedium;
        }),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: palette.textPrimary),
        displayMedium: TextStyle(color: palette.textPrimary),
        displaySmall: TextStyle(color: palette.textPrimary),
        headlineLarge: TextStyle(color: palette.textPrimary),
        headlineMedium: TextStyle(color: palette.textPrimary),
        headlineSmall: TextStyle(color: palette.textPrimary),
        titleLarge: TextStyle(color: palette.textPrimary),
        titleMedium: TextStyle(color: palette.textPrimary),
        titleSmall: TextStyle(color: palette.textSecondary),
        bodyLarge: TextStyle(color: palette.textPrimary),
        bodyMedium: TextStyle(color: palette.textSecondary),
        bodySmall: TextStyle(color: palette.textTertiary),
        labelLarge: TextStyle(color: palette.textPrimary),
        labelMedium: TextStyle(color: palette.textSecondary),
        labelSmall: TextStyle(color: palette.textTertiary),
      ),
      dividerTheme: DividerThemeData(
        color: palette.borderLight,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.backgroundTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
        ),
      ),
      iconTheme: IconThemeData(
        color: palette.textSecondary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
      ),
    );
  }
}

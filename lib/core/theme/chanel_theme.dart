import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chanel_colors.dart';
import 'chanel_typography.dart';

/// Thème Material Design basé sur le design system Chanel Modern
class ChanelTheme {
  ChanelTheme._();

  // ============================================
  // SPACING
  // ============================================
  static const double spacing0 = 0;
  static const double spacing1 = 4;
  static const double spacing2 = 8;
  static const double spacing3 = 12;
  static const double spacing4 = 16;
  static const double spacing5 = 20;
  static const double spacing6 = 24;
  static const double spacing8 = 32;
  static const double spacing10 = 40;
  static const double spacing12 = 48;
  static const double spacing16 = 64;

  // ============================================
  // BORDER RADIUS
  // ============================================
  static const double radiusNone = 0;
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusBase = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999;

  // ============================================
  // MATERIAL THEME (Light)
  // ============================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: ChanelColors.black,
        onPrimary: ChanelColors.white,
        primaryContainer: ChanelColors.neutral100,
        onPrimaryContainer: ChanelColors.black,
        secondary: ChanelColors.gold,
        onSecondary: ChanelColors.black,
        secondaryContainer: ChanelColors.champagne,
        onSecondaryContainer: ChanelColors.darkGold,
        tertiary: ChanelColors.neutral600,
        onTertiary: ChanelColors.white,
        error: ChanelColors.error,
        onError: ChanelColors.white,
        errorContainer: ChanelColors.errorLight,
        onErrorContainer: ChanelColors.error,
        surface: ChanelColors.white,
        onSurface: ChanelColors.textPrimary,
        surfaceContainerHighest: ChanelColors.backgroundSecondary,
        onSurfaceVariant: ChanelColors.textSecondary,
        outline: ChanelColors.borderLight,
        outlineVariant: ChanelColors.borderSubtle,
      ),

      // Scaffold
      scaffoldBackgroundColor: ChanelColors.backgroundPrimary,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: ChanelColors.backgroundPrimary,
        foregroundColor: ChanelColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: ChanelTypography.titleLarge.copyWith(
          letterSpacing: ChanelTypography.letterSpacingWider,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: ChanelTypography.displayLarge,
        displayMedium: ChanelTypography.displayMedium,
        displaySmall: ChanelTypography.displaySmall,
        headlineLarge: ChanelTypography.headlineLarge,
        headlineMedium: ChanelTypography.headlineMedium,
        headlineSmall: ChanelTypography.headlineSmall,
        titleLarge: ChanelTypography.titleLarge,
        titleMedium: ChanelTypography.titleMedium,
        titleSmall: ChanelTypography.titleSmall,
        bodyLarge: ChanelTypography.bodyLarge,
        bodyMedium: ChanelTypography.bodyMedium,
        bodySmall: ChanelTypography.bodySmall,
        labelLarge: ChanelTypography.labelLarge,
        labelMedium: ChanelTypography.labelMedium,
        labelSmall: ChanelTypography.labelSmall,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChanelColors.black,
          foregroundColor: ChanelColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBase),
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChanelColors.black,
          side: const BorderSide(color: ChanelColors.black, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBase),
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ChanelColors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing2,
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChanelColors.backgroundSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColors.error),
        ),
        labelStyle: ChanelTypography.bodyMedium,
        hintStyle: ChanelTypography.bodyMedium.copyWith(
          color: ChanelColors.textMuted,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: ChanelColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: ChanelColors.borderSubtle),
        ),
        margin: const EdgeInsets.all(spacing2),
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ChanelColors.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: ChanelColors.textSecondary,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: ChanelColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ChanelColors.white,
        selectedItemColor: ChanelColors.black,
        unselectedItemColor: ChanelColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ChanelColors.white,
        indicatorColor: ChanelColors.neutral100,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ChanelTypography.labelSmall.copyWith(
              color: ChanelColors.black,
            );
          }
          return ChanelTypography.labelSmall.copyWith(
            color: ChanelColors.textTertiary,
          );
        }),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ChanelColors.black,
        foregroundColor: ChanelColors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),

      // Snack Bar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ChanelColors.neutral900,
        contentTextStyle: ChanelTypography.bodyMedium.copyWith(
          color: ChanelColors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: ChanelColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        titleTextStyle: ChanelTypography.headlineMedium,
        contentTextStyle: ChanelTypography.bodyLarge,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ChanelColors.black,
        linearTrackColor: ChanelColors.neutral200,
        circularTrackColor: ChanelColors.neutral200,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: ChanelColors.backgroundSecondary,
        labelStyle: ChanelTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: const BorderSide(color: ChanelColors.borderLight),
      ),
    );
  }

  // ============================================
  // CUPERTINO THEME (iOS)
  // ============================================
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: ChanelColors.black,
      primaryContrastingColor: ChanelColors.white,
      barBackgroundColor: ChanelColors.white,
      scaffoldBackgroundColor: ChanelColors.backgroundSecondary,
      textTheme: CupertinoTextThemeData(
        primaryColor: ChanelColors.textPrimary,
        textStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilyBody,
          fontSize: 17,
          color: ChanelColors.textPrimary,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilySansSerif,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: ChanelColors.textPrimary,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilySansSerif,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: ChanelColors.textPrimary,
        ),
      ),
    );
  }

  // ============================================
  // MATERIAL THEME (Dark)
  // ============================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: ChanelColorsDark.gold,
        onPrimary: ChanelColorsDark.textInverse,
        primaryContainer: ChanelColorsDark.neutral200,
        onPrimaryContainer: ChanelColorsDark.textPrimary,
        secondary: ChanelColorsDark.gold,
        onSecondary: ChanelColorsDark.textInverse,
        secondaryContainer: ChanelColorsDark.champagne,
        onSecondaryContainer: ChanelColorsDark.lightGold,
        tertiary: ChanelColorsDark.neutral600,
        onTertiary: ChanelColorsDark.textInverse,
        error: ChanelColorsDark.error,
        onError: ChanelColorsDark.textInverse,
        errorContainer: ChanelColorsDark.errorLight,
        onErrorContainer: ChanelColorsDark.error,
        surface: ChanelColorsDark.backgroundPrimary,
        onSurface: ChanelColorsDark.textPrimary,
        surfaceContainerHighest: ChanelColorsDark.backgroundSecondary,
        onSurfaceVariant: ChanelColorsDark.textSecondary,
        outline: ChanelColorsDark.borderLight,
        outlineVariant: ChanelColorsDark.borderSubtle,
      ),

      // Scaffold
      scaffoldBackgroundColor: ChanelColorsDark.backgroundPrimary,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: ChanelColorsDark.backgroundPrimary,
        foregroundColor: ChanelColorsDark.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: ChanelTypography.titleLarge.copyWith(
          letterSpacing: ChanelTypography.letterSpacingWider,
          color: ChanelColorsDark.textPrimary,
        ),
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: ChanelTypography.displayLarge.copyWith(color: ChanelColorsDark.textPrimary),
        displayMedium: ChanelTypography.displayMedium.copyWith(color: ChanelColorsDark.textPrimary),
        displaySmall: ChanelTypography.displaySmall.copyWith(color: ChanelColorsDark.textPrimary),
        headlineLarge: ChanelTypography.headlineLarge.copyWith(color: ChanelColorsDark.textPrimary),
        headlineMedium: ChanelTypography.headlineMedium.copyWith(color: ChanelColorsDark.textPrimary),
        headlineSmall: ChanelTypography.headlineSmall.copyWith(color: ChanelColorsDark.textPrimary),
        titleLarge: ChanelTypography.titleLarge.copyWith(color: ChanelColorsDark.textPrimary),
        titleMedium: ChanelTypography.titleMedium.copyWith(color: ChanelColorsDark.textPrimary),
        titleSmall: ChanelTypography.titleSmall.copyWith(color: ChanelColorsDark.textPrimary),
        bodyLarge: ChanelTypography.bodyLarge.copyWith(color: ChanelColorsDark.textPrimary),
        bodyMedium: ChanelTypography.bodyMedium.copyWith(color: ChanelColorsDark.textPrimary),
        bodySmall: ChanelTypography.bodySmall.copyWith(color: ChanelColorsDark.textSecondary),
        labelLarge: ChanelTypography.labelLarge.copyWith(color: ChanelColorsDark.textPrimary),
        labelMedium: ChanelTypography.labelMedium.copyWith(color: ChanelColorsDark.textPrimary),
        labelSmall: ChanelTypography.labelSmall.copyWith(color: ChanelColorsDark.textSecondary),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ChanelColorsDark.gold,
          foregroundColor: ChanelColorsDark.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBase),
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ChanelColorsDark.textPrimary,
          side: const BorderSide(color: ChanelColorsDark.borderLight, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing6,
            vertical: spacing4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBase),
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ChanelColorsDark.gold,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing2,
          ),
          textStyle: ChanelTypography.labelLarge,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ChanelColorsDark.backgroundSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColorsDark.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColorsDark.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColorsDark.gold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusBase),
          borderSide: const BorderSide(color: ChanelColorsDark.error),
        ),
        labelStyle: ChanelTypography.bodyMedium.copyWith(color: ChanelColorsDark.textSecondary),
        hintStyle: ChanelTypography.bodyMedium.copyWith(
          color: ChanelColorsDark.textMuted,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: ChanelColorsDark.backgroundSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: ChanelColorsDark.borderSubtle),
        ),
        margin: const EdgeInsets.all(spacing2),
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ChanelColorsDark.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: ChanelColorsDark.textSecondary,
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: ChanelColorsDark.borderSubtle,
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ChanelColorsDark.backgroundSecondary,
        selectedItemColor: ChanelColorsDark.gold,
        unselectedItemColor: ChanelColorsDark.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ChanelColorsDark.backgroundSecondary,
        indicatorColor: ChanelColorsDark.neutral200,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ChanelTypography.labelSmall.copyWith(
              color: ChanelColorsDark.gold,
            );
          }
          return ChanelTypography.labelSmall.copyWith(
            color: ChanelColorsDark.textTertiary,
          );
        }),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ChanelColorsDark.gold,
        foregroundColor: ChanelColorsDark.textInverse,
        elevation: 2,
        shape: CircleBorder(),
      ),

      // Snack Bar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ChanelColorsDark.neutral800,
        contentTextStyle: ChanelTypography.bodyMedium.copyWith(
          color: ChanelColorsDark.textInverse,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: ChanelColorsDark.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        titleTextStyle: ChanelTypography.headlineMedium.copyWith(color: ChanelColorsDark.textPrimary),
        contentTextStyle: ChanelTypography.bodyLarge.copyWith(color: ChanelColorsDark.textPrimary),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ChanelColorsDark.gold,
        linearTrackColor: ChanelColorsDark.neutral300,
        circularTrackColor: ChanelColorsDark.neutral300,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: ChanelColorsDark.backgroundSecondary,
        labelStyle: ChanelTypography.labelMedium.copyWith(color: ChanelColorsDark.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: const BorderSide(color: ChanelColorsDark.borderLight),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ChanelColorsDark.gold;
          }
          return ChanelColorsDark.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ChanelColorsDark.gold.withOpacity(0.5);
          }
          return ChanelColorsDark.neutral300;
        }),
      ),
    );
  }

  // ============================================
  // CUPERTINO THEME (iOS) - Dark
  // ============================================
  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: ChanelColorsDark.gold,
      primaryContrastingColor: ChanelColorsDark.textInverse,
      barBackgroundColor: ChanelColorsDark.backgroundSecondary,
      scaffoldBackgroundColor: ChanelColorsDark.backgroundPrimary,
      textTheme: CupertinoTextThemeData(
        primaryColor: ChanelColorsDark.textPrimary,
        textStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilyBody,
          fontSize: 17,
          color: ChanelColorsDark.textPrimary,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilySansSerif,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: ChanelColorsDark.textPrimary,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: ChanelTypography.fontFamilySansSerif,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: ChanelColorsDark.textPrimary,
        ),
      ),
    );
  }
}

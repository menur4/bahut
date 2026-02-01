import 'package:flutter/material.dart';
import 'chanel_colors.dart';

/// Typographie du design system Chanel Modern
class ChanelTypography {
  ChanelTypography._();

  // ============================================
  // FONT FAMILIES
  // ============================================
  static const String fontFamilySerif = 'Georgia'; // Fallback pour AB Chanel Corpo
  static const String fontFamilySansSerif = 'Helvetica Neue';
  static const String fontFamilyDisplay = 'Georgia';
  static const String fontFamilyBody = 'Helvetica Neue';

  // ============================================
  // FONT SIZES
  // ============================================
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2Xl = 24.0;
  static const double fontSize3Xl = 30.0;
  static const double fontSize4Xl = 36.0;
  static const double fontSize5Xl = 48.0;
  static const double fontSize6Xl = 60.0;
  static const double fontSize7Xl = 72.0;

  // ============================================
  // LETTER SPACING
  // ============================================
  static const double letterSpacingTightest = -0.08 * 16;
  static const double letterSpacingTighter = -0.05 * 16;
  static const double letterSpacingTight = -0.025 * 16;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.025 * 16;
  static const double letterSpacingWider = 0.05 * 16;
  static const double letterSpacingWidest = 0.1 * 16;
  static const double letterSpacingLuxury = 0.15 * 16;

  // ============================================
  // TEXT STYLES
  // ============================================

  /// Titre principal luxueux (serif, uppercase, espacement large)
  static TextStyle displayLarge = const TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: fontSize5Xl,
    fontWeight: FontWeight.w300,
    letterSpacing: letterSpacingLuxury,
    color: ChanelColors.textPrimary,
  );

  /// Titre secondaire
  static TextStyle displayMedium = const TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: fontSize4Xl,
    fontWeight: FontWeight.w300,
    letterSpacing: letterSpacingWider,
    color: ChanelColors.textPrimary,
  );

  /// Titre tertiaire
  static TextStyle displaySmall = const TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: fontSize3Xl,
    fontWeight: FontWeight.w400,
    letterSpacing: letterSpacingWide,
    color: ChanelColors.textPrimary,
  );

  /// Headline large
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSize2Xl,
    fontWeight: FontWeight.w600,
    letterSpacing: letterSpacingNormal,
    color: ChanelColors.textPrimary,
  );

  /// Headline medium
  static TextStyle headlineMedium = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeXl,
    fontWeight: FontWeight.w600,
    letterSpacing: letterSpacingNormal,
    color: ChanelColors.textPrimary,
  );

  /// Headline small
  static TextStyle headlineSmall = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w600,
    letterSpacing: letterSpacingNormal,
    color: ChanelColors.textPrimary,
  );

  /// Title large
  static TextStyle titleLarge = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWide,
    color: ChanelColors.textPrimary,
  );

  /// Title medium
  static TextStyle titleMedium = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeBase,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWide,
    color: ChanelColors.textPrimary,
  );

  /// Title small
  static TextStyle titleSmall = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWide,
    color: ChanelColors.textPrimary,
  );

  /// Body large
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: fontSizeBase,
    fontWeight: FontWeight.w400,
    letterSpacing: letterSpacingNormal,
    height: 1.5,
    color: ChanelColors.textPrimary,
  );

  /// Body medium
  static TextStyle bodyMedium = const TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w400,
    letterSpacing: letterSpacingNormal,
    height: 1.5,
    color: ChanelColors.textSecondary,
  );

  /// Body small
  static TextStyle bodySmall = const TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: fontSizeXs,
    fontWeight: FontWeight.w400,
    letterSpacing: letterSpacingNormal,
    height: 1.5,
    color: ChanelColors.textTertiary,
  );

  /// Label large
  static TextStyle labelLarge = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWider,
    color: ChanelColors.textPrimary,
  );

  /// Label medium
  static TextStyle labelMedium = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: fontSizeXs,
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWider,
    color: ChanelColors.textSecondary,
  );

  /// Label small (minimum 11pt pour accessibilité HIG)
  static TextStyle labelSmall = const TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 11.0, // Augmenté de 10 à 11 pour accessibilité
    fontWeight: FontWeight.w500,
    letterSpacing: letterSpacingWidest,
    color: ChanelColors.textTertiary,
  );

  /// Taille minimum pour l'accessibilité (HIG recommande 11pt minimum)
  static const double accessibilityMinFontSize = 11.0;
}

/// Extension pour le support Dynamic Type (HIG Apple)
extension DynamicTypography on TextStyle {
  /// Applique le facteur d'échelle du texte système pour Dynamic Type
  /// Limite le scaling entre 0.85 et 1.35 pour éviter les layouts cassés
  TextStyle scaled(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaler.scale(1.0);
    // Limite le scaling pour préserver le layout
    final limitedScale = textScaleFactor.clamp(0.85, 1.35);

    final scaledSize = (fontSize ?? 14.0) * limitedScale;
    // S'assurer que la taille reste au-dessus du minimum d'accessibilité
    final finalSize = scaledSize.clamp(
      ChanelTypography.accessibilityMinFontSize,
      double.infinity,
    );

    return copyWith(fontSize: finalSize);
  }

  /// Version avec limite de scaling plus stricte pour les éléments UI compacts
  TextStyle scaledCompact(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaler.scale(1.0);
    final limitedScale = textScaleFactor.clamp(0.9, 1.2);

    final scaledSize = (fontSize ?? 14.0) * limitedScale;
    final finalSize = scaledSize.clamp(
      ChanelTypography.accessibilityMinFontSize,
      double.infinity,
    );

    return copyWith(fontSize: finalSize);
  }
}

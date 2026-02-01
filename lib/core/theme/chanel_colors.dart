import 'package:flutter/material.dart';

/// Couleurs du design system Chanel Modern
/// Portées depuis le design system TypeScript
class ChanelColors {
  ChanelColors._();

  // ============================================
  // PRIMARY COLORS
  // ============================================
  static const Color black = Color(0xFF000000);
  static const Color softBlack = Color(0xFF1A1A1A);
  static const Color charcoal = Color(0xFF2D2D2D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color ivory = Color(0xFFF8F6F0);
  static const Color cream = Color(0xFFFFF8F0);

  // ============================================
  // NEUTRAL PALETTE
  // ============================================
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral150 = Color(0xFFF0F0F0);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral250 = Color(0xFFDFDFDF);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral350 = Color(0xFFC9C9C9);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral450 = Color(0xFF8F8F8F);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral850 = Color(0xFF1F1F1F);
  static const Color neutral900 = Color(0xFF171717);
  static const Color neutral950 = Color(0xFF0A0A0A);

  // ============================================
  // ACCENT COLORS
  // ============================================
  static const Color gold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFE8C968);
  static const Color darkGold = Color(0xFFB8941F);
  static const Color champagne = Color(0xFFF7E7CE);
  static const Color lightChampagne = Color(0xFFFDF5E6);
  static const Color beige = Color(0xFFE8D5C4);
  static const Color lightBeige = Color(0xFFF5E9DD);
  static const Color pearl = Color(0xFFEAE0D5);
  static const Color lightPearl = Color(0xFFF4EDE5);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color rose = Color(0xFFF5E6E0);
  static const Color blush = Color(0xFFFFE8E0);
  static const Color softGrey = Color(0xFFE8E8E8);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  static const Color success = Color(0xFF2D5016);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFF8B0000);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFF8B6914);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color info = Color(0xFF1E3A5F);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ============================================
  // TEXT COLORS
  // Conformes WCAG AA (ratio minimum 4.5:1 sur blanc)
  // ============================================
  static const Color textPrimary = Color(0xFF000000); // 21:1 ✓
  static const Color textSecondary = Color(0xFF404040); // 9.4:1 ✓
  static const Color textTertiary = Color(0xFF737373); // 4.48:1 ✓
  static const Color textQuaternary = Color(0xFF8F8F8F); // 3.5:1 (décoratif)
  static const Color textInverse = Color(0xFFFFFFFF);
  // textMuted corrigé: 0xFFC9C9C9 → 0xFF767676 pour contraste 4.54:1
  static const Color textMuted = Color(0xFF767676); // 4.54:1 ✓ (WCAG AA)
  // textDisabled: éléments non interactifs, ratio 3:1 acceptable
  static const Color textDisabled = Color(0xFF9E9E9E); // 3.3:1 (désactivé)

  // ============================================
  // BACKGROUND COLORS
  // ============================================
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFFAFAFA);
  static const Color backgroundTertiary = Color(0xFFF5F5F5);
  static const Color backgroundQuaternary = Color(0xFFF0F0F0);
  static const Color backgroundInverse = Color(0xFF000000);
  static const Color backgroundHeader = Color(0xFF000000);

  // ============================================
  // BORDER COLORS
  // ============================================
  static const Color borderLight = Color(0xFFD4D4D4);
  static const Color borderMedium = Color(0xFFA3A3A3);
  static const Color borderDark = Color(0xFF737373);
  static const Color borderBlack = Color(0xFF000000);
  static const Color borderSubtle = Color(0xFFE5E5E5);
  static const Color borderGold = Color(0xFFD4AF37);

  // ============================================
  // GRADE COLORS (pour les notes)
  // ============================================
  static Color gradeColor(double grade, {double maxGrade = 20}) {
    final percentage = grade / maxGrade;
    if (percentage >= 0.8) return success; // >= 16/20
    if (percentage >= 0.6) return info; // >= 12/20
    if (percentage >= 0.5) return warning; // >= 10/20
    return error; // < 10/20
  }
}

/// Couleurs du design system Chanel Modern - Mode sombre
class ChanelColorsDark {
  ChanelColorsDark._();

  // ============================================
  // PRIMARY COLORS (inversés pour le mode sombre)
  // ============================================
  static const Color black = Color(0xFFFFFFFF); // Texte principal
  static const Color softBlack = Color(0xFFF5F5F5);
  static const Color charcoal = Color(0xFFE5E5E5);
  static const Color white = Color(0xFF121212); // Fond principal
  static const Color offWhite = Color(0xFF1E1E1E);
  static const Color ivory = Color(0xFF252525);
  static const Color cream = Color(0xFF2A2A2A);

  // ============================================
  // NEUTRAL PALETTE (inversés)
  // ============================================
  static const Color neutral50 = Color(0xFF171717);
  static const Color neutral100 = Color(0xFF1F1F1F);
  static const Color neutral150 = Color(0xFF262626);
  static const Color neutral200 = Color(0xFF2D2D2D);
  static const Color neutral250 = Color(0xFF333333);
  static const Color neutral300 = Color(0xFF404040);
  static const Color neutral350 = Color(0xFF4A4A4A);
  static const Color neutral400 = Color(0xFF525252);
  static const Color neutral450 = Color(0xFF666666);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFFA3A3A3);
  static const Color neutral700 = Color(0xFFD4D4D4);
  static const Color neutral800 = Color(0xFFE5E5E5);
  static const Color neutral850 = Color(0xFFF0F0F0);
  static const Color neutral900 = Color(0xFFF5F5F5);
  static const Color neutral950 = Color(0xFFFAFAFA);

  // ============================================
  // ACCENT COLORS (adaptés pour le mode sombre)
  // ============================================
  static const Color gold = Color(0xFFE8C968);
  static const Color lightGold = Color(0xFFF5DC8C);
  static const Color darkGold = Color(0xFFD4AF37);
  static const Color champagne = Color(0xFF3D3526);
  static const Color lightChampagne = Color(0xFF4A4030);
  static const Color beige = Color(0xFF3D352A);
  static const Color lightBeige = Color(0xFF4A4035);
  static const Color pearl = Color(0xFF353028);
  static const Color lightPearl = Color(0xFF403830);
  static const Color bronze = Color(0xFFE09550);
  static const Color rose = Color(0xFF3D302A);
  static const Color blush = Color(0xFF4A3530);
  static const Color softGrey = Color(0xFF2D2D2D);

  // ============================================
  // SEMANTIC COLORS (légèrement ajustés pour le mode sombre)
  // ============================================
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF1B3D1F);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFF3D1B1B);
  static const Color warning = Color(0xFFFFB74D);
  static const Color warningLight = Color(0xFF3D331B);
  static const Color info = Color(0xFF64B5F6);
  static const Color infoLight = Color(0xFF1B2D3D);

  // ============================================
  // TEXT COLORS
  // ============================================
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD4D4D4);
  static const Color textTertiary = Color(0xFFA3A3A3);
  static const Color textQuaternary = Color(0xFF737373);
  static const Color textInverse = Color(0xFF000000);
  static const Color textMuted = Color(0xFF525252);
  static const Color textDisabled = Color(0xFF404040);

  // ============================================
  // BACKGROUND COLORS
  // ============================================
  static const Color backgroundPrimary = Color(0xFF121212);
  static const Color backgroundSecondary = Color(0xFF1E1E1E);
  static const Color backgroundTertiary = Color(0xFF252525);
  static const Color backgroundQuaternary = Color(0xFF2D2D2D);
  static const Color backgroundInverse = Color(0xFFFFFFFF);
  static const Color backgroundHeader = Color(0xFF1E1E1E);

  // ============================================
  // BORDER COLORS
  // ============================================
  static const Color borderLight = Color(0xFF404040);
  static const Color borderMedium = Color(0xFF525252);
  static const Color borderDark = Color(0xFF737373);
  static const Color borderBlack = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFF333333);
  static const Color borderGold = Color(0xFFE8C968);

  // ============================================
  // GRADE COLORS (pour les notes - mode sombre)
  // ============================================
  static Color gradeColor(double grade, {double maxGrade = 20}) {
    final percentage = grade / maxGrade;
    if (percentage >= 0.8) return success; // >= 16/20
    if (percentage >= 0.6) return info; // >= 12/20
    if (percentage >= 0.5) return warning; // >= 10/20
    return error; // < 10/20
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../domain/services/statistics_service.dart';

/// Section de comparaison avec la classe
class ClassComparisonSection extends StatelessWidget {
  final GlobalStats stats;
  final AppColorPalette palette;

  const ClassComparisonSection({
    super.key,
    required this.stats,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final hasClassData = stats.classGeneralAverage != null ||
        stats.subjectStats.any((s) => s.classAverage != null);

    if (!hasClassData) {
      return Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          border: Border.all(color: palette.borderLight),
        ),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 48,
              color: palette.textMuted,
            ),
            const SizedBox(height: ChanelTheme.spacing3),
            Text(
              'Données de classe non disponibles',
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Calculer les stats de comparaison
    final comparison = _calculateClassComparison();

    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          // Header avec moyenne générale vs classe
          if (stats.classGeneralAverage != null)
            _ComparisonHeader(
              myAverage: stats.generalAverage,
              classAverage: stats.classGeneralAverage!,
              palette: palette,
            ),

          if (stats.classGeneralAverage != null)
            Divider(height: 1, color: palette.borderLight),

          // Résumé de comparaison
          Padding(
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            child: Column(
              children: [
                // Stats rapides
                Row(
                  children: [
                    Expanded(
                      child: _ComparisonStat(
                        icon: Icons.trending_up,
                        iconColor: palette.success,
                        value: comparison.aboveClassCount.toString(),
                        label: 'Au-dessus',
                        palette: palette,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: palette.borderLight,
                    ),
                    Expanded(
                      child: _ComparisonStat(
                        icon: Icons.trending_flat,
                        iconColor: palette.warning,
                        value: comparison.equalClassCount.toString(),
                        label: 'Dans la moyenne',
                        palette: palette,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: palette.borderLight,
                    ),
                    Expanded(
                      child: _ComparisonStat(
                        icon: Icons.trending_down,
                        iconColor: palette.error,
                        value: comparison.belowClassCount.toString(),
                        label: 'En dessous',
                        palette: palette,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing4),

                // Meilleures performances vs classe
                if (comparison.bestVsClass != null) ...[
                  _HighlightCard(
                    title: 'Meilleure performance vs classe',
                    subject: comparison.bestVsClass!.subjectName,
                    difference: comparison.bestVsClass!.diffFromClass!,
                    myAverage: comparison.bestVsClass!.average,
                    palette: palette,
                    isPositive: true,
                  ),
                  const SizedBox(height: ChanelTheme.spacing2),
                ],

                // Pire performance vs classe
                if (comparison.worstVsClass != null)
                  _HighlightCard(
                    title: 'À améliorer vs classe',
                    subject: comparison.worstVsClass!.subjectName,
                    difference: comparison.worstVsClass!.diffFromClass!,
                    myAverage: comparison.worstVsClass!.average,
                    palette: palette,
                    isPositive: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ClassComparisonData _calculateClassComparison() {
    int above = 0;
    int equal = 0;
    int below = 0;
    SubjectStats? bestVsClass;
    SubjectStats? worstVsClass;
    double bestDiff = double.negativeInfinity;
    double worstDiff = double.infinity;

    for (final subject in stats.subjectStats) {
      if (subject.classAverage == null) continue;

      final diff = subject.diffFromClass!;

      if (diff > 0.5) {
        above++;
      } else if (diff < -0.5) {
        below++;
      } else {
        equal++;
      }

      if (diff > bestDiff) {
        bestDiff = diff;
        bestVsClass = subject;
      }
      if (diff < worstDiff) {
        worstDiff = diff;
        worstVsClass = subject;
      }
    }

    return _ClassComparisonData(
      aboveClassCount: above,
      equalClassCount: equal,
      belowClassCount: below,
      bestVsClass: bestVsClass,
      worstVsClass: worstVsClass,
    );
  }
}

class _ClassComparisonData {
  final int aboveClassCount;
  final int equalClassCount;
  final int belowClassCount;
  final SubjectStats? bestVsClass;
  final SubjectStats? worstVsClass;

  const _ClassComparisonData({
    required this.aboveClassCount,
    required this.equalClassCount,
    required this.belowClassCount,
    this.bestVsClass,
    this.worstVsClass,
  });
}

/// Header avec comparaison moyenne générale
class _ComparisonHeader extends StatelessWidget {
  final double myAverage;
  final double classAverage;
  final AppColorPalette palette;

  const _ComparisonHeader({
    required this.myAverage,
    required this.classAverage,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final diff = myAverage - classAverage;
    final isAbove = diff > 0;
    final diffColor = isAbove ? palette.success : (diff < 0 ? palette.error : palette.textMuted);

    return Padding(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      child: Row(
        children: [
          // Ma moyenne
          Expanded(
            child: Column(
              children: [
                Text(
                  'MOI',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textMuted,
                    letterSpacing: ChanelTypography.letterSpacingWider,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  myAverage.toStringAsFixed(2),
                  style: ChanelTypography.headlineMedium.copyWith(
                    color: palette.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Différence
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing3,
              vertical: ChanelTheme.spacing2,
            ),
            decoration: BoxDecoration(
              color: diffColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAbove ? Icons.arrow_upward : (diff < 0 ? Icons.arrow_downward : Icons.remove),
                  size: 16,
                  color: diffColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isAbove ? '+' : ''}${diff.toStringAsFixed(2)}',
                  style: ChanelTypography.labelMedium.copyWith(
                    color: diffColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Moyenne classe
          Expanded(
            child: Column(
              children: [
                Text(
                  'CLASSE',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textMuted,
                    letterSpacing: ChanelTypography.letterSpacingWider,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  classAverage.toStringAsFixed(2),
                  style: ChanelTypography.headlineMedium.copyWith(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Statistique de comparaison
class _ComparisonStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final AppColorPalette palette;

  const _ComparisonStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: ChanelTypography.titleLarge.copyWith(
            color: palette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: ChanelTypography.labelSmall.copyWith(
            color: palette.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Carte de mise en avant d'une matière
class _HighlightCard extends StatelessWidget {
  final String title;
  final String subject;
  final double difference;
  final double myAverage;
  final AppColorPalette palette;
  final bool isPositive;

  const _HighlightCard({
    required this.title,
    required this.subject,
    required this.difference,
    required this.myAverage,
    required this.palette,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? palette.success : palette.error;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Icon(
              isPositive ? Icons.emoji_events : Icons.school,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: ChanelTheme.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textMuted,
                  ),
                ),
                Text(
                  subject,
                  style: ChanelTypography.bodyMedium.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                myAverage.toStringAsFixed(1),
                style: ChanelTypography.titleSmall.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${difference >= 0 ? '+' : ''}${difference.toStringAsFixed(1)} pts',
                style: ChanelTypography.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

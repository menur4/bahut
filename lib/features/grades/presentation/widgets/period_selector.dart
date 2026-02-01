import 'package:flutter/material.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../data/models/grade_model.dart';

/// Sélecteur de période (trimestre)
class PeriodSelector extends StatelessWidget {
  final List<PeriodModel> periods;
  final String? selectedPeriod;
  final ValueChanged<String?> onPeriodChanged;
  final AppColorPalette? palette;

  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = period.codePeriode == selectedPeriod;

          return Padding(
            padding: const EdgeInsets.only(right: ChanelTheme.spacing2),
            child: GestureDetector(
              onTap: () => onPeriodChanged(period.codePeriode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: ChanelTheme.spacing4,
                  vertical: ChanelTheme.spacing2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? p.primary : p.backgroundCard,
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
                  border: Border.all(
                    color: isSelected ? p.primary : p.borderLight,
                  ),
                ),
                child: Text(
                  period.periode,
                  style: ChanelTypography.labelMedium.copyWith(
                    color: isSelected ? p.textInverse : p.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/share_service.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../../grades/presentation/widgets/period_selector.dart';
import '../../domain/services/average_calculator.dart';

/// Partage le bulletin
Future<void> _shareBulletin(
  BuildContext context,
  WidgetRef ref, {
  required String childName,
  required String periodName,
  required double generalAverage,
  required Map<String, SubjectAverage> subjectAverages,
}) async {
  final box = context.findRenderObject() as RenderBox?;
  final shareService = ref.read(shareServiceProvider);

  // Convertir les moyennes par matière
  final averagesMap = <String, double>{};
  final namesMap = <String, String>{};
  for (final entry in subjectAverages.entries) {
    if (entry.value.average != null) {
      averagesMap[entry.key] = entry.value.average!;
      namesMap[entry.key] = entry.value.subjectName;
    }
  }

  await shareService.shareBulletin(
    childName: childName,
    periodName: periodName,
    generalAverage: generalAverage,
    subjectAverages: averagesMap,
    subjectNames: namesMap,
    sharePositionOrigin: box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null,
  );
}

/// Écran des moyennes (standalone)
class AveragesScreen extends ConsumerWidget {
  const AveragesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final authState = ref.watch(authStateProvider);
    final selectedChild = authState.selectedChild;

    final generalAverage = AverageCalculator.calculateGeneralAverage(
      gradesState.filteredGrades,
    );
    final subjectAverages = AverageCalculator.calculateSubjectAverages(
      gradesState.gradesBySubject,
    );

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'MOYENNES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
          ),
        ),
        trailingActions: [
          if (generalAverage != null && subjectAverages.isNotEmpty)
            IconButton(
              icon: Icon(Icons.share_outlined, color: palette.textSecondary),
              tooltip: 'Partager le bulletin',
              onPressed: () {
                final periodName = gradesState.periods
                    .where((p) => p.codePeriode == gradesState.selectedPeriod)
                    .map((p) => p.periode)
                    .firstOrNull ?? 'Période';
                _shareBulletin(
                  context,
                  ref,
                  childName: selectedChild?.prenom ?? 'Élève',
                  periodName: periodName,
                  generalAverage: generalAverage!,
                  subjectAverages: subjectAverages,
                );
              },
            ),
        ],
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: Column(
        children: [
          if (gradesState.periods.isNotEmpty)
            Container(
              color: palette.backgroundPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: ChanelTheme.spacing4,
                vertical: ChanelTheme.spacing2,
              ),
              child: PeriodSelector(
                periods: gradesState.periods,
                selectedPeriod: gradesState.selectedPeriod,
                onPeriodChanged: (period) {
                  ref.read(gradesStateProvider.notifier).selectPeriod(period);
                },
                palette: palette,
              ),
            ),
          const Expanded(child: AveragesScreenContent()),
        ],
      ),
    );
  }
}

/// Contenu de l'écran moyennes (réutilisable dans tabs)
class AveragesScreenContent extends ConsumerWidget {
  const AveragesScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final authState = ref.watch(authStateProvider);
    final selectedChild = authState.selectedChild;

    final generalAverage = AverageCalculator.calculateGeneralAverage(
      gradesState.filteredGrades,
    );
    final subjectAverages = AverageCalculator.calculateSubjectAverages(
      gradesState.gradesBySubject,
    );

    if (gradesState.filteredGrades.isEmpty) {
      return Center(
        child: Text(
          'Aucune note pour cette période',
          style: ChanelTypography.bodyMedium.copyWith(
            color: palette.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GeneralAverageCard(
            average: generalAverage,
            childName: selectedChild?.prenom ?? '',
            palette: palette,
          ),
          const SizedBox(height: ChanelTheme.spacing6),
          Text(
            'PAR MATIÈRE',
            style: ChanelTypography.labelMedium.copyWith(
              letterSpacing: ChanelTypography.letterSpacingWider,
              color: palette.textTertiary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing3),
          ...subjectAverages.entries.map((entry) {
            return _SubjectAverageCard(
              subjectAverage: entry.value,
              palette: palette,
            );
          }),
        ],
      ),
    );
  }
}

/// Carte de la moyenne générale
class _GeneralAverageCard extends StatelessWidget {
  final double? average;
  final String childName;
  final AppColorPalette palette;

  const _GeneralAverageCard({
    required this.average,
    required this.childName,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing6),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          Text(
            'MOYENNE GÉNÉRALE',
            style: ChanelTypography.labelMedium.copyWith(
              letterSpacing: ChanelTypography.letterSpacingWider,
              color: palette.textTertiary,
            ),
          ),

          const SizedBox(height: ChanelTheme.spacing4),

          // Cercle de moyenne
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: average != null
                  ? palette.gradeColor(average!).withOpacity(0.1)
                  : palette.backgroundTertiary,
              border: Border.all(
                color: average != null
                    ? palette.gradeColor(average!)
                    : palette.borderLight,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  average != null ? average!.toStringAsFixed(2) : '--',
                  style: ChanelTypography.displaySmall.copyWith(
                    color: average != null
                        ? palette.gradeColor(average!)
                        : palette.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '/20',
                  style: ChanelTypography.labelMedium.copyWith(
                    color: palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          if (childName.isNotEmpty) ...[
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              childName,
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Carte de moyenne par matière
class _SubjectAverageCard extends StatelessWidget {
  final SubjectAverage subjectAverage;
  final AppColorPalette palette;

  const _SubjectAverageCard({
    required this.subjectAverage,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final average = subjectAverage.average;
    final progress = average != null ? average / 20 : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  subjectAverage.subjectName,
                  style: ChanelTypography.titleSmall,
                ),
              ),
              Text(
                average != null ? average.toStringAsFixed(2) : '--',
                style: ChanelTypography.headlineSmall.copyWith(
                  color: average != null
                      ? palette.gradeColor(average)
                      : palette.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '/20',
                style: ChanelTypography.labelMedium.copyWith(
                  color: palette.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: ChanelTheme.spacing3),

          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: palette.backgroundTertiary,
              valueColor: AlwaysStoppedAnimation(
                average != null
                    ? palette.gradeColor(average)
                    : palette.textMuted,
              ),
            ),
          ),

          const SizedBox(height: ChanelTheme.spacing2),

          // Métadonnées
          Row(
            children: [
              Text(
                '${subjectAverage.gradesCount} note${subjectAverage.gradesCount > 1 ? 's' : ''}',
                style: ChanelTypography.labelSmall.copyWith(
                  color: palette.textTertiary,
                ),
              ),
              if (subjectAverage.classAverage != null) ...[
                const Spacer(),
                Icon(
                  Icons.groups_outlined,
                  size: 14,
                  color: palette.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Classe: ${subjectAverage.classAverage!.toStringAsFixed(1)}',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textTertiary,
                  ),
                ),
                if (subjectAverage.differenceWithClass != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${subjectAverage.differenceWithClass! >= 0 ? '+' : ''}${subjectAverage.differenceWithClass!.toStringAsFixed(1)})',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: subjectAverage.differenceWithClass! >= 0
                          ? palette.success
                          : palette.error,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Bouton pour accéder au simulateur
class _SimulatorButton extends StatelessWidget {
  final AppColorPalette palette;
  final VoidCallback onTap;

  const _SimulatorButton({
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          border: Border.all(color: palette.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
              ),
              child: Icon(
                Icons.calculate_outlined,
                color: palette.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simulateur de notes',
                    style: ChanelTypography.titleSmall.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Calculer l\'impact d\'une future note',
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: palette.primary,
            ),
          ],
        ),
      ),
    );
  }
}

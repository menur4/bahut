import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/skeleton_widgets.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../domain/services/statistics_service.dart';
import '../providers/statistics_provider.dart';
import '../widgets/charts.dart';

/// Écran des statistiques et graphiques
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final stats = ref.watch(globalStatsProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'STATISTIQUES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
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
      body: gradesState.isLoading && gradesState.grades.isEmpty
          ? const _SkeletonStats()
          : stats.totalGrades == 0
              ? _EmptyStats(palette: palette)
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(gradesStateProvider.notifier).fetchGrades(forceRefresh: true);
                  },
                  color: palette.primary,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ChanelTheme.spacing4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Résumé en haut
                        _SummarySection(stats: stats, palette: palette),
                        const SizedBox(height: ChanelTheme.spacing6),

                        // Évolution des moyennes
                        _buildSectionTitle('Évolution', palette),
                        const SizedBox(height: ChanelTheme.spacing3),
                        Container(
                          padding: const EdgeInsets.all(ChanelTheme.spacing4),
                          decoration: BoxDecoration(
                            color: palette.backgroundCard,
                            borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                            border: Border.all(color: palette.borderLight),
                          ),
                          child: AverageEvolutionChart(
                            data: stats.evolution,
                            palette: palette,
                            height: 220,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing6),

                        // Distribution des notes
                        _buildSectionTitle('Répartition des notes', palette),
                        const SizedBox(height: ChanelTheme.spacing3),
                        Container(
                          padding: const EdgeInsets.all(ChanelTheme.spacing4),
                          decoration: BoxDecoration(
                            color: palette.backgroundCard,
                            borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                            border: Border.all(color: palette.borderLight),
                          ),
                          child: GradeDistributionChart(
                            data: stats.distribution,
                            palette: palette,
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing6),

                        // Radar des matières
                        if (stats.subjectStats.length >= 3) ...[
                          _buildSectionTitle('Comparaison par matière', palette),
                          const SizedBox(height: ChanelTheme.spacing3),
                          Container(
                            padding: const EdgeInsets.all(ChanelTheme.spacing4),
                            decoration: BoxDecoration(
                              color: palette.backgroundCard,
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                              border: Border.all(color: palette.borderLight),
                            ),
                            child: Column(
                              children: [
                                SubjectRadarChart(
                                  subjects: stats.subjectStats,
                                  palette: palette,
                                  size: 250,
                                ),
                                const SizedBox(height: ChanelTheme.spacing2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _LegendDot(color: palette.primary, label: 'Ma moyenne'),
                                    const SizedBox(width: ChanelTheme.spacing4),
                                    _LegendDot(color: palette.textMuted, label: 'Classe'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: ChanelTheme.spacing6),
                        ],

                        // Classement des matières
                        _buildSectionTitle('Classement des matières', palette),
                        const SizedBox(height: ChanelTheme.spacing3),
                        _SubjectRanking(subjects: stats.subjectStats, palette: palette),

                        const SizedBox(height: ChanelTheme.spacing8),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title, palette) {
    return Text(
      title.toUpperCase(),
      style: ChanelTypography.labelMedium.copyWith(
        color: palette.textMuted,
        letterSpacing: ChanelTypography.letterSpacingWider,
      ),
    );
  }
}

/// Section résumé avec les stats clés
class _SummarySection extends StatelessWidget {
  final GlobalStats stats;
  final dynamic palette;

  const _SummarySection({required this.stats, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Moyenne générale grande
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ChanelTheme.spacing6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [palette.primary, palette.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          ),
          child: Column(
            children: [
              Text(
                'MOYENNE GÉNÉRALE',
                style: ChanelTypography.labelMedium.copyWith(
                  color: palette.textInverse.withValues(alpha: 0.8),
                  letterSpacing: ChanelTypography.letterSpacingWider,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stats.generalAverage.toStringAsFixed(2),
                    style: ChanelTypography.displayLarge.copyWith(
                      color: palette.textInverse,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '/20',
                    style: ChanelTypography.titleLarge.copyWith(
                      color: palette.textInverse.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              if (stats.classGeneralAverage != null) ...[
                const SizedBox(height: ChanelTheme.spacing1),
                Text(
                  'Classe: ${stats.classGeneralAverage!.toStringAsFixed(2)}',
                  style: ChanelTypography.bodyMedium.copyWith(
                    color: palette.textInverse.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: ChanelTheme.spacing2),
              TrendIndicator(trend: stats.trend, palette: palette),
            ],
          ),
        ),
        const SizedBox(height: ChanelTheme.spacing4),

        // Grille de stats
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.assignment,
                label: 'Notes',
                value: stats.totalGrades.toString(),
                palette: palette,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: StatCard(
                icon: Icons.school,
                label: 'Matières',
                value: stats.totalSubjects.toString(),
                palette: palette,
              ),
            ),
          ],
        ),
        const SizedBox(height: ChanelTheme.spacing3),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                label: 'Meilleure',
                value: stats.bestAverage?.toStringAsFixed(1) ?? '-',
                subtitle: stats.bestSubject,
                color: palette.success,
                palette: palette,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: StatCard(
                icon: Icons.trending_down,
                label: 'À améliorer',
                value: stats.worstAverage?.toStringAsFixed(1) ?? '-',
                subtitle: stats.worstSubject,
                color: palette.warning,
                palette: palette,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Classement des matières
class _SubjectRanking extends StatelessWidget {
  final List<SubjectStats> subjects;
  final dynamic palette;

  const _SubjectRanking({required this.subjects, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subjects.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: palette.borderLight,
        ),
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final rank = index + 1;

          return Padding(
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            child: Row(
              children: [
                // Rang
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _getRankColor(rank).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: ChanelTypography.labelMedium.copyWith(
                        color: _getRankColor(rank),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: ChanelTheme.spacing3),

                // Nom de la matière
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.subjectName,
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subject.classAverage != null)
                        Text(
                          'Classe: ${subject.classAverage!.toStringAsFixed(1)}',
                          style: ChanelTypography.labelSmall.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),

                // Tendance
                TrendIndicator(
                  trend: subject.trend,
                  palette: palette,
                  showLabel: false,
                ),
                const SizedBox(width: ChanelTheme.spacing2),

                // Moyenne
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing3,
                    vertical: ChanelTheme.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: palette.gradeColor(subject.average).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Text(
                    subject.average.toStringAsFixed(1),
                    style: ChanelTypography.labelLarge.copyWith(
                      color: palette.gradeColor(subject.average),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700); // Or
    if (rank == 2) return const Color(0xFFC0C0C0); // Argent
    if (rank == 3) return const Color(0xFFCD7F32); // Bronze
    return palette.textMuted;
  }
}

/// Point de légende
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: ChanelTypography.labelSmall,
        ),
      ],
    );
  }
}

/// Skeleton pour le chargement
class _SkeletonStats extends ConsumerWidget {
  const _SkeletonStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      child: Column(
        children: [
          // Grande carte moyenne
          Skeleton(
            width: double.infinity,
            height: 180,
            borderRadius: ChanelTheme.radiusLg,
            palette: palette,
          ),
          const SizedBox(height: ChanelTheme.spacing4),

          // Grille de stats
          Row(
            children: [
              Expanded(child: SkeletonStatCard(palette: palette)),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(child: SkeletonStatCard(palette: palette)),
            ],
          ),
          const SizedBox(height: ChanelTheme.spacing3),
          Row(
            children: [
              Expanded(child: SkeletonStatCard(palette: palette)),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(child: SkeletonStatCard(palette: palette)),
            ],
          ),
          const SizedBox(height: ChanelTheme.spacing6),

          // Graphique
          Skeleton(
            width: double.infinity,
            height: 250,
            borderRadius: ChanelTheme.radiusMd,
            palette: palette,
          ),
        ],
      ),
    );
  }
}

/// État vide
class _EmptyStats extends StatelessWidget {
  final dynamic palette;

  const _EmptyStats({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 64,
            color: palette.textMuted,
          ),
          const SizedBox(height: ChanelTheme.spacing4),
          Text(
            'Pas de statistiques',
            style: ChanelTypography.titleLarge.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          Text(
            'Les statistiques apparaîtront\nune fois vos notes chargées',
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

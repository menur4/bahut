import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/flip_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../grades/data/models/grade_model.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../../homework/presentation/providers/homework_provider.dart';
import '../../../schedule/presentation/providers/schedule_provider.dart';
import '../../../vie_scolaire/presentation/providers/vie_scolaire_provider.dart';

/// Écran d'accueil / Dashboard
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    try {
      await Future.wait<void>([
        ref.read(gradesStateProvider.notifier).fetchGrades(),
        ref.read(homeworkStateProvider.notifier).fetchHomework(),
        ref.read(scheduleStateProvider.notifier).fetchSchedule(),
        ref.read(vieScolaireStateProvider.notifier).fetchVieScolaire(),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final authState = ref.watch(authStateProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final homeworkState = ref.watch(homeworkStateProvider);
    final scheduleState = ref.watch(scheduleStateProvider);
    final vieScolaireState = ref.watch(vieScolaireStateProvider);

    // Prénom de l'élève
    final childName = authState.children
            .where((c) => c.id == authState.selectedChildId)
            .firstOrNull
            ?.prenom ??
        'Élève';

    // Moyenne générale
    final average = gradesState.generalAverage;
    final averageStr = average != null ? average.toStringAsFixed(2) : '--';

    // Nouvelles notes
    final newGradesCount = gradesState.newGradeIds.length;

    // Devoirs à faire
    final pendingHomework = homeworkState.pendingCount;

    // Prochain cours
    final nextCourse = scheduleState.data?.nextCourse;

    // Absences/retards
    final absences = vieScolaireState.data?.absences.length ?? 0;
    final retards = vieScolaireState.data?.retards.length ?? 0;

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Column(
          children: [
            Text(
              'BONJOUR',
              style: ChanelTypography.labelSmall.copyWith(
                color: palette.textTertiary,
                letterSpacing: 2,
              ),
            ),
            Text(
              childName.toUpperCase(),
              style: ChanelTypography.titleMedium.copyWith(
                letterSpacing: ChanelTypography.letterSpacingWider,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
          actions: [
            IconButton(
              icon: _isRefreshing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.primary,
                      ),
                    )
                  : Icon(Icons.refresh, color: palette.textPrimary),
              onPressed: _isRefreshing ? null : _loadData,
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: palette.textPrimary),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: palette.backgroundPrimary,
          border: null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _isRefreshing ? null : _loadData,
                child: _isRefreshing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.primary,
                        ),
                      )
                    : Icon(Icons.refresh, color: palette.textPrimary),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Icon(Icons.settings_outlined, color: palette.textPrimary),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: palette.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte principale avec moyenne - FLIP CARD
              SizedBox(
                height: 180,
                child: FlipSummaryCard(
                  icon: Icons.school,
                  title: 'Moyenne générale',
                  mainValue: averageStr,
                  subtitle: gradesState.selectedPeriod != null
                      ? 'Période: ${gradesState.selectedPeriod}'
                      : 'Toutes périodes',
                  accentColor: average != null
                      ? palette.gradeColor(average)
                      : palette.primary,
                  flipHint: 'Appuyez pour voir les détails',
                  backContent: _buildAverageDetails(gradesState, palette),
                  backTitle: 'Détails par matière',
                  palette: palette,
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing4),

              // Alertes et notifications importantes (dynamique)
              ..._buildAlertCards(
                context: context,
                palette: palette,
                newGradesCount: newGradesCount,
                pendingHomework: pendingHomework,
                absences: absences,
                retards: retards,
                nextCourse: nextCourse,
              ),

              // Section statistiques (toujours visible)
              _buildSectionTitle('VOS NOTES', palette),
              const SizedBox(height: ChanelTheme.spacing3),

              Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.school,
                      label: 'Matières',
                      value: gradesState.gradesBySubject.length.toString(),
                      subtitle: '${gradesState.grades.length} notes',
                      palette: palette,
                      onTap: () => context.go('/averages'),
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing3),
                  Expanded(
                    child: DashboardStatCard(
                      icon: Icons.analytics_outlined,
                      label: 'Statistiques',
                      value: average?.toStringAsFixed(1) ?? '--',
                      subtitle: 'Voir l\'évolution',
                      accentColor: palette.primary,
                      palette: palette,
                      onTap: () => context.go('/statistics'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: ChanelTheme.spacing6),

              // Dernières notes
              if (gradesState.grades.isNotEmpty) ...[
                _buildSectionTitle('DERNIÈRES NOTES', palette),
                const SizedBox(height: ChanelTheme.spacing3),
                _buildRecentGrades(gradesState, palette),
              ],

              const SizedBox(height: ChanelTheme.spacing8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(left: ChanelTheme.spacing1),
      child: Text(
        title,
        style: ChanelTypography.labelSmall.copyWith(
          color: palette.textTertiary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildAverageDetails(GradesState gradesState, AppColorPalette palette) {
    final bySubject = gradesState.gradesBySubject;
    if (bySubject.isEmpty) {
      return Center(
        child: Text(
          'Aucune note pour le moment',
          style: TextStyle(color: palette.textMuted),
        ),
      );
    }

    // Calculer les moyennes par matière
    final subjectAverages = <String, double>{};
    for (final entry in bySubject.entries) {
      double sum = 0;
      double coef = 0;
      for (final grade in entry.value) {
        final val = grade.valeurSur20;
        if (val != null && grade.isValidForCalculation) {
          sum += val * grade.coefDouble;
          coef += grade.coefDouble;
        }
      }
      if (coef > 0) {
        subjectAverages[entry.key] = sum / coef;
      }
    }

    // Trier par moyenne décroissante
    final sorted = subjectAverages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length.clamp(0, 6),
      separatorBuilder: (_, __) => Divider(height: 1, color: palette.borderLight),
      itemBuilder: (context, index) {
        final entry = sorted[index];
        final avg = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: ChanelTheme.spacing2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    color: palette.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ChanelTheme.spacing2,
                  vertical: ChanelTheme.spacing1,
                ),
                decoration: BoxDecoration(
                  color: palette.gradeColor(avg).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
                child: Text(
                  avg.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: palette.gradeColor(avg),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildAlertCards({
    required BuildContext context,
    required AppColorPalette palette,
    required int newGradesCount,
    required int pendingHomework,
    required int absences,
    required int retards,
    required dynamic nextCourse,
  }) {
    final cards = <Widget>[];

    // Carte nouvelles notes (seulement si > 0)
    if (newGradesCount > 0) {
      cards.add(
        _AlertCard(
          icon: Icons.star,
          iconColor: palette.info,
          title: 'Nouvelles notes',
          value: newGradesCount.toString(),
          subtitle: newGradesCount == 1 ? 'note à découvrir' : 'notes à découvrir',
          onTap: () => context.go('/grades'),
          palette: palette,
        ),
      );
    }

    // Carte devoirs (seulement si > 0)
    if (pendingHomework > 0) {
      cards.add(
        _AlertCard(
          icon: Icons.assignment_outlined,
          iconColor: palette.warning,
          title: 'Devoirs à faire',
          value: pendingHomework.toString(),
          subtitle: pendingHomework == 1 ? 'devoir en attente' : 'devoirs en attente',
          onTap: () => context.go('/homework'),
          palette: palette,
        ),
      );
    }

    // Carte absences/retards (seulement si > 0)
    if (absences > 0 || retards > 0) {
      final parts = <String>[];
      if (absences > 0) parts.add('$absences absence${absences > 1 ? 's' : ''}');
      if (retards > 0) parts.add('$retards retard${retards > 1 ? 's' : ''}');

      cards.add(
        _AlertCard(
          icon: Icons.warning_amber_outlined,
          iconColor: palette.error,
          title: 'Vie scolaire',
          value: (absences + retards).toString(),
          subtitle: parts.join(' • '),
          onTap: () => context.go('/vie-scolaire'),
          palette: palette,
        ),
      );
    }

    // Carte prochain cours (toujours affichée si disponible)
    if (nextCourse != null) {
      cards.add(
        _AlertCard(
          icon: Icons.schedule,
          iconColor: palette.primary,
          title: 'Prochain cours',
          value: nextCourse.displayMatiere,
          subtitle: '${nextCourse.startTimeFormatted} • ${nextCourse.salle ?? ""}',
          onTap: () => context.go('/schedule'),
          palette: palette,
          isLarge: true,
        ),
      );
    }

    // Si aucune alerte, ne rien afficher
    if (cards.isEmpty) {
      return [];
    }

    // Ajouter espacement entre les cartes
    final result = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      result.add(cards[i]);
      if (i < cards.length - 1) {
        result.add(const SizedBox(height: ChanelTheme.spacing3));
      }
    }

    // Ajouter titre de section et espacement final
    return [
      _buildSectionTitle('ALERTES', palette),
      const SizedBox(height: ChanelTheme.spacing3),
      ...result,
      const SizedBox(height: ChanelTheme.spacing4),
    ];
  }

  Widget _buildRecentGrades(GradesState gradesState, AppColorPalette palette) {
    // Prendre les 5 dernières notes
    final recentGrades = gradesState.grades.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: palette.borderLight),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentGrades.length,
        separatorBuilder: (_, __) => Divider(height: 1, indent: 16, color: palette.borderLight),
        itemBuilder: (context, index) {
          final grade = recentGrades[index];
          final isNew = gradesState.isNewGrade(grade.id ?? 0);
          final subjectName = gradesState.subjectNames[grade.codeMatiere] ??
              grade.libelleMatiere ??
              grade.codeMatiere;

          return InkWell(
            onTap: () => context.go('/grades'),
            child: Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Row(
                children: [
                  // Badge nouvelle note
                  if (isNew)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: ChanelTheme.spacing2),
                      decoration: BoxDecoration(
                        color: palette.info,
                        shape: BoxShape.circle,
                      ),
                    ),

                  // Infos matière
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: palette.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (grade.dateTime != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('d MMM', 'fr_FR').format(grade.dateTime!),
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Note
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ChanelTheme.spacing3,
                      vertical: ChanelTheme.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: grade.valeurSur20 != null
                          ? palette.gradeColor(grade.valeurSur20!)
                              .withValues(alpha: 0.1)
                          : palette.backgroundTertiary,
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                    ),
                    child: Text(
                      '${grade.valeur}/${grade.noteSur}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: grade.valeurSur20 != null
                            ? palette.gradeColor(grade.valeurSur20!)
                            : palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Carte d'alerte pour le dashboard
class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;
  final AppColorPalette palette;
  final bool isLarge;

  const _AlertCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
    required this.palette,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          border: Border.all(color: palette.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: ChanelTypography.labelSmall.copyWith(
                      color: palette.textTertiary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isLarge ? 16 : 20,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: palette.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte de statistique compacte
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? accentColor;
  final AppColorPalette palette;
  final VoidCallback? onTap;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? palette.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          border: Border.all(color: palette.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: ChanelTheme.spacing2),
                Text(
                  label,
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textTertiary,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: palette.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

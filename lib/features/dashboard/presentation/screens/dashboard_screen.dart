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
import '../../../../shared/widgets/loading_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../grades/data/models/grade_model.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../../statistics/presentation/providers/goals_provider.dart';
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
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    // Déclencher le chargement immédiatement après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoading();
    });
  }

  /// Démarre le chargement des données
  void _startLoading() {
    final gradesState = ref.read(gradesStateProvider);
    final hasCache = gradesState.grades.isNotEmpty || gradesState.lastSync != null;

    if (hasCache) {
      // Données en cache disponibles - afficher immédiatement
      setState(() => _initialLoadComplete = true);
      ref.read(authStateProvider.notifier).completePostAuthLoading();
      // Rafraîchir en arrière-plan
      _refreshInBackground();
    } else {
      // Pas de cache - charger depuis l'API
      _loadData();
    }
  }

  /// Rafraîchit les données en arrière-plan sans bloquer l'UI
  Future<void> _refreshInBackground() async {
    try {
      await Future.wait<void>([
        ref.read(gradesStateProvider.notifier).fetchGrades(),
        ref.read(homeworkStateProvider.notifier).fetchHomework(),
        ref.read(scheduleStateProvider.notifier).fetchSchedule(),
        ref.read(vieScolaireStateProvider.notifier).fetchVieScolaire(),
      ]);
    } catch (_) {
      // Ignorer les erreurs de rafraîchissement en arrière-plan
    }
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
        setState(() {
          _isRefreshing = false;
          _initialLoadComplete = true;
        });
        ref.read(authStateProvider.notifier).completePostAuthLoading();
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

    // Afficher le loading pendant le chargement initial
    // On reste sur le loading tant que:
    // 1. isPostAuthLoading est actif (vient du login)
    // 2. OU le chargement initial n'est pas terminé
    if (authState.isPostAuthLoading || !_initialLoadComplete) {
      return const LoadingScreen(
        message: 'Chargement de vos données...',
      );
    }

    // Prénom de l'élève
    final childName = authState.children
            .where((c) => c.id == authState.selectedChildId)
            .firstOrNull
            ?.prenom ??
        'Élève';

    // Moyenne générale et objectif (synchronisé avec la section Stats)
    final average = gradesState.generalAverage;
    final averageStr = average != null ? average.toStringAsFixed(2) : '--';
    final goalsState = ref.watch(goalsProvider);
    final goal = goalsState.generalGoal?.targetAverage;

    // Nom de la période (ex: "Trimestre 1" au lieu de "A001")
    final periodName = gradesState.selectedPeriodName ?? gradesState.selectedPeriod;

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
                height: 200,
                child: _AverageCard(
                  average: average,
                  averageStr: averageStr,
                  periodName: periodName,
                  goal: goal,
                  palette: palette,
                  gradesState: gradesState,
                  onSetGoal: () => _showGoalDialog(context, ref, goal, palette),
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

  void _showGoalDialog(BuildContext context, WidgetRef ref, double? currentGoal, AppColorPalette palette) {
    final controller = TextEditingController(
      text: currentGoal?.toStringAsFixed(1) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.backgroundCard,
        title: Text(
          'Objectif de moyenne',
          style: TextStyle(color: palette.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Définissez votre objectif de moyenne générale (entre 0 et 20)',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Ex: 14.5',
                suffixText: '/ 20',
                filled: true,
                fillColor: palette.backgroundTertiary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (currentGoal != null)
            TextButton(
              onPressed: () {
                ref.read(goalsProvider.notifier).removeGeneralGoal();
                Navigator.pop(context);
              },
              child: Text(
                'Supprimer',
                style: TextStyle(color: palette.error),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.replaceAll(',', '.');
              final value = double.tryParse(text);
              if (value != null && value > 0 && value <= 20) {
                ref.read(goalsProvider.notifier).setGeneralGoal(value);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Valider'),
          ),
        ],
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
    // Trier les notes par date de saisie décroissante (quand elles sont apparues)
    // pour afficher les notes les plus récemment ajoutées
    final sortedGrades = List<GradeModel>.from(gradesState.grades)
      ..sort((a, b) {
        // Utiliser dateSaisie en priorité, sinon date de l'examen
        final dateA = a.dateSaisieTime ?? a.dateTime ?? DateTime(1900);
        final dateB = b.dateSaisieTime ?? b.dateTime ?? DateTime(1900);
        return dateB.compareTo(dateA); // Plus récentes en premier
      });
    final recentGrades = sortedGrades.take(5).toList();

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

/// Carte de moyenne avec objectif
class _AverageCard extends StatelessWidget {
  final double? average;
  final String averageStr;
  final String? periodName;
  final double? goal;
  final AppColorPalette palette;
  final GradesState gradesState;
  final VoidCallback onSetGoal;

  const _AverageCard({
    required this.average,
    required this.averageStr,
    required this.periodName,
    required this.goal,
    required this.palette,
    required this.gradesState,
    required this.onSetGoal,
  });

  @override
  Widget build(BuildContext context) {
    final color = average != null ? palette.gradeColor(average!) : palette.primary;

    // Calcul de la progression vers l'objectif
    double? progress;
    String? progressText;
    Color? progressColor;

    if (goal != null && average != null) {
      progress = (average! / goal!).clamp(0.0, 1.0);
      final diff = average! - goal!;
      if (diff >= 0) {
        progressText = '+${diff.toStringAsFixed(2)} pts';
        progressColor = palette.success;
      } else {
        progressText = '${diff.toStringAsFixed(2)} pts';
        progressColor = palette.error;
      }
    }

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: palette.borderLight),
        boxShadow: [
          BoxShadow(
            color: palette.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
                child: Icon(Icons.school, color: color, size: 20),
              ),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOYENNE GÉNÉRALE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: palette.textTertiary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (periodName != null)
                      Text(
                        periodName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              // Bouton objectif
              GestureDetector(
                onTap: onSetGoal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing2,
                    vertical: ChanelTheme.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: goal != null
                        ? palette.primary.withValues(alpha: 0.1)
                        : palette.backgroundTertiary,
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                    border: Border.all(
                      color: goal != null
                          ? palette.primary.withValues(alpha: 0.3)
                          : palette.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag,
                        size: 14,
                        color: goal != null ? palette.primary : palette.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        goal != null ? '${goal!.toStringAsFixed(1)}' : 'Objectif',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: goal != null ? palette.primary : palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Moyenne et progression
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Moyenne
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    averageStr,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/ 20',
                    style: TextStyle(
                      fontSize: 14,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Indicateur objectif
              if (goal != null && average != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      progressText!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: progressColor,
                      ),
                    ),
                    Text(
                      'vs objectif ${goal!.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ] else if (goal == null) ...[
                GestureDetector(
                  onTap: onSetGoal,
                  child: Text(
                    'Définir un objectif',
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Barre de progression si objectif défini
          if (goal != null && average != null) ...[
            const SizedBox(height: ChanelTheme.spacing3),
            ClipRRect(
              borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: palette.backgroundTertiary,
                valueColor: AlwaysStoppedAnimation(
                  average! >= goal! ? palette.success : palette.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

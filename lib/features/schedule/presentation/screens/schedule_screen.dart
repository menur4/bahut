import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/models/schedule_model.dart';
import '../providers/schedule_provider.dart';

/// Palette de couleurs désaturées pour les matières
class SubjectColors {
  static const Map<String, Color> colors = {
    'math': Color(0xFF86A789),      // Vert sauge
    'francais': Color(0xFF7BA7BC),  // Bleu ardoise
    'anglais': Color(0xFFC4A4A4),   // Vieux rose
    'histoire': Color(0xFFD4A574),  // Caramel
    'geo': Color(0xFFD4A574),       // Caramel
    'physique': Color(0xFFA5A0C4),  // Lavande
    'chimie': Color(0xFFA5A0C4),    // Lavande
    'svt': Color(0xFF8FBC8F),       // Vert d'eau
    'bio': Color(0xFF8FBC8F),       // Vert d'eau
    'sport': Color(0xFFCC8F7C),     // Terracotta
    'eps': Color(0xFFCC8F7C),       // Terracotta
    'musique': Color(0xFFB4A7D6),   // Mauve
    'art': Color(0xFFE6B8A2),       // Pêche
    'techno': Color(0xFF9DB4C0),    // Bleu gris
    'allemand': Color(0xFFD4B896),  // Sable
    'espagnol': Color(0xFFE8C4A4),  // Abricot
    'latin': Color(0xFFC9B99A),     // Beige
    'philo': Color(0xFFB8C4B8),     // Gris vert
    'eco': Color(0xFF9EB89E),       // Vert olive clair
    'default': Color(0xFFB0B0B0),   // Gris neutre
  };

  static Color getColor(String matiere) {
    final lower = matiere.toLowerCase();
    for (final entry in colors.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    return colors['default']!;
  }
}

/// Ecran de l'emploi du temps - Design Glassmorphism
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleStateProvider.notifier).fetchSchedule();
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(scheduleStateProvider.notifier)
        .fetchSchedule(forceRefresh: true);
  }

  void _goToPreviousDay() {
    final state = ref.read(scheduleStateProvider);
    final newDate = state.selectedDate.subtract(const Duration(days: 1));
    ref.read(scheduleStateProvider.notifier).selectDate(newDate);
    // Si on change de semaine, recharger les données
    if (newDate.weekday > state.selectedDate.weekday ||
        newDate.difference(state.selectedDate).inDays.abs() > 1) {
      ref.read(scheduleStateProvider.notifier).fetchSchedule();
    }
  }

  void _goToNextDay() {
    final state = ref.read(scheduleStateProvider);
    final newDate = state.selectedDate.add(const Duration(days: 1));
    ref.read(scheduleStateProvider.notifier).selectDate(newDate);
    // Si on change de semaine, recharger les données
    if (newDate.weekday < state.selectedDate.weekday ||
        newDate.difference(state.selectedDate).inDays.abs() > 1) {
      ref.read(scheduleStateProvider.notifier).fetchSchedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final state = ref.watch(scheduleStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PlatformScaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F5F7),
      appBar: PlatformAppBar(
        title: Text(
          'Emploi du temps',
          style: ChanelTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Column(
        children: [
          // Navigation semaine avec glassmorphism
          _WeekNavigator(
            selectedDate: state.selectedDate,
            onPreviousWeek: () {
              ref.read(scheduleStateProvider.notifier).previousWeek();
              ref.read(scheduleStateProvider.notifier).fetchSchedule();
            },
            onNextWeek: () {
              ref.read(scheduleStateProvider.notifier).nextWeek();
              ref.read(scheduleStateProvider.notifier).fetchSchedule();
            },
            onToday: () {
              ref.read(scheduleStateProvider.notifier).goToToday();
              ref.read(scheduleStateProvider.notifier).fetchSchedule();
            },
            palette: palette,
            isDark: isDark,
          ),

          // Sélecteur de jour avec flèches
          _GlassDaySelector(
            selectedDate: state.selectedDate,
            onDaySelected: (date) {
              ref.read(scheduleStateProvider.notifier).selectDate(date);
            },
            onPreviousDay: _goToPreviousDay,
            onNextDay: _goToNextDay,
            palette: palette,
            isDark: isDark,
          ),

          // Contenu avec swipe
          Expanded(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                // Swipe vers la droite = jour précédent
                if (details.primaryVelocity! > 300) {
                  _goToPreviousDay();
                }
                // Swipe vers la gauche = jour suivant
                else if (details.primaryVelocity! < -300) {
                  _goToNextDay();
                }
              },
              child: _buildContent(state, palette, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ScheduleState state, AppColorPalette palette, bool isDark) {
    if (state.isLoading && state.data == null) {
      return Center(
        child: CircularProgressIndicator(
          color: palette.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (state.errorMessage != null && state.data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: palette.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              'Connexion impossible',
              style: ChanelTypography.titleSmall.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              state.errorMessage!,
              style: ChanelTypography.bodySmall.copyWith(
                color: palette.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            TextButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final courses = state.selectedDayCourses;

    if (courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        color: palette.primary,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: palette.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        size: 40,
                        color: palette.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: ChanelTheme.spacing4),
                    Text(
                      'Journée libre',
                      style: ChanelTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: ChanelTheme.spacing2),
                    Text(
                      'Pas de cours prévu ce jour',
                      style: ChanelTypography.bodyMedium.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Construire la liste avec les pauses intercalées
    final items = _buildScheduleItems(courses);

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: ChanelTheme.spacing4,
          vertical: ChanelTheme.spacing3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is CourseModel) {
            return _GlassCourseCard(
              course: item,
              onTap: () => _showCourseDetails(context, item),
              palette: palette,
              isDark: isDark,
            );
          } else if (item is _BreakItem) {
            return _BreakCard(
              breakItem: item,
              palette: palette,
              isDark: isDark,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Construit la liste des éléments (cours + pauses)
  List<dynamic> _buildScheduleItems(List<CourseModel> courses) {
    final items = <dynamic>[];

    for (var i = 0; i < courses.length; i++) {
      final course = courses[i];
      items.add(course);

      // Vérifier s'il y a une pause avant le prochain cours
      if (i < courses.length - 1) {
        final nextCourse = courses[i + 1];
        final currentEnd = course.endDateTime;
        final nextStart = nextCourse.startDateTime;

        if (currentEnd != null && nextStart != null) {
          final gapMinutes = nextStart.difference(currentEnd).inMinutes;

          // Détecter le type de pause
          if (gapMinutes >= 10) {
            final breakItem = _detectBreakType(currentEnd, nextStart, gapMinutes);
            if (breakItem != null) {
              items.add(breakItem);
            }
          }
        }
      }
    }

    return items;
  }

  /// Détecte le type de pause selon l'heure et la durée
  _BreakItem? _detectBreakType(DateTime start, DateTime end, int durationMinutes) {
    final startHour = start.hour;
    final endHour = end.hour;

    // Pause méridienne (entre 11h30 et 14h, durée > 30 min)
    if (durationMinutes >= 30 &&
        ((startHour >= 11 && start.minute >= 30) || startHour >= 12) &&
        endHour <= 14) {
      return _BreakItem(
        type: _BreakType.lunch,
        startTime: start,
        endTime: end,
        durationMinutes: durationMinutes,
      );
    }

    // Récréation du matin (entre 9h30 et 11h, durée 10-30 min)
    if (durationMinutes >= 10 && durationMinutes <= 30 &&
        startHour >= 9 && endHour <= 11) {
      return _BreakItem(
        type: _BreakType.morningBreak,
        startTime: start,
        endTime: end,
        durationMinutes: durationMinutes,
      );
    }

    // Récréation de l'après-midi (entre 14h30 et 16h30, durée 10-30 min)
    if (durationMinutes >= 10 && durationMinutes <= 30 &&
        startHour >= 14 && endHour <= 17) {
      return _BreakItem(
        type: _BreakType.afternoonBreak,
        startTime: start,
        endTime: end,
        durationMinutes: durationMinutes,
      );
    }

    // Pause générique si > 15 min
    if (durationMinutes >= 15) {
      return _BreakItem(
        type: _BreakType.generic,
        startTime: start,
        endTime: end,
        durationMinutes: durationMinutes,
      );
    }

    return null;
  }

  void _showCourseDetails(BuildContext context, CourseModel course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GlassCourseDetailsSheet(course: course),
    );
  }
}

/// Navigateur de semaine avec effet glass
class _WeekNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onToday;
  final AppColorPalette palette;
  final bool isDark;

  const _WeekNavigator({
    required this.selectedDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onToday,
    required this.palette,
    required this.isDark,
  });

  String _formatWeekRange(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final format = DateFormat('d MMM', 'fr_FR');
    return '${format.format(monday)} - ${format.format(sunday)}';
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return ((daysDiff + firstDayOfYear.weekday - 1) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ChanelTheme.spacing4,
        vertical: ChanelTheme.spacing2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing2,
              vertical: ChanelTheme.spacing2,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: palette.textPrimary,
                  ),
                  onPressed: onPreviousWeek,
                ),
                GestureDetector(
                  onTap: onToday,
                  child: Column(
                    children: [
                      Text(
                        _formatWeekRange(selectedDate),
                        style: ChanelTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Semaine ${_getWeekNumber(selectedDate)}',
                        style: ChanelTypography.labelSmall.copyWith(
                          color: palette.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: palette.textPrimary,
                  ),
                  onPressed: onNextWeek,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sélecteur de jour avec effet glass
class _GlassDaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final AppColorPalette palette;
  final bool isDark;

  const _GlassDaySelector({
    required this.selectedDate,
    required this.onDaySelected,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.palette,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));
    final dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final today = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing2),
      padding: const EdgeInsets.symmetric(vertical: ChanelTheme.spacing2),
      child: Row(
        children: [
          // Flèche gauche
          GestureDetector(
            onTap: onPreviousDay,
            child: Container(
              width: 32,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.chevron_left,
                color: palette.textSecondary,
                size: 20,
              ),
            ),
          ),

          // Jours de la semaine
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
          final day = days[index];
          final isSelected = day.day == selectedDate.day &&
              day.month == selectedDate.month &&
              day.year == selectedDate.year;
          final isToday = day.day == today.day &&
              day.month == today.month &&
              day.year == today.year;
          final isWeekend = index >= 5;

          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.primary
                    : isToday
                        ? palette.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    dayNames[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isWeekend
                              ? palette.textMuted
                              : palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isWeekend
                              ? palette.textMuted
                              : palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
            ),
          ),

          // Flèche droite
          GestureDetector(
            onTap: onNextDay,
            child: Container(
              width: 32,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.chevron_right,
                color: palette.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte de cours avec effet glassmorphism
class _GlassCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;
  final AppColorPalette palette;
  final bool isDark;

  const _GlassCourseCard({
    required this.course,
    this.onTap,
    required this.palette,
    required this.isDark,
  });

  Color get _courseColor {
    if (course.isAnnule) return const Color(0xFFE57373);
    if (course.isModifie) return const Color(0xFFFFB74D);

    // Couleur depuis l'API si disponible
    final colorStr = course.color;
    if (colorStr != null && colorStr.isNotEmpty) {
      try {
        final hex = colorStr.replaceAll('#', '');
        final baseColor = Color(int.parse('FF$hex', radix: 16));
        // Désaturer légèrement la couleur
        final hsl = HSLColor.fromColor(baseColor);
        return hsl.withSaturation((hsl.saturation * 0.6).clamp(0.0, 1.0)).toColor();
      } catch (_) {}
    }

    return SubjectColors.getColor(course.displayMatiere);
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = course.contenuDeSeance;
    final hasHomework = course.devoirAFaire;
    final color = _courseColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.9),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête : horaire + indicateur couleur
                  Row(
                    children: [
                      // Indicateur de couleur (cercle)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Horaires
                      Text(
                        '${course.startTimeFormatted} – ${course.endTimeFormatted}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: palette.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      // Badges état
                      if (course.isAnnule)
                        _StatusBadge(
                          label: 'Annulé',
                          color: const Color(0xFFE57373),
                          isDark: isDark,
                        ),
                      if (course.isModifie && !course.isAnnule)
                        _StatusBadge(
                          label: 'Modifié',
                          color: const Color(0xFFFFB74D),
                          isDark: isDark,
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Nom de la matière
                  Text(
                    course.displayMatiere,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                      decoration: course.isAnnule
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: palette.textMuted,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Prof et salle
                  Row(
                    children: [
                      if (course.displayProf.isNotEmpty) ...[
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: palette.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.displayProf,
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                      if (course.displayProf.isNotEmpty &&
                          course.salle != null &&
                          course.salle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '•',
                            style: TextStyle(color: palette.textMuted),
                          ),
                        ),
                      if (course.salle != null && course.salle!.isNotEmpty) ...[
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: palette.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.salle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Indicateurs contenu/devoirs
                  if (hasContent || hasHomework) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (hasContent)
                          _ContentBadge(
                            icon: Icons.article_outlined,
                            label: 'Contenu',
                            color: const Color(0xFF7BA7BC),
                            isDark: isDark,
                          ),
                        if (hasContent && hasHomework)
                          const SizedBox(width: 8),
                        if (hasHomework)
                          _ContentBadge(
                            icon: Icons.edit_note,
                            label: 'Devoir',
                            color: const Color(0xFFD4A574),
                            isDark: isDark,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Badge de statut (Annulé/Modifié)
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Badge de contenu (Contenu/Devoir)
class _ContentBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _ContentBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet pour les détails d'un cours - Style Glass
class _GlassCourseDetailsSheet extends ConsumerStatefulWidget {
  final CourseModel course;

  const _GlassCourseDetailsSheet({required this.course});

  @override
  ConsumerState<_GlassCourseDetailsSheet> createState() => _GlassCourseDetailsSheetState();
}

class _GlassCourseDetailsSheetState extends ConsumerState<_GlassCourseDetailsSheet> {
  bool _isLoading = true;
  Map<String, dynamic>? _details;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await ref.read(scheduleStateProvider.notifier).fetchCourseDetails(
        widget.course.startDateTime!,
        widget.course.codeMatiere ?? '',
      );
      if (mounted) {
        setState(() {
          _details = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e.toString().contains('ServerException') || e.toString().contains('403')) {
            _error = null;
          } else {
            _error = 'Impossible de charger les détails';
          }
          _isLoading = false;
        });
      }
    }
  }

  Color get _courseColor {
    if (widget.course.isAnnule) return const Color(0xFFE57373);
    if (widget.course.isModifie) return const Color(0xFFFFB74D);
    return SubjectColors.getColor(widget.course.displayMatiere);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A1A)
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: palette.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header avec couleur de matière
          Container(
            margin: const EdgeInsets.all(ChanelTheme.spacing4),
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            decoration: BoxDecoration(
              color: _courseColor.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _courseColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    color: _courseColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: ChanelTheme.spacing3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.displayMatiere,
                        style: ChanelTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.course.startTimeFormatted} – ${widget.course.endTimeFormatted}',
                        style: ChanelTypography.bodySmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      if (widget.course.displayProf.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.course.displayProf,
                          style: ChanelTypography.bodySmall.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: palette.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(palette, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppColorPalette palette, bool isDark) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: palette.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Text(
            _error!,
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_details == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: palette.textMuted.withValues(alpha: 0.5),
              ),
              const SizedBox(height: ChanelTheme.spacing3),
              Text(
                'Aucun contenu disponible',
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_details!['contenuDeSeance'] != null) ...[
            _DetailSection(
              title: 'Contenu de séance',
              icon: Icons.article_outlined,
              color: const Color(0xFF7BA7BC),
              content: _details!['contenuDeSeance'] as String,
              isDark: isDark,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
          ],
          if (_details!['travailAFaire'] != null) ...[
            _DetailSection(
              title: 'Travail à faire',
              icon: Icons.edit_note,
              color: const Color(0xFFD4A574),
              content: _details!['travailAFaire'] as String,
              isDark: isDark,
            ),
          ],
          const SizedBox(height: ChanelTheme.spacing4),
        ],
      ),
    );
  }
}

/// Section de détail dans le bottom sheet
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;
  final bool isDark;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: ChanelTheme.spacing2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.1 : 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

/// Types de pauses
enum _BreakType {
  morningBreak,   // Récréation du matin
  lunch,          // Pause méridienne
  afternoonBreak, // Récréation de l'après-midi
  generic,        // Pause générique
}

/// Modèle pour une pause
class _BreakItem {
  final _BreakType type;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;

  const _BreakItem({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  String get label {
    switch (type) {
      case _BreakType.morningBreak:
        return 'Récréation';
      case _BreakType.lunch:
        return 'Pause déjeuner';
      case _BreakType.afternoonBreak:
        return 'Récréation';
      case _BreakType.generic:
        return 'Pause';
    }
  }

  IconData get icon {
    switch (type) {
      case _BreakType.morningBreak:
      case _BreakType.afternoonBreak:
        return Icons.directions_run;
      case _BreakType.lunch:
        return Icons.restaurant;
      case _BreakType.generic:
        return Icons.pause_circle_outline;
    }
  }

  Color get color {
    switch (type) {
      case _BreakType.morningBreak:
      case _BreakType.afternoonBreak:
        return const Color(0xFF9DB4C0); // Bleu gris
      case _BreakType.lunch:
        return const Color(0xFFD4A574); // Caramel
      case _BreakType.generic:
        return const Color(0xFFB0B0B0); // Gris
    }
  }

  String get timeFormatted {
    final startStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startStr – $endStr';
  }

  String get durationFormatted {
    if (durationMinutes >= 60) {
      final hours = durationMinutes ~/ 60;
      final mins = durationMinutes % 60;
      if (mins == 0) return '${hours}h';
      return '${hours}h${mins.toString().padLeft(2, '0')}';
    }
    return '$durationMinutes min';
  }
}

/// Carte de pause avec style subtil
class _BreakCard extends StatelessWidget {
  final _BreakItem breakItem;
  final AppColorPalette palette;
  final bool isDark;

  const _BreakCard({
    required this.breakItem,
    required this.palette,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: ChanelTheme.spacing2),
      child: Row(
        children: [
          // Ligne gauche
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    breakItem.color.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),

          // Contenu central
          Container(
            margin: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing3),
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing3,
              vertical: ChanelTheme.spacing2,
            ),
            decoration: BoxDecoration(
              color: breakItem.color.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: breakItem.color.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  breakItem.icon,
                  size: 16,
                  color: breakItem.color,
                ),
                const SizedBox(width: 8),
                Text(
                  breakItem.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: breakItem.color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  breakItem.durationFormatted,
                  style: TextStyle(
                    fontSize: 11,
                    color: breakItem.color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Ligne droite
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    breakItem.color.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

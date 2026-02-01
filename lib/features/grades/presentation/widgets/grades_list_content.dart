import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../shared/widgets/skeleton_widgets.dart';
import '../../data/models/grade_model.dart';
import '../providers/grades_provider.dart';
import 'grade_card.dart';

/// Contenu de la liste des notes (réutilisable dans différents contextes)
class GradesListContent extends ConsumerStatefulWidget {
  final AppColorPalette palette;

  const GradesListContent({super.key, required this.palette});

  @override
  ConsumerState<GradesListContent> createState() => _GradesListContentState();
}

class _GradesListContentState extends ConsumerState<GradesListContent> {
  final Map<String, bool> _expandedSubjects = {};

  Future<void> _refresh() async {
    await ref.read(gradesStateProvider.notifier).fetchGrades(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gradesStateProvider);
    return _buildContent(state, widget.palette);
  }

  Widget _buildContent(GradesState state, AppColorPalette palette) {
    if (state.isLoading && state.grades.isEmpty) {
      return const SkeletonGradesScreen();
    }

    if (state.errorMessage != null && state.grades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: palette.textMuted,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              state.errorMessage!,
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            PlatformTextButton(
              onPressed: _refresh,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state.filteredGrades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: palette.textMuted,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              'Aucune note pour cette période',
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final gradesBySubject = state.gradesBySubject;
    final generalAverage = state.generalAverage;
    final classGeneralAverage = state.classGeneralAverage;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: gradesBySubject.length + (generalAverage != null ? 1 : 0),
        itemBuilder: (context, index) {
          // Premier élément : moyenne générale
          if (generalAverage != null && index == 0) {
            return _GeneralAverageCard(
              average: generalAverage,
              classAverage: classGeneralAverage,
              palette: palette,
            );
          }

          // Ajuster l'index si la moyenne générale est affichée
          final adjustedIndex = generalAverage != null ? index - 1 : index;
          final entry = gradesBySubject.entries.elementAt(adjustedIndex);
          final subjectName = entry.key;
          final grades = entry.value;
          final isExpanded = _expandedSubjects[subjectName] ?? false;

          // Récupérer les infos de la matière
          final codeMatiere = grades.isNotEmpty ? grades.first.codeMatiere : '';
          final subjectInfo = state.getSubjectInfo(codeMatiere);

          return _SubjectSection(
            subjectName: subjectName,
            grades: grades,
            isExpanded: isExpanded,
            newGradeIds: state.newGradeIds,
            subjectInfo: subjectInfo,
            palette: palette,
            onToggle: () {
              setState(() {
                _expandedSubjects[subjectName] = !isExpanded;
              });
            },
          );
        },
      ),
    );
  }
}

class _SubjectSection extends StatelessWidget {
  final String subjectName;
  final List<GradeModel> grades;
  final bool isExpanded;
  final Set<int> newGradeIds;
  final SubjectInfo? subjectInfo;
  final VoidCallback onToggle;
  final AppColorPalette palette;

  const _SubjectSection({
    required this.subjectName,
    required this.grades,
    required this.isExpanded,
    required this.newGradeIds,
    this.subjectInfo,
    required this.onToggle,
    required this.palette,
  });

  Map<String?, List<GradeModel>> get _gradesBySubSubject {
    final map = <String?, List<GradeModel>>{};
    for (final grade in grades) {
      final subSubject = grade.subSubjectName;
      map.putIfAbsent(subSubject, () => []).add(grade);
    }
    return map;
  }

  bool get _hasSubSubjects {
    return grades.any((g) => g.subSubjectName != null);
  }

  List<Widget> _buildGradesList() {
    if (!_hasSubSubjects) {
      return grades.map((grade) => GradeCard(
        grade: grade,
        isNew: newGradeIds.contains(grade.id),
        palette: palette,
      )).toList();
    }

    final widgets = <Widget>[];
    final bySubSubject = _gradesBySubSubject;

    final sortedKeys = bySubSubject.keys.toList()
      ..sort((a, b) {
        if (a == null) return -1;
        if (b == null) return 1;
        return a.compareTo(b);
      });

    for (final subSubject in sortedKeys) {
      final subGrades = bySubSubject[subSubject]!;

      if (subSubject != null) {
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing4,
              vertical: ChanelTheme.spacing2,
            ),
            color: palette.backgroundTertiary,
            child: Row(
              children: [
                Text(
                  subSubject,
                  style: ChanelTypography.labelMedium.copyWith(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      widgets.addAll(subGrades.map((grade) => GradeCard(
        grade: grade,
        isNew: newGradeIds.contains(grade.id),
        palette: palette,
      )));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double? subjectAverage;
    double sumWeighted = 0;
    double sumCoef = 0;
    for (final grade in grades) {
      final val = grade.valeurSur20;
      if (val != null && grade.isValidForCalculation) {
        sumWeighted += val * grade.coefDouble;
        sumCoef += grade.coefDouble;
      }
    }
    if (sumCoef > 0) {
      subjectAverage = sumWeighted / sumCoef;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          style: ChanelTypography.titleMedium.copyWith(
                            color: palette.textPrimary,
                          ),
                        ),
                        if (subjectInfo?.teacher != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subjectInfo!.teacher!,
                            style: ChanelTypography.bodySmall.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (subjectAverage != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ChanelTheme.spacing3,
                            vertical: ChanelTheme.spacing1,
                          ),
                          decoration: BoxDecoration(
                            color: palette.gradeColor(subjectAverage).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                          ),
                          child: Text(
                            subjectAverage.toStringAsFixed(1),
                            style: ChanelTypography.labelLarge.copyWith(
                              color: palette.gradeColor(subjectAverage),
                            ),
                          ),
                        ),
                        if (subjectInfo?.classAverage != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Classe: ${subjectInfo!.classAverage!.toStringAsFixed(1)}',
                            style: ChanelTypography.labelSmall.copyWith(
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: ChanelTheme.spacing2),
                  ],
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: palette.borderLight),
            ..._buildGradesList(),
          ],
        ],
      ),
    );
  }
}

class _GeneralAverageCard extends StatelessWidget {
  final double average;
  final double? classAverage;
  final AppColorPalette palette;

  const _GeneralAverageCard({
    required this.average,
    this.classAverage,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing4),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOYENNE GÉNÉRALE',
                style: ChanelTypography.labelLarge.copyWith(
                  color: palette.textInverse,
                  letterSpacing: ChanelTypography.letterSpacingWider,
                ),
              ),
              if (classAverage != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Classe: ${classAverage!.toStringAsFixed(2)}',
                  style: ChanelTypography.bodySmall.copyWith(
                    color: palette.textInverse.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing4,
              vertical: ChanelTheme.spacing2,
            ),
            decoration: BoxDecoration(
              color: palette.backgroundCard,
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Text(
              average.toStringAsFixed(2),
              style: ChanelTypography.headlineMedium.copyWith(
                color: palette.gradeColor(average),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

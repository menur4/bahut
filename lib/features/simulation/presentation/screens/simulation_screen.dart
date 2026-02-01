import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../domain/models/simulated_grade.dart';
import '../providers/simulation_provider.dart';

/// Écran de simulation de notes
class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final simulationResult = ref.watch(simulationResultProvider);
    final simulationState = ref.watch(simulationProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'SIMULATEUR',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
          actions: [
            if (simulationState.simulatedGrades.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete_sweep, color: palette.error),
                onPressed: _confirmClearAll,
                tooltip: 'Tout effacer',
              ),
          ],
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
          trailing: simulationState.simulatedGrades.isNotEmpty
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _confirmClearAll,
                  child: Icon(Icons.delete_sweep, color: palette.error),
                )
              : null,
        ),
      ),
      body: gradesState.grades.isEmpty
          ? _EmptyState(palette: palette)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carte de comparaison des moyennes
                  _AverageComparisonCard(
                    result: simulationResult,
                    palette: palette,
                  ),
                  const SizedBox(height: ChanelTheme.spacing6),

                  // Bouton ajouter une note
                  _AddGradeButton(
                    onPressed: () => _showAddGradeSheet(context),
                    palette: palette,
                  ),
                  const SizedBox(height: ChanelTheme.spacing6),

                  // Liste des notes simulées
                  if (simulationState.simulatedGrades.isNotEmpty) ...[
                    _buildSectionHeader('NOTES SIMULÉES', palette),
                    const SizedBox(height: ChanelTheme.spacing3),
                    _SimulatedGradesList(
                      grades: simulationState.simulatedGrades,
                      onDelete: (id) {
                        ref.read(hapticServiceProvider).lightImpact();
                        ref.read(simulationProvider.notifier).removeSimulatedGrade(id);
                      },
                      onEdit: (grade) => _showEditGradeSheet(context, grade),
                      palette: palette,
                    ),
                    const SizedBox(height: ChanelTheme.spacing6),
                  ],

                  // Impact par matière
                  if (simulationResult.subjectResults.isNotEmpty) ...[
                    _buildSectionHeader('IMPACT PAR MATIÈRE', palette),
                    const SizedBox(height: ChanelTheme.spacing3),
                    _SubjectImpactList(
                      results: simulationResult.subjectResults,
                      palette: palette,
                    ),
                  ],

                  const SizedBox(height: ChanelTheme.spacing8),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, dynamic palette) {
    return Text(
      title,
      style: ChanelTypography.labelMedium.copyWith(
        color: palette.textMuted,
        letterSpacing: ChanelTypography.letterSpacingWider,
      ),
    );
  }

  void _confirmClearAll() {
    final palette = ref.read(currentPaletteProvider);
    showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Effacer toutes les simulations ?'),
        content: const Text(
          'Cette action supprimera toutes les notes simulées.',
        ),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          PlatformDialogAction(
            onPressed: () {
              Navigator.pop(context);
              ref.read(hapticServiceProvider).mediumImpact();
              ref.read(simulationProvider.notifier).clearAllSimulatedGrades();
            },
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: true,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

  void _showAddGradeSheet(BuildContext context) {
    final gradesState = ref.read(gradesStateProvider);
    final subjects = gradesState.gradesBySubject.keys.toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddGradeSheet(
        subjects: subjects,
        subjectCodes: gradesState.gradesBySubjectCode,
        onAdd: (subjectCode, subjectName, value, maxValue, coef) {
          ref.read(hapticServiceProvider).mediumImpact();
          ref.read(simulationProvider.notifier).addSimulatedGrade(
            subjectCode: subjectCode,
            subjectName: subjectName,
            value: value,
            maxValue: maxValue,
            coefficient: coef,
          );
        },
      ),
    );
  }

  void _showEditGradeSheet(BuildContext context, SimulatedGrade grade) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditGradeSheet(
        grade: grade,
        onSave: (updatedGrade) {
          ref.read(hapticServiceProvider).mediumImpact();
          ref.read(simulationProvider.notifier).updateSimulatedGrade(updatedGrade);
        },
      ),
    );
  }
}

/// Carte de comparaison des moyennes
class _AverageComparisonCard extends StatelessWidget {
  final SimulationResult result;
  final dynamic palette;

  const _AverageComparisonCard({
    required this.result,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final hasChange = result.generalAverageChange != null &&
        result.generalAverageChange!.abs() > 0.001;
    final isPositive = (result.generalAverageChange ?? 0) >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ChanelTheme.spacing5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasChange
              ? (isPositive
                  ? [palette.success, palette.success.withValues(alpha: 0.8)]
                  : [palette.warning, palette.warning.withValues(alpha: 0.8)])
              : [palette.primary, palette.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
      ),
      child: Column(
        children: [
          // Label
          Text(
            hasChange ? 'MOYENNE SIMULÉE' : 'MOYENNE ACTUELLE',
            style: ChanelTypography.labelMedium.copyWith(
              color: palette.textInverse.withValues(alpha: 0.8),
              letterSpacing: ChanelTypography.letterSpacingWider,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),

          // Moyenne simulée
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result.simulatedGeneralAverage?.toStringAsFixed(2) ?? '--',
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

          // Évolution
          if (hasChange) ...[
            const SizedBox(height: ChanelTheme.spacing3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ChanelTheme.spacing3,
                vertical: ChanelTheme.spacing2,
              ),
              decoration: BoxDecoration(
                color: palette.textInverse.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: palette.textInverse,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    result.generalAverageChangeFormatted,
                    style: ChanelTypography.labelLarge.copyWith(
                      color: palette.textInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' pts',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: palette.textInverse.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              'Actuelle: ${result.currentGeneralAverage?.toStringAsFixed(2) ?? '--'}',
              style: ChanelTypography.bodySmall.copyWith(
                color: palette.textInverse.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bouton pour ajouter une note
class _AddGradeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final dynamic palette;

  const _AddGradeButton({
    required this.onPressed,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          border: Border.all(
            color: palette.primary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: palette.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Text(
              'Simuler une note',
              style: ChanelTypography.titleSmall.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Liste des notes simulées
class _SimulatedGradesList extends StatelessWidget {
  final List<SimulatedGrade> grades;
  final void Function(String id) onDelete;
  final void Function(SimulatedGrade grade) onEdit;
  final dynamic palette;

  const _SimulatedGradesList({
    required this.grades,
    required this.onDelete,
    required this.onEdit,
    required this.palette,
  });

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
        itemCount: grades.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: palette.borderLight,
        ),
        itemBuilder: (context, index) {
          final grade = grades[index];
          return Dismissible(
            key: Key(grade.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: ChanelTheme.spacing4),
              color: palette.error,
              child: Icon(
                Icons.delete,
                color: palette.textInverse,
              ),
            ),
            onDismissed: (_) => onDelete(grade.id),
            child: InkWell(
              onTap: () => onEdit(grade),
              child: Padding(
                padding: const EdgeInsets.all(ChanelTheme.spacing4),
                child: Row(
                  children: [
                    // Note
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: palette.gradeColor(grade.valueSur20).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                      ),
                      child: Center(
                        child: Text(
                          grade.value.toStringAsFixed(grade.value == grade.value.roundToDouble() ? 0 : 1),
                          style: ChanelTypography.titleLarge.copyWith(
                            color: palette.gradeColor(grade.valueSur20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: ChanelTheme.spacing3),

                    // Infos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grade.subjectName,
                            style: ChanelTypography.bodyMedium.copyWith(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '/${grade.maxValue.toStringAsFixed(0)} • Coef ${grade.coefficient.toStringAsFixed(grade.coefficient == grade.coefficient.roundToDouble() ? 0 : 1)}',
                            style: ChanelTypography.labelSmall.copyWith(
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Icône édition
                    Icon(
                      Icons.edit_outlined,
                      color: palette.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Liste des impacts par matière
class _SubjectImpactList extends StatelessWidget {
  final Map<String, SubjectSimulationResult> results;
  final dynamic palette;

  const _SubjectImpactList({
    required this.results,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    // Trier par impact (les plus gros changements en premier)
    final sortedEntries = results.entries.toList()
      ..sort((a, b) {
        final aChange = a.value.averageChange?.abs() ?? 0;
        final bChange = b.value.averageChange?.abs() ?? 0;
        return bChange.compareTo(aChange);
      });

    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedEntries.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: palette.borderLight,
        ),
        itemBuilder: (context, index) {
          final entry = sortedEntries[index];
          final result = entry.value;
          final hasChange = result.addedGradesCount > 0;
          final isPositive = (result.averageChange ?? 0) >= 0;

          return Padding(
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            child: Row(
              children: [
                // Nom matière
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.subjectName,
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (hasChange)
                        Text(
                          '+${result.addedGradesCount} note${result.addedGradesCount > 1 ? 's' : ''} simulée${result.addedGradesCount > 1 ? 's' : ''}',
                          style: ChanelTypography.labelSmall.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),

                // Évolution
                if (hasChange && result.averageChange != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ChanelTheme.spacing2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositive ? palette.success : palette.warning)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: isPositive ? palette.success : palette.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          result.averageChangeFormatted,
                          style: ChanelTypography.labelSmall.copyWith(
                            color: isPositive ? palette.success : palette.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                ],

                // Moyenne simulée
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing3,
                    vertical: ChanelTheme.spacing1,
                  ),
                  decoration: BoxDecoration(
                    color: palette.gradeColor(result.simulatedAverage ?? 10)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Text(
                    result.simulatedAverage?.toStringAsFixed(2) ?? '--',
                    style: ChanelTypography.labelLarge.copyWith(
                      color: palette.gradeColor(result.simulatedAverage ?? 10),
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
}

/// Sheet pour ajouter une note
class _AddGradeSheet extends ConsumerStatefulWidget {
  final List<String> subjects;
  final Map<String, List<dynamic>> subjectCodes;
  final void Function(
    String subjectCode,
    String subjectName,
    double value,
    double maxValue,
    double coefficient,
  ) onAdd;

  const _AddGradeSheet({
    required this.subjects,
    required this.subjectCodes,
    required this.onAdd,
  });

  @override
  ConsumerState<_AddGradeSheet> createState() => _AddGradeSheetState();
}

class _AddGradeSheetState extends ConsumerState<_AddGradeSheet> {
  String? _selectedSubject;
  final _valueController = TextEditingController();
  final _maxValueController = TextEditingController(text: '20');
  final _coefController = TextEditingController(text: '1');

  @override
  void dispose() {
    _valueController.dispose();
    _maxValueController.dispose();
    _coefController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedSubject == null) return;

    final value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    final maxValue = double.tryParse(_maxValueController.text.replaceAll(',', '.')) ?? 20;
    final coef = double.tryParse(_coefController.text.replaceAll(',', '.')) ?? 1;

    if (value == null || value < 0 || value > maxValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valeur de note invalide')),
      );
      return;
    }

    // Trouver le code de la matière
    String subjectCode = _selectedSubject!;
    final gradesState = ref.read(gradesStateProvider);
    // Chercher dans subjectNames (codeMatiere -> nom)
    for (final entry in gradesState.subjectNames.entries) {
      if (entry.value == _selectedSubject) {
        subjectCode = entry.key;
        break;
      }
    }

    widget.onAdd(subjectCode, _selectedSubject!, value, maxValue, coef);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ChanelTheme.radiusLg),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing4),

              // Titre
              Text(
                'Simuler une note',
                style: ChanelTypography.titleLarge.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing4),

              // Sélection matière
              Text(
                'Matière',
                style: ChanelTypography.labelMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing3),
                decoration: BoxDecoration(
                  color: palette.backgroundTertiary,
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  border: Border.all(color: palette.borderLight),
                ),
                child: DropdownButton<String>(
                  value: _selectedSubject,
                  hint: Text(
                    'Sélectionner une matière',
                    style: TextStyle(color: palette.textMuted),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: palette.backgroundCard,
                  items: widget.subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(
                        subject,
                        style: TextStyle(color: palette.textPrimary),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing4),

              // Note et barème
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _valueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: '15',
                            hintStyle: TextStyle(color: palette.textMuted),
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sur',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _maxValueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: '20',
                            hintStyle: TextStyle(color: palette.textMuted),
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coef',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _coefController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            hintText: '1',
                            hintStyle: TextStyle(color: palette.textMuted),
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ChanelTheme.spacing6),

              // Bouton ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSubject != null ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: palette.textInverse,
                    padding: const EdgeInsets.symmetric(vertical: ChanelTheme.spacing4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                    ),
                  ),
                  child: Text(
                    'Ajouter la simulation',
                    style: ChanelTypography.labelLarge.copyWith(
                      color: palette.textInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sheet pour éditer une note
class _EditGradeSheet extends ConsumerStatefulWidget {
  final SimulatedGrade grade;
  final void Function(SimulatedGrade) onSave;

  const _EditGradeSheet({
    required this.grade,
    required this.onSave,
  });

  @override
  ConsumerState<_EditGradeSheet> createState() => _EditGradeSheetState();
}

class _EditGradeSheetState extends ConsumerState<_EditGradeSheet> {
  late TextEditingController _valueController;
  late TextEditingController _maxValueController;
  late TextEditingController _coefController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.grade.value.toString(),
    );
    _maxValueController = TextEditingController(
      text: widget.grade.maxValue.toString(),
    );
    _coefController = TextEditingController(
      text: widget.grade.coefficient.toString(),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    _maxValueController.dispose();
    _coefController.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_valueController.text.replaceAll(',', '.'));
    final maxValue = double.tryParse(_maxValueController.text.replaceAll(',', '.')) ?? 20;
    final coef = double.tryParse(_coefController.text.replaceAll(',', '.')) ?? 1;

    if (value == null || value < 0 || value > maxValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valeur de note invalide')),
      );
      return;
    }

    widget.onSave(widget.grade.copyWith(
      value: value,
      maxValue: maxValue,
      coefficient: coef,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ChanelTheme.radiusLg),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing4),

              // Titre
              Text(
                'Modifier la simulation',
                style: ChanelTypography.titleLarge.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              Text(
                widget.grade.subjectName,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing4),

              // Note et barème
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _valueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sur',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _maxValueController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: ChanelTheme.spacing3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coef',
                          style: ChanelTypography.labelMedium.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: ChanelTheme.spacing2),
                        TextField(
                          controller: _coefController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: palette.textPrimary),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: palette.backgroundTertiary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                              borderSide: BorderSide(color: palette.borderLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ChanelTheme.spacing6),

              // Bouton sauvegarder
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: palette.primary,
                    foregroundColor: palette.textInverse,
                    padding: const EdgeInsets.symmetric(vertical: ChanelTheme.spacing4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                    ),
                  ),
                  child: Text(
                    'Enregistrer',
                    style: ChanelTypography.labelLarge.copyWith(
                      color: palette.textInverse,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// État vide
class _EmptyState extends StatelessWidget {
  final dynamic palette;

  const _EmptyState({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calculate_outlined,
            size: 64,
            color: palette.textMuted,
          ),
          const SizedBox(height: ChanelTheme.spacing4),
          Text(
            'Pas de notes',
            style: ChanelTypography.titleLarge.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          Text(
            'Chargez d\'abord vos notes\npour utiliser le simulateur',
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

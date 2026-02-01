import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/grades/data/models/grade_model.dart';
import '../../features/grades/presentation/providers/grades_provider.dart';
import '../../features/homework/data/models/homework_model.dart';
import '../../features/homework/presentation/providers/homework_provider.dart';
import '../../features/schedule/data/models/schedule_model.dart';
import '../../features/schedule/presentation/providers/schedule_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'home_widget_service.dart';
import 'quick_actions_service.dart';
import 'spotlight_service.dart';

/// Provider pour le service d'intégration système
final systemIntegrationServiceProvider = Provider<SystemIntegrationService>((ref) {
  return SystemIntegrationService(ref);
});

/// Service qui coordonne les mises à jour des widgets, quick actions et Spotlight
class SystemIntegrationService {
  final Ref _ref;

  final HomeWidgetService _homeWidgetService = HomeWidgetService();
  final QuickActionsService _quickActionsService = QuickActionsService();
  final SpotlightService _spotlightService = SpotlightService();

  SystemIntegrationService(this._ref);

  /// Initialise les listeners pour les mises à jour automatiques
  Future<void> setupListeners() async {
    await _homeWidgetService.initialize();
    await _quickActionsService.initialize();
    await _spotlightService.initialize();

    debugPrint('[SYSTEM_INTEGRATION] Listeners configurés');
  }

  /// Met à jour toutes les intégrations système avec les données actuelles
  Future<void> updateAll() async {
    try {
      final gradesState = _ref.read(gradesStateProvider);
      final homeworkState = _ref.read(homeworkStateProvider);
      final scheduleState = _ref.read(scheduleStateProvider);
      final authState = _ref.read(authStateProvider);

      final childName = authState.selectedChild?.prenom;

      // Mettre à jour les widgets d'écran d'accueil
      await _updateWidgets(
        gradesState: gradesState,
        homeworkState: homeworkState,
        scheduleState: scheduleState,
        childName: childName,
      );

      // Mettre à jour les Quick Actions
      await _updateQuickActions(
        newGradesCount: gradesState.newGradeIds.length,
        pendingHomeworkCount: homeworkState.pendingCount,
      );

      // Mettre à jour l'index Spotlight (iOS uniquement)
      if (Platform.isIOS) {
        await _updateSpotlight(
          grades: gradesState.grades,
          subjectInfos: gradesState.subjectInfos,
        );
      }

      debugPrint('[SYSTEM_INTEGRATION] Toutes les intégrations mises à jour');
    } catch (e) {
      debugPrint('[SYSTEM_INTEGRATION] Erreur mise à jour: $e');
    }
  }

  /// Met à jour les widgets d'écran d'accueil
  Future<void> _updateWidgets({
    required GradesState gradesState,
    required HomeworkState homeworkState,
    required ScheduleState scheduleState,
    String? childName,
  }) async {
    // Widget de moyenne
    if (gradesState.generalAverage != null) {
      await _homeWidgetService.updateAverageWidget(
        generalAverage: gradesState.generalAverage!,
        classAverage: gradesState.classGeneralAverage,
        gradeCount: gradesState.grades.length,
        childName: childName,
      );
    }

    // Widget des devoirs
    await _homeWidgetService.updateHomeworkWidget(
      homework: homeworkState.data?.homeworks ?? [],
    );

    // Widget d'emploi du temps
    await _homeWidgetService.updateScheduleWidget(
      scheduleData: scheduleState.data,
    );
  }

  /// Met à jour les Quick Actions
  Future<void> _updateQuickActions({
    required int newGradesCount,
    required int pendingHomeworkCount,
  }) async {
    await _quickActionsService.updateShortcuts(
      newGradesCount: newGradesCount,
      pendingHomeworkCount: pendingHomeworkCount,
    );
  }

  /// Met à jour l'index Spotlight
  Future<void> _updateSpotlight({
    required List<GradeModel> grades,
    required Map<String, SubjectInfo> subjectInfos,
  }) async {
    // Préparer les données des matières pour Spotlight
    final subjectsForSpotlight = <String, ({String name, double average, double? classAverage})>{};

    // Calculer les moyennes par matière
    final gradesBySubject = <String, List<GradeModel>>{};
    for (final grade in grades) {
      gradesBySubject.putIfAbsent(grade.codeMatiere, () => []).add(grade);
    }

    for (final entry in gradesBySubject.entries) {
      final code = entry.key;
      final subjectGrades = entry.value;
      final info = subjectInfos[code];

      if (info != null) {
        // Calculer la moyenne
        double sum = 0;
        double coef = 0;
        for (final grade in subjectGrades) {
          final val = grade.valeurSur20;
          if (val != null && grade.isValidForCalculation) {
            sum += val * grade.coefDouble;
            coef += grade.coefDouble;
          }
        }
        final average = coef > 0 ? sum / coef : 0.0;

        subjectsForSpotlight[code] = (
          name: info.name,
          average: average,
          classAverage: info.classAverage,
        );
      }
    }

    // Mettre à jour l'index Spotlight
    await _spotlightService.updateFullIndex(
      grades: grades,
      subjects: subjectsForSpotlight,
    );
  }

  /// Met à jour uniquement le widget de moyenne
  Future<void> updateAverageWidget({
    required double average,
    double? classAverage,
    required int gradeCount,
    String? childName,
  }) async {
    await _homeWidgetService.updateAverageWidget(
      generalAverage: average,
      classAverage: classAverage,
      gradeCount: gradeCount,
      childName: childName,
    );
  }

  /// Met à jour uniquement le widget des devoirs
  Future<void> updateHomeworkWidget(List<HomeworkModel> homework) async {
    await _homeWidgetService.updateHomeworkWidget(homework: homework);
  }

  /// Met à jour uniquement le widget d'emploi du temps
  Future<void> updateScheduleWidget(ScheduleData? scheduleData) async {
    await _homeWidgetService.updateScheduleWidget(scheduleData: scheduleData);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../grades/presentation/providers/grades_provider.dart';
import '../../domain/services/statistics_service.dart';

/// Provider pour les statistiques globales
final globalStatsProvider = Provider<GlobalStats>((ref) {
  final gradesState = ref.watch(gradesStateProvider);

  if (gradesState.filteredGrades.isEmpty) {
    return const GlobalStats(
      generalAverage: 0,
      totalGrades: 0,
      totalSubjects: 0,
    );
  }

  // Récupérer les moyennes de classe depuis le state
  final classAverages = <String, double>{};
  for (final entry in gradesState.subjectInfos.entries) {
    if (entry.value.classAverage != null) {
      classAverages[entry.key] = entry.value.classAverage!;
    }
  }

  return StatisticsService.calculateGlobalStats(
    gradesState.filteredGrades,
    classAverages: classAverages,
    classGeneralAverage: gradesState.classGeneralAverage,
  );
});

/// Provider pour les statistiques d'une matière spécifique
final subjectStatsProvider = Provider.family<SubjectStats?, String>((ref, subjectCode) {
  final stats = ref.watch(globalStatsProvider);

  try {
    return stats.subjectStats.firstWhere(
      (s) => s.subjectCode == subjectCode,
    );
  } catch (_) {
    return null;
  }
});

/// Provider pour la tendance globale
final globalTrendProvider = Provider<double>((ref) {
  return ref.watch(globalStatsProvider).trend;
});

/// Provider pour les matières triées par performance
final subjectsByPerformanceProvider = Provider<List<SubjectStats>>((ref) {
  final stats = ref.watch(globalStatsProvider);
  return stats.subjectStats;
});

/// Provider pour les matières en difficulté (< 10)
final strugglingSubjectsProvider = Provider<List<SubjectStats>>((ref) {
  final subjects = ref.watch(subjectsByPerformanceProvider);
  return subjects.where((s) => s.average < 10).toList();
});

/// Provider pour les matières excellentes (>= 16)
final excellentSubjectsProvider = Provider<List<SubjectStats>>((ref) {
  final subjects = ref.watch(subjectsByPerformanceProvider);
  return subjects.where((s) => s.average >= 16).toList();
});

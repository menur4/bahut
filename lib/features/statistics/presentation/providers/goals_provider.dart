import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../grades/presentation/providers/grades_provider.dart';
import '../../domain/models/goal_model.dart';
import '../../domain/services/statistics_service.dart';
import 'statistics_provider.dart';

const _goalsKey = 'user_goals';

/// État des objectifs
class GoalsState {
  final GoalModel? generalGoal;
  final Map<String, GoalModel> subjectGoals;
  final bool isLoading;

  const GoalsState({
    this.generalGoal,
    this.subjectGoals = const {},
    this.isLoading = true,
  });

  GoalsState copyWith({
    GoalModel? generalGoal,
    Map<String, GoalModel>? subjectGoals,
    bool? isLoading,
    bool clearGeneralGoal = false,
  }) {
    return GoalsState(
      generalGoal: clearGeneralGoal ? null : (generalGoal ?? this.generalGoal),
      subjectGoals: subjectGoals ?? this.subjectGoals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider pour les objectifs
final goalsProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  return GoalsNotifier(ref);
});

/// Notifier pour gérer les objectifs
class GoalsNotifier extends StateNotifier<GoalsState> {
  final Ref _ref;

  GoalsNotifier(this._ref) : super(const GoalsState()) {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_goalsKey);

      if (json != null) {
        final decoded = jsonDecode(json) as Map<String, dynamic>;

        GoalModel? generalGoal;
        if (decoded['generalGoal'] != null) {
          generalGoal = GoalModel.fromJson(
            decoded['generalGoal'] as Map<String, dynamic>,
          );
        }

        final subjectGoals = <String, GoalModel>{};
        if (decoded['subjectGoals'] != null) {
          final subjectsMap = decoded['subjectGoals'] as Map<String, dynamic>;
          for (final entry in subjectsMap.entries) {
            subjectGoals[entry.key] = GoalModel.fromJson(
              entry.value as Map<String, dynamic>,
            );
          }
        }

        state = GoalsState(
          generalGoal: generalGoal,
          subjectGoals: subjectGoals,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _saveGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {
        'generalGoal': state.generalGoal?.toJson(),
        'subjectGoals': state.subjectGoals.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
      };
      await prefs.setString(_goalsKey, jsonEncode(data));
    } catch (e) {
      // Ignorer les erreurs de sauvegarde
    }
  }

  /// Définit l'objectif de moyenne générale
  Future<void> setGeneralGoal(double targetAverage) async {
    final goal = GoalModel(
      targetAverage: targetAverage,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(generalGoal: goal);
    await _saveGoals();
  }

  /// Définit l'objectif pour une matière
  Future<void> setSubjectGoal({
    required String subjectCode,
    required String subjectName,
    required double targetAverage,
    DateTime? deadline,
  }) async {
    final goal = GoalModel(
      targetAverage: targetAverage,
      subjectCode: subjectCode,
      subjectName: subjectName,
      createdAt: DateTime.now(),
      deadline: deadline,
    );
    final newGoals = Map<String, GoalModel>.from(state.subjectGoals);
    newGoals[subjectCode] = goal;
    state = state.copyWith(subjectGoals: newGoals);
    await _saveGoals();
  }

  /// Supprime l'objectif de moyenne générale
  Future<void> removeGeneralGoal() async {
    state = state.copyWith(clearGeneralGoal: true);
    await _saveGoals();
  }

  /// Supprime l'objectif d'une matière
  Future<void> removeSubjectGoal(String subjectCode) async {
    final newGoals = Map<String, GoalModel>.from(state.subjectGoals);
    newGoals.remove(subjectCode);
    state = state.copyWith(subjectGoals: newGoals);
    await _saveGoals();
  }

  /// Supprime tous les objectifs
  Future<void> clearAllGoals() async {
    state = const GoalsState(isLoading: false);
    await _saveGoals();
  }
}

/// Provider pour la prédiction de l'objectif général
final generalGoalPredictionProvider = Provider<GoalPrediction?>((ref) {
  final goalsState = ref.watch(goalsProvider);
  final stats = ref.watch(globalStatsProvider);

  if (goalsState.generalGoal == null || stats.totalGrades == 0) {
    return null;
  }

  return _calculatePrediction(
    currentAverage: stats.generalAverage,
    targetAverage: goalsState.generalGoal!.targetAverage,
    totalGrades: stats.totalGrades,
  );
});

/// Provider pour la prédiction d'un objectif de matière
final subjectGoalPredictionProvider =
    Provider.family<GoalPrediction?, String>((ref, subjectCode) {
  final goalsState = ref.watch(goalsProvider);
  final stats = ref.watch(globalStatsProvider);

  final goal = goalsState.subjectGoals[subjectCode];
  if (goal == null) return null;

  final subjectStats = stats.subjectStats.where(
    (s) => s.subjectCode == subjectCode,
  );
  if (subjectStats.isEmpty) return null;

  final subject = subjectStats.first;

  return _calculatePrediction(
    currentAverage: subject.average,
    targetAverage: goal.targetAverage,
    totalGrades: subject.gradeCount,
  );
});

/// Calcule la prédiction pour atteindre un objectif
GoalPrediction _calculatePrediction({
  required double currentAverage,
  required double targetAverage,
  required int totalGrades,
}) {
  final gap = targetAverage - currentAverage;
  final isAchieved = gap <= 0;

  if (isAchieved) {
    return GoalPrediction(
      currentAverage: currentAverage,
      targetAverage: targetAverage,
      gap: 0,
      estimatedGradesNeeded: 0,
      requiredAverageForNextGrades: 0,
      progressPercentage: 100,
      isAchievable: true,
      advice: 'Objectif atteint ! Continue comme ça !',
    );
  }

  // Calculer le nombre de notes nécessaires pour atteindre l'objectif
  // avec une moyenne de 16/20 sur les prochaines notes
  final targetWithGoodGrades = 16.0;
  int gradesNeeded = 1;

  // Formule: (currentAverage * totalGrades + targetWithGoodGrades * gradesNeeded) / (totalGrades + gradesNeeded) >= targetAverage
  while (gradesNeeded <= 50) {
    final newAverage = (currentAverage * totalGrades +
            targetWithGoodGrades * gradesNeeded) /
        (totalGrades + gradesNeeded);
    if (newAverage >= targetAverage) break;
    gradesNeeded++;
  }

  // Calculer la moyenne requise pour atteindre l'objectif en 3 notes
  final notesForCalc = 3;
  // (currentAverage * totalGrades + x * notesForCalc) / (totalGrades + notesForCalc) = targetAverage
  // x = (targetAverage * (totalGrades + notesForCalc) - currentAverage * totalGrades) / notesForCalc
  final requiredAvg = (targetAverage * (totalGrades + notesForCalc) -
          currentAverage * totalGrades) /
      notesForCalc;

  final isAchievable = requiredAvg <= 20;

  // Calculer la progression (0 = objectif, 20 = point de départ si objectif > actuel)
  double progressPercentage;
  if (targetAverage <= 0) {
    progressPercentage = 100;
  } else if (currentAverage >= targetAverage) {
    progressPercentage = 100;
  } else {
    // Supposons qu'on part de 0 ou d'une moyenne basse
    final startPoint = (targetAverage - 5).clamp(0, targetAverage);
    final totalRange = targetAverage - startPoint;
    final progressRange = currentAverage - startPoint;
    progressPercentage = totalRange > 0
        ? ((progressRange / totalRange) * 100).clamp(0, 100)
        : 100;
  }

  // Générer un conseil
  String advice;
  if (!isAchievable) {
    advice =
        'Cet objectif est ambitieux. Il faudrait plus de ${requiredAvg.toStringAsFixed(1)}/20 sur les prochaines notes.';
  } else if (gap < 0.5) {
    advice = 'Tu y es presque ! Encore un petit effort.';
  } else if (gap < 1) {
    advice =
        'Continue sur cette lancée. Vise ${requiredAvg.toStringAsFixed(1)}/20 en moyenne.';
  } else if (gap < 2) {
    advice =
        'Il te faudra environ $gradesNeeded bonnes notes pour atteindre ton objectif.';
  } else {
    advice =
        'Objectif ambitieux ! Avec des notes à ${targetWithGoodGrades.toStringAsFixed(0)}/20, il faudra $gradesNeeded notes.';
  }

  return GoalPrediction(
    currentAverage: currentAverage,
    targetAverage: targetAverage,
    gap: gap,
    estimatedGradesNeeded: gradesNeeded,
    requiredAverageForNextGrades: requiredAvg.clamp(0, 20),
    progressPercentage: progressPercentage,
    isAchievable: isAchievable,
    advice: advice,
  );
}

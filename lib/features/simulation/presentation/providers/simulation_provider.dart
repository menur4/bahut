import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../grades/data/models/grade_model.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../domain/models/simulated_grade.dart';

/// Clé de stockage des notes simulées
const _simulatedGradesKey = 'simulated_grades';

/// État de la simulation
class SimulationState {
  final List<SimulatedGrade> simulatedGrades;
  final bool isCalculating;

  const SimulationState({
    this.simulatedGrades = const [],
    this.isCalculating = false,
  });

  SimulationState copyWith({
    List<SimulatedGrade>? simulatedGrades,
    bool? isCalculating,
  }) {
    return SimulationState(
      simulatedGrades: simulatedGrades ?? this.simulatedGrades,
      isCalculating: isCalculating ?? this.isCalculating,
    );
  }
}

/// Provider pour la simulation
final simulationProvider =
    StateNotifierProvider<SimulationNotifier, SimulationState>((ref) {
  return SimulationNotifier(ref);
});

/// Provider pour le résultat de la simulation
final simulationResultProvider = Provider<SimulationResult>((ref) {
  final gradesState = ref.watch(gradesStateProvider);
  final simulationState = ref.watch(simulationProvider);

  return _calculateSimulationResult(
    gradesState.grades,
    gradesState.gradesBySubject,
    gradesState.subjectNames,
    simulationState.simulatedGrades,
  );
});

/// Notifier pour gérer la simulation
class SimulationNotifier extends StateNotifier<SimulationState> {
  final Ref _ref;
  final _uuid = const Uuid();

  SimulationNotifier(this._ref) : super(const SimulationState()) {
    _loadSavedGrades();
  }

  /// Charge les notes simulées sauvegardées
  Future<void> _loadSavedGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_simulatedGradesKey);
      if (json != null) {
        final List<dynamic> decoded = jsonDecode(json);
        final grades = decoded
            .map((e) => SimulatedGrade.fromJson(e as Map<String, dynamic>))
            .toList();
        state = state.copyWith(simulatedGrades: grades);
      }
    } catch (e) {
      // Ignorer les erreurs de chargement
    }
  }

  /// Sauvegarde les notes simulées
  Future<void> _saveGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        state.simulatedGrades.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_simulatedGradesKey, json);
    } catch (e) {
      // Ignorer les erreurs de sauvegarde
    }
  }

  /// Ajoute une note simulée
  Future<void> addSimulatedGrade({
    required String subjectCode,
    required String subjectName,
    required double value,
    double maxValue = 20,
    double coefficient = 1,
  }) async {
    final grade = SimulatedGrade(
      id: _uuid.v4(),
      subjectCode: subjectCode,
      subjectName: subjectName,
      value: value,
      maxValue: maxValue,
      coefficient: coefficient,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      simulatedGrades: [...state.simulatedGrades, grade],
    );

    await _saveGrades();
  }

  /// Met à jour une note simulée
  Future<void> updateSimulatedGrade(SimulatedGrade updatedGrade) async {
    final index = state.simulatedGrades.indexWhere(
      (g) => g.id == updatedGrade.id,
    );
    if (index == -1) return;

    final newList = List<SimulatedGrade>.from(state.simulatedGrades);
    newList[index] = updatedGrade;

    state = state.copyWith(simulatedGrades: newList);
    await _saveGrades();
  }

  /// Supprime une note simulée
  Future<void> removeSimulatedGrade(String id) async {
    state = state.copyWith(
      simulatedGrades: state.simulatedGrades.where((g) => g.id != id).toList(),
    );
    await _saveGrades();
  }

  /// Supprime toutes les notes simulées
  Future<void> clearAllSimulatedGrades() async {
    state = state.copyWith(simulatedGrades: []);
    await _saveGrades();
  }

  /// Supprime les notes simulées d'une matière
  Future<void> clearSubjectSimulatedGrades(String subjectCode) async {
    state = state.copyWith(
      simulatedGrades: state.simulatedGrades
          .where((g) => g.subjectCode != subjectCode)
          .toList(),
    );
    await _saveGrades();
  }
}

/// Calcule le résultat de la simulation
SimulationResult _calculateSimulationResult(
  List<GradeModel> realGrades,
  Map<String, List<GradeModel>> gradesBySubject,
  Map<String, String> subjectNames,
  List<SimulatedGrade> simulatedGrades,
) {
  if (realGrades.isEmpty) {
    return const SimulationResult();
  }

  // Calculer la moyenne actuelle par matière
  final currentSubjectAverages = <String, double>{};
  for (final entry in gradesBySubject.entries) {
    final subjectName = entry.key;
    final grades = entry.value;

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
      currentSubjectAverages[subjectName] = sumWeighted / sumCoef;
    }
  }

  // Calculer la moyenne générale actuelle
  double? currentGeneralAverage;
  if (currentSubjectAverages.isNotEmpty) {
    currentGeneralAverage = currentSubjectAverages.values.reduce((a, b) => a + b) /
        currentSubjectAverages.length;
  }

  // Si pas de notes simulées, retourner juste les valeurs actuelles
  if (simulatedGrades.isEmpty) {
    return SimulationResult(
      currentGeneralAverage: currentGeneralAverage,
      simulatedGeneralAverage: currentGeneralAverage,
      subjectResults: currentSubjectAverages.map(
        (k, v) => MapEntry(
          k,
          SubjectSimulationResult(
            subjectName: k,
            currentAverage: v,
            simulatedAverage: v,
          ),
        ),
      ),
    );
  }

  // Grouper les notes simulées par matière
  final simulatedBySubject = <String, List<SimulatedGrade>>{};
  for (final simGrade in simulatedGrades) {
    simulatedBySubject.putIfAbsent(simGrade.subjectName, () => []).add(simGrade);
  }

  // Calculer les nouvelles moyennes avec les notes simulées
  final simulatedSubjectAverages = <String, double>{};
  final subjectResults = <String, SubjectSimulationResult>{};

  // Parcourir toutes les matières (réelles + simulées)
  final allSubjects = {...currentSubjectAverages.keys, ...simulatedBySubject.keys};

  for (final subjectName in allSubjects) {
    double sumWeighted = 0;
    double sumCoef = 0;

    // Ajouter les notes réelles
    final realSubjectGrades = gradesBySubject[subjectName] ?? [];
    for (final grade in realSubjectGrades) {
      final val = grade.valeurSur20;
      if (val != null && grade.isValidForCalculation) {
        sumWeighted += val * grade.coefDouble;
        sumCoef += grade.coefDouble;
      }
    }

    // Ajouter les notes simulées
    final simSubjectGrades = simulatedBySubject[subjectName] ?? [];
    for (final simGrade in simSubjectGrades) {
      sumWeighted += simGrade.valueSur20 * simGrade.coefficient;
      sumCoef += simGrade.coefficient;
    }

    if (sumCoef > 0) {
      simulatedSubjectAverages[subjectName] = sumWeighted / sumCoef;
    }

    subjectResults[subjectName] = SubjectSimulationResult(
      subjectName: subjectName,
      currentAverage: currentSubjectAverages[subjectName],
      simulatedAverage: sumCoef > 0 ? sumWeighted / sumCoef : null,
      addedGradesCount: simSubjectGrades.length,
    );
  }

  // Calculer la moyenne générale simulée
  double? simulatedGeneralAverage;
  if (simulatedSubjectAverages.isNotEmpty) {
    simulatedGeneralAverage = simulatedSubjectAverages.values.reduce((a, b) => a + b) /
        simulatedSubjectAverages.length;
  }

  return SimulationResult(
    currentGeneralAverage: currentGeneralAverage,
    simulatedGeneralAverage: simulatedGeneralAverage,
    subjectResults: subjectResults,
  );
}

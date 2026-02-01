import '../../../grades/data/models/grade_model.dart';

/// Service de calcul des moyennes
class AverageCalculator {
  AverageCalculator._();

  /// Calcule la moyenne pondérée d'une liste de notes
  /// Formule: Σ(note × coefficient) / Σ(coefficients)
  static double? calculateWeightedAverage(List<GradeModel> grades) {
    final validGrades = grades.where((g) => g.isValidForCalculation).toList();
    if (validGrades.isEmpty) return null;

    double sumWeighted = 0.0;
    double sumCoefficients = 0.0;

    for (final grade in validGrades) {
      final valeur = grade.valeurSur20;
      if (valeur == null) continue;

      final coef = grade.coefDouble;
      sumWeighted += valeur * coef;
      sumCoefficients += coef;
    }

    if (sumCoefficients == 0) return null;
    return sumWeighted / sumCoefficients;
  }

  /// Calcule les moyennes par matière
  static Map<String, SubjectAverage> calculateSubjectAverages(
    Map<String, List<GradeModel>> gradesBySubject,
  ) {
    final result = <String, SubjectAverage>{};

    for (final entry in gradesBySubject.entries) {
      final subjectName = entry.key;
      final grades = entry.value;

      final average = calculateWeightedAverage(grades);
      final validGrades = grades.where((g) => g.isValidForCalculation).toList();

      // Calculer la moyenne de classe (si disponible)
      double? classAverage;
      final gradesWithClassAvg = validGrades.where((g) => g.moyenneClasseDouble != null).toList();
      if (gradesWithClassAvg.isNotEmpty) {
        double sum = 0;
        for (final g in gradesWithClassAvg) {
          sum += g.moyenneClasseDouble!;
        }
        classAverage = sum / gradesWithClassAvg.length;
      }

      result[subjectName] = SubjectAverage(
        subjectName: subjectName,
        average: average,
        classAverage: classAverage,
        gradesCount: validGrades.length,
        totalCoefficient: validGrades.fold(0.0, (sum, g) => sum + g.coefDouble),
      );
    }

    // Trier par nom de matière
    final sorted = Map.fromEntries(
      result.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return sorted;
  }

  /// Calcule la moyenne générale
  /// = Moyenne des moyennes par matière (pondérées si coefficients matière disponibles)
  static double? calculateGeneralAverage(List<GradeModel> grades) {
    // Grouper par matière
    final bySubject = <String, List<GradeModel>>{};
    for (final grade in grades) {
      bySubject.putIfAbsent(grade.libelleMatiere, () => []).add(grade);
    }

    // Calculer les moyennes par matière
    final subjectAverages = <double>[];
    for (final subjectGrades in bySubject.values) {
      final avg = calculateWeightedAverage(subjectGrades);
      if (avg != null) {
        subjectAverages.add(avg);
      }
    }

    if (subjectAverages.isEmpty) return null;

    // Moyenne simple des moyennes par matière
    // (l'API École Directe ne fournit pas toujours les coefficients par matière)
    return subjectAverages.reduce((a, b) => a + b) / subjectAverages.length;
  }
}

/// Résultat du calcul de moyenne par matière
class SubjectAverage {
  final String subjectName;
  final double? average;
  final double? classAverage;
  final int gradesCount;
  final double totalCoefficient;

  const SubjectAverage({
    required this.subjectName,
    this.average,
    this.classAverage,
    required this.gradesCount,
    required this.totalCoefficient,
  });

  /// Différence avec la moyenne de classe
  double? get differenceWithClass {
    if (average == null || classAverage == null) return null;
    return average! - classAverage!;
  }
}

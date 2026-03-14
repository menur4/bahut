import '../../../grades/data/models/grade_model.dart';

/// Nombre de notes valides (exclut Abs, Disp, NE, nonSignificatif).
int countValidGrades(List<GradeModel> grades) {
  return grades.where((g) => g.isValidForCalculation).length;
}

/// Nombre de notes valides avec valeurSur20 >= [threshold].
int countGradesAbove(List<GradeModel> grades, double threshold) {
  int count = 0;
  for (final grade in grades) {
    if (!grade.isValidForCalculation) continue;
    final val = grade.valeurSur20;
    if (val != null && val >= threshold) count++;
  }
  return count;
}

/// Meilleure note valide (valeurSur20), null si aucune note valide.
double? calculateBestGrade(List<GradeModel> grades) {
  double? best;
  for (final grade in grades) {
    if (!grade.isValidForCalculation) continue;
    final val = grade.valeurSur20;
    if (val != null && (best == null || val > best)) best = val;
  }
  return best;
}

/// Amélioration maximale de moyenne sur une fenêtre glissante de 30 jours.
///
/// Ancre sur la date de la note la plus récente (rétroactif).
/// Pour chaque note valide datée, teste si elle peut servir d'ancre :
///   - fenêtre récente  : [anchor-30 .. anchor]
///   - fenêtre ancienne : [anchor-60 .. anchor-30]
/// Retourne la meilleure amélioration trouvée parmi toutes les ancres,
/// ou null si aucune paire de fenêtres n'est suffisamment remplie.
double? calculateImprovement30Days(
  List<GradeModel> grades,
  DateTime now,
) {
  // Collecter toutes les notes valides avec date
  final valid = <({double val, DateTime date})>[];
  for (final grade in grades) {
    if (!grade.isValidForCalculation) continue;
    final val = grade.valeurSur20;
    final date = grade.dateTime;
    if (val == null || date == null) continue;
    valid.add((val: val, date: date));
  }

  if (valid.isEmpty) return null;

  // Ancres candidates : la date la plus récente + aujourd'hui
  final anchors = <DateTime>{
    now,
    valid.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b),
  };

  double? bestImprovement;

  for (final anchor in anchors) {
    final thirtyDaysAgo = anchor.subtract(const Duration(days: 30));
    final sixtyDaysAgo = anchor.subtract(const Duration(days: 60));

    final recentValues = <double>[];
    final olderValues = <double>[];

    for (final entry in valid) {
      if (entry.date.isAfter(thirtyDaysAgo) && !entry.date.isAfter(anchor)) {
        recentValues.add(entry.val);
      } else if (entry.date.isAfter(sixtyDaysAgo) && !entry.date.isAfter(thirtyDaysAgo)) {
        olderValues.add(entry.val);
      }
    }

    if (recentValues.isEmpty || olderValues.isEmpty) continue;

    final recentAvg = recentValues.reduce((a, b) => a + b) / recentValues.length;
    final olderAvg = olderValues.reduce((a, b) => a + b) / olderValues.length;
    final improvement = recentAvg - olderAvg;

    if (bestImprovement == null || improvement > bestImprovement) {
      bestImprovement = improvement;
    }
  }

  return bestImprovement;
}

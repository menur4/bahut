import '../../../grades/data/models/grade_model.dart';

List<GradeModel> _sortedGrades(List<GradeModel> grades) {
  return List<GradeModel>.from(grades)
    ..sort((a, b) {
      final dateA = a.dateSaisieTime;
      final dateB = b.dateSaisieTime;
      if (dateA == null && dateB == null) return a.id.compareTo(b.id);
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      final cmp = dateA.compareTo(dateB);
      return cmp != 0 ? cmp : a.id.compareTo(b.id);
    });
}

/// Calcule le streak maximum de notes consécutives >= [threshold]/20.
int calculateMaxStreak(List<GradeModel> grades, {double threshold = 12.0}) {
  int consecutive = 0;
  int maxConsecutive = 0;

  for (final grade in _sortedGrades(grades)) {
    if (!grade.isValidForCalculation) continue;
    final val = grade.valeurSur20;
    if (val == null) continue;
    if (val >= threshold) {
      consecutive++;
      if (consecutive > maxConsecutive) maxConsecutive = consecutive;
    } else {
      consecutive = 0;
    }
  }

  return maxConsecutive;
}

/// Génère un rapport de diagnostic lisible pour déboguer le calcul du streak.
String generateStreakDiagnostic(List<GradeModel> grades, {double threshold = 12.0}) {
  final sorted = _sortedGrades(grades);
  final buf = StringBuffer();

  buf.writeln('=== DIAGNOSTIC STREAK BADGES ===');
  buf.writeln('Total notes brutes : ${grades.length}');
  buf.writeln('Seuil : $threshold/20');
  buf.writeln('');

  int consecutive = 0;
  int maxConsecutive = 0;
  int skippedInvalid = 0;
  int countedAbove = 0;
  int countedBelow = 0;

  buf.writeln('--- Notes triées (dateSaisie ASC) ---');
  for (final grade in sorted) {
    final dateSaisie = grade.dateSaisie ?? '(sans date)';
    final sur = grade.noteSur;
    final raw = grade.valeur;
    final sur20 = grade.valeurSur20?.toStringAsFixed(1) ?? 'null';
    final valid = grade.isValidForCalculation;
    final nonSig = grade.nonSignificatif;

    if (!valid) {
      skippedInvalid++;
      final raison = nonSig ? 'nonSignificatif' : 'valeur="${grade.valeur}"';
      buf.writeln('  [$dateSaisie] id=${grade.id} | $raw/$sur → IGNORÉ ($raison) | consec=$consecutive');
      continue;
    }

    final val = grade.valeurSur20!;
    if (val >= threshold) {
      consecutive++;
      if (consecutive > maxConsecutive) maxConsecutive = consecutive;
      countedAbove++;
      buf.writeln('  [$dateSaisie] id=${grade.id} | $raw/$sur → $sur20/20 ✓ | consec=$consecutive (max=$maxConsecutive)');
    } else {
      countedBelow++;
      consecutive = 0;
      buf.writeln('  [$dateSaisie] id=${grade.id} | $raw/$sur → $sur20/20 ✗ CASSE | consec=0');
    }
  }

  buf.writeln('');
  buf.writeln('--- Résumé ---');
  buf.writeln('Notes ignorées : $skippedInvalid');
  buf.writeln('Notes >= $threshold/20 : $countedAbove');
  buf.writeln('Notes < $threshold/20 (cassent le streak) : $countedBelow');
  buf.writeln('STREAK MAXIMUM : $maxConsecutive');
  buf.writeln('');
  buf.writeln('Badges débloqués si :');
  buf.writeln('  streak_3  : ${maxConsecutive >= 3 ? "✓ OUI" : "✗ NON"} (besoin 3)');
  buf.writeln('  streak_5  : ${maxConsecutive >= 5 ? "✓ OUI" : "✗ NON"} (besoin 5)');
  buf.writeln('  streak_10 : ${maxConsecutive >= 10 ? "✓ OUI" : "✗ NON"} (besoin 10)');

  return buf.toString();
}

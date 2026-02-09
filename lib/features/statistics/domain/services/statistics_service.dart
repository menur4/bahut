import 'dart:math';
import 'dart:ui' show Color;

import '../../../../core/theme/app_themes.dart';
import '../../../grades/data/models/grade_model.dart';

/// Point de données pour un graphique temporel
class TimeSeriesPoint {
  final DateTime date;
  final double value;
  final String? label;

  const TimeSeriesPoint({
    required this.date,
    required this.value,
    this.label,
  });
}

/// Données pour un graphique en barres (renommé pour éviter conflit avec fl_chart)
class SimpleBarData {
  final String label;
  final double value;
  final double? secondaryValue;

  const SimpleBarData({
    required this.label,
    required this.value,
    this.secondaryValue,
  });
}

/// Distribution des notes par tranche
class GradeDistribution {
  final String range;
  final int count;
  final double percentage;
  final double minValue;
  final double maxValue;

  const GradeDistribution({
    required this.range,
    required this.count,
    required this.percentage,
    required this.minValue,
    required this.maxValue,
  });
}

/// Statistiques d'une matière
class SubjectStats {
  final String subjectName;
  final String subjectCode;
  final double average;
  final double? classAverage;
  final double? minGrade;
  final double? maxGrade;
  final int gradeCount;
  final double trend; // Positif = amélioration, négatif = baisse
  final List<TimeSeriesPoint> evolution;

  const SubjectStats({
    required this.subjectName,
    required this.subjectCode,
    required this.average,
    this.classAverage,
    this.minGrade,
    this.maxGrade,
    required this.gradeCount,
    this.trend = 0,
    this.evolution = const [],
  });

  /// Différence avec la moyenne de classe
  double? get diffFromClass =>
      classAverage != null ? average - classAverage! : null;

  /// Couleur selon la performance
  Color getColor(AppColorPalette palette) {
    return palette.gradeColor(average);
  }
}

/// Statistiques globales
class GlobalStats {
  final double generalAverage;
  final double? classGeneralAverage;
  final int totalGrades;
  final int totalSubjects;
  final double? bestAverage;
  final String? bestSubject;
  final double? worstAverage;
  final String? worstSubject;
  final double trend;
  final List<GradeDistribution> distribution;
  final List<TimeSeriesPoint> evolution;
  final List<SubjectStats> subjectStats;

  const GlobalStats({
    required this.generalAverage,
    this.classGeneralAverage,
    required this.totalGrades,
    required this.totalSubjects,
    this.bestAverage,
    this.bestSubject,
    this.worstAverage,
    this.worstSubject,
    this.trend = 0,
    this.distribution = const [],
    this.evolution = const [],
    this.subjectStats = const [],
  });
}

/// Service de calcul des statistiques
class StatisticsService {
  /// Calcule les statistiques globales à partir des notes
  static GlobalStats calculateGlobalStats(
    List<GradeModel> grades, {
    Map<String, double>? classAverages,
    double? classGeneralAverage,
  }) {
    if (grades.isEmpty) {
      return const GlobalStats(
        generalAverage: 0,
        totalGrades: 0,
        totalSubjects: 0,
      );
    }

    // Grouper par matière principale (codeMatiere) pour cohérence avec l'onglet Notes
    // D'abord grouper par code
    final byCode = <String, List<GradeModel>>{};
    for (final grade in grades) {
      byCode.putIfAbsent(grade.codeMatiere, () => []).add(grade);
    }

    // Puis convertir en map avec le nom de la matière principale
    final bySubject = <String, List<GradeModel>>{};
    for (final entry in byCode.entries) {
      final gradesList = entry.value;
      // Utiliser mainSubjectName qui retourne le nom de la matière principale
      final subjectName = gradesList.first.mainSubjectName;
      bySubject[subjectName] = gradesList;
    }

    // Calculer stats par matière
    final subjectStatsList = <SubjectStats>[];
    double sumAverages = 0;
    int countAverages = 0;

    for (final entry in bySubject.entries) {
      final subjectGrades = entry.value;
      final stats = _calculateSubjectStats(
        entry.key,
        subjectGrades,
        classAverages?[subjectGrades.first.codeMatiere],
      );
      subjectStatsList.add(stats);

      if (stats.gradeCount > 0) {
        sumAverages += stats.average;
        countAverages++;
      }
    }

    // Trier par moyenne décroissante
    subjectStatsList.sort((a, b) => b.average.compareTo(a.average));

    // Moyenne générale
    final generalAverage = countAverages > 0 ? sumAverages / countAverages : 0.0;

    // Meilleure et pire matière
    final best = subjectStatsList.isNotEmpty ? subjectStatsList.first : null;
    final worst = subjectStatsList.isNotEmpty ? subjectStatsList.last : null;

    // Distribution des notes
    final distribution = _calculateDistribution(grades);

    // Évolution temporelle
    final evolution = _calculateEvolution(grades);

    // Tendance globale
    final trend = _calculateTrend(evolution);

    return GlobalStats(
      generalAverage: generalAverage,
      classGeneralAverage: classGeneralAverage,
      totalGrades: grades.length,
      totalSubjects: bySubject.length,
      bestAverage: best?.average,
      bestSubject: best?.subjectName,
      worstAverage: worst?.average,
      worstSubject: worst?.subjectName,
      trend: trend,
      distribution: distribution,
      evolution: evolution,
      subjectStats: subjectStatsList,
    );
  }

  /// Calcule les statistiques d'une matière
  static SubjectStats _calculateSubjectStats(
    String subjectName,
    List<GradeModel> grades,
    double? classAverage,
  ) {
    if (grades.isEmpty) {
      return SubjectStats(
        subjectName: subjectName,
        subjectCode: '',
        average: 0,
        gradeCount: 0,
      );
    }

    // Filtrer les notes valides
    final validGrades = grades.where((g) => g.isValidForCalculation).toList();

    if (validGrades.isEmpty) {
      return SubjectStats(
        subjectName: subjectName,
        subjectCode: grades.first.codeMatiere,
        average: 0,
        classAverage: classAverage,
        gradeCount: grades.length,
      );
    }

    // Calcul de la moyenne pondérée
    double sumWeighted = 0;
    double sumCoef = 0;
    double? minVal;
    double? maxVal;

    for (final grade in validGrades) {
      final val = grade.valeurSur20;
      if (val != null) {
        sumWeighted += val * grade.coefDouble;
        sumCoef += grade.coefDouble;

        if (minVal == null || val < minVal) minVal = val;
        if (maxVal == null || val > maxVal) maxVal = val;
      }
    }

    final average = sumCoef > 0 ? sumWeighted / sumCoef : 0.0;

    // Évolution temporelle
    final evolution = _calculateSubjectEvolution(validGrades);

    // Tendance
    final trend = _calculateTrend(evolution);

    return SubjectStats(
      subjectName: subjectName,
      subjectCode: grades.first.codeMatiere,
      average: average,
      classAverage: classAverage,
      minGrade: minVal,
      maxGrade: maxVal,
      gradeCount: grades.length,
      trend: trend,
      evolution: evolution,
    );
  }

  /// Calcule la distribution des notes par tranche
  static List<GradeDistribution> _calculateDistribution(List<GradeModel> grades) {
    final ranges = [
      (0.0, 5.0, '0-5'),
      (5.0, 8.0, '5-8'),
      (8.0, 10.0, '8-10'),
      (10.0, 12.0, '10-12'),
      (12.0, 14.0, '12-14'),
      (14.0, 16.0, '14-16'),
      (16.0, 18.0, '16-18'),
      (18.0, 20.0, '18-20'),
    ];

    final counts = List.filled(ranges.length, 0);
    int totalValid = 0;

    for (final grade in grades) {
      final val = grade.valeurSur20;
      if (val == null) continue;

      totalValid++;
      for (var i = 0; i < ranges.length; i++) {
        final (minV, maxV, _) = ranges[i];
        if (val >= minV && (val < maxV || (i == ranges.length - 1 && val <= maxV))) {
          counts[i]++;
          break;
        }
      }
    }

    return List.generate(ranges.length, (i) {
      final (minV, maxV, label) = ranges[i];
      return GradeDistribution(
        range: label,
        count: counts[i],
        percentage: totalValid > 0 ? (counts[i] / totalValid) * 100 : 0,
        minValue: minV,
        maxValue: maxV,
      );
    });
  }

  /// Calcule l'évolution des moyennes dans le temps
  static List<TimeSeriesPoint> _calculateEvolution(List<GradeModel> grades) {
    if (grades.isEmpty) return [];

    // Trier par date (utiliser dateTime au lieu de date)
    final sorted = grades.where((g) => g.dateTime != null).toList()
      ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    if (sorted.isEmpty) return [];

    // Grouper par semaine
    final byWeek = <DateTime, List<GradeModel>>{};
    for (final grade in sorted) {
      final weekStart = _getWeekStart(grade.dateTime!);
      byWeek.putIfAbsent(weekStart, () => []).add(grade);
    }

    // Calculer moyenne cumulative
    final points = <TimeSeriesPoint>[];
    double runningSum = 0;
    double runningCoef = 0;

    final sortedWeeks = byWeek.keys.toList()..sort();
    for (final week in sortedWeeks) {
      final weekGrades = byWeek[week]!;

      for (final grade in weekGrades) {
        final val = grade.valeurSur20;
        if (val != null && grade.isValidForCalculation) {
          runningSum += val * grade.coefDouble;
          runningCoef += grade.coefDouble;
        }
      }

      if (runningCoef > 0) {
        points.add(TimeSeriesPoint(
          date: week,
          value: runningSum / runningCoef,
        ));
      }
    }

    return points;
  }

  /// Calcule l'évolution d'une matière
  static List<TimeSeriesPoint> _calculateSubjectEvolution(List<GradeModel> grades) {
    if (grades.isEmpty) return [];

    final sorted = grades.where((g) => g.dateTime != null && g.valeurSur20 != null).toList()
      ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    return sorted.map((g) => TimeSeriesPoint(
      date: g.dateTime!,
      value: g.valeurSur20!,
      label: g.devoir,
    )).toList();
  }

  /// Calcule la tendance (pente de la régression linéaire)
  static double _calculateTrend(List<TimeSeriesPoint> points) {
    if (points.length < 2) return 0;

    // Régression linéaire simple
    final n = points.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (var i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = points[i].value;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    final denominator = n * sumX2 - sumX * sumX;
    if (denominator == 0) return 0;

    final slope = (n * sumXY - sumX * sumY) / denominator;
    return slope;
  }

  /// Obtient le début de la semaine pour une date
  static DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - weekday + 1);
  }

  /// Formate une tendance en texte
  static String formatTrend(double trend) {
    if (trend > 0.1) return 'En hausse';
    if (trend < -0.1) return 'En baisse';
    return 'Stable';
  }

  /// Obtient l'icône de tendance
  static String getTrendIcon(double trend) {
    if (trend > 0.1) return '📈';
    if (trend < -0.1) return '📉';
    return '➡️';
  }
}


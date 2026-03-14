import 'package:flutter_test/flutter_test.dart';
import 'package:calcul_moyenne/features/grades/data/models/grade_model.dart';
import 'package:calcul_moyenne/features/gamification/domain/models/badge_model.dart';
import 'package:calcul_moyenne/features/gamification/domain/services/badge_context_calculator.dart';

// ─── Helper ───────────────────────────────────────────────────────────────────

GradeModel g({
  int id = 1,
  required String valeur,
  String sur = '20',
  bool nonSignificatif = false,
  String? dateExamen,   // grade.date  → dateTime
  String? dateSaisie,   // grade.dateSaisie → dateSaisieTime
}) {
  return GradeModel(
    id: id,
    devoir: 'Test',
    codePeriode: 'A001',
    codeMatiere: 'MAT',
    libelleMatiere: 'Mathématiques',
    coef: '1',
    noteSur: sur,
    valeur: valeur,
    nonSignificatif: nonSignificatif,
    date: dateExamen,
    dateSaisie: dateSaisie,
  );
}

List<GradeModel> nValid(int n, {String valeur = '14'}) =>
    List.generate(n, (i) => g(id: i + 1, valeur: valeur));

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ══════════════════════════════════════════════════════════
  // countValidGrades — Découverte
  // ══════════════════════════════════════════════════════════

  group('countValidGrades', () {
    test('aucune note → 0', () {
      expect(countValidGrades([]), 0);
    });

    test('1 note valide → 1', () {
      expect(countValidGrades([g(valeur: '14')]), 1);
    });

    test('note Abs non comptée', () {
      expect(countValidGrades([g(valeur: 'Abs')]), 0);
    });

    test('note Disp non comptée', () {
      expect(countValidGrades([g(valeur: 'Disp')]), 0);
    });

    test('note NE non comptée', () {
      expect(countValidGrades([g(valeur: 'NE')]), 0);
    });

    test('note nonSignificatif non comptée', () {
      expect(countValidGrades([g(valeur: '15', nonSignificatif: true)]), 0);
    });

    test('9 valides + 5 Abs → 9', () {
      final grades = [
        ...nValid(9),
        ...List.generate(5, (i) => g(id: 10 + i, valeur: 'Abs')),
      ];
      expect(countValidGrades(grades), 9);
    });

    test('10 valides → 10', () {
      expect(countValidGrades(nValid(10)), 10);
    });

    test('50 valides → 50', () {
      expect(countValidGrades(nValid(50)), 50);
    });

    test('100 valides → 100', () {
      expect(countValidGrades(nValid(100)), 100);
    });
  });

  // ══════════════════════════════════════════════════════════
  // countGradesAbove — Excellence
  // ══════════════════════════════════════════════════════════

  group('countGradesAbove(15)', () {
    test('aucune note → 0', () {
      expect(countGradesAbove([], 15), 0);
    });

    test('note exactement 15/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '15')], 15), 1);
    });

    test('note 8/10 = 16/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '8', sur: '10')], 15), 1);
    });

    test('note 7/10 = 14/20 → non comptée', () {
      expect(countGradesAbove([g(valeur: '7', sur: '10')], 15), 0);
    });

    test('note nonSignificatif 17/20 → non comptée', () {
      expect(countGradesAbove([g(valeur: '17', nonSignificatif: true)], 15), 0);
    });

    test('10 notes >= 15 → 10', () {
      expect(countGradesAbove(nValid(10, valeur: '16'), 15), 10);
    });
  });

  group('countGradesAbove(18)', () {
    test('note exactement 18/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '18')], 18), 1);
    });

    test('note 9/10 = 18/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '9', sur: '10')], 18), 1);
    });

    test('note nonSignificatif 19/20 → non comptée', () {
      expect(countGradesAbove([g(valeur: '19', nonSignificatif: true)], 18), 0);
    });
  });

  group('countGradesAbove(20) — perfect', () {
    test('note 20/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '20')], 20), 1);
    });

    test('note 10/10 = 20/20 → comptée', () {
      expect(countGradesAbove([g(valeur: '10', sur: '10')], 20), 1);
    });

    test('note nonSignificatif 20/20 → non comptée', () {
      expect(countGradesAbove([g(valeur: '20', nonSignificatif: true)], 20), 0);
    });

    test('5 notes 20/20 → 5', () {
      expect(countGradesAbove(nValid(5, valeur: '20'), 20), 5);
    });
  });

  // ══════════════════════════════════════════════════════════
  // calculateImprovement30Days — Progression
  // ══════════════════════════════════════════════════════════

  group('calculateImprovement30Days', () {
    final today = DateTime(2026, 3, 14);

    // fenêtre récente  : J-30..J   → après 2026-02-12
    // fenêtre ancienne : J-60..J-30 → 2026-01-13..2026-02-12

    test('aucune note → null', () {
      expect(calculateImprovement30Days([], today), isNull);
    });

    test('notes seulement dans la fenêtre récente → null', () {
      final grades = [
        g(id: 1, valeur: '15', dateExamen: '2026-03-01'),
        g(id: 2, valeur: '14', dateExamen: '2026-03-10'),
      ];
      expect(calculateImprovement30Days(grades, today), isNull);
    });

    test('notes seulement dans la fenêtre ancienne → null', () {
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '11', dateExamen: '2026-01-25'),
      ];
      expect(calculateImprovement30Days(grades, today), isNull);
    });

    test('amélioration de 1.5 points', () {
      // ancienne : (10+12)/2 = 11.0 | récente : (13+12)/2 = 12.5 → +1.5
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '12', dateExamen: '2026-01-25'),
        g(id: 3, valeur: '13', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '12', dateExamen: '2026-03-10'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(1.5, 0.001));
    });

    test('régression → valeur négative', () {
      // ancienne : (16+14)/2 = 15.0 | récente : (10+11)/2 = 10.5 → -4.5
      final grades = [
        g(id: 1, valeur: '16', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '14', dateExamen: '2026-01-25'),
        g(id: 3, valeur: '10', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '11', dateExamen: '2026-03-10'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(-4.5, 0.001));
    });

    test('notes sur 10 normalisées avant calcul', () {
      // ancienne : (10/20 + 10/20)/2 = 10.0 | récente : (14/20 + 16/20)/2 = 15.0 → +5.0
      final grades = [
        g(id: 1, valeur: '5',  sur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '10', sur: '20', dateExamen: '2026-01-25'),
        g(id: 3, valeur: '7',  sur: '10', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '16', sur: '20', dateExamen: '2026-03-10'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(5.0, 0.001));
    });

    test('note nonSignificatif basse dans la fenêtre récente ignorée', () {
      // ancienne : (10+11)/2 = 10.5 | récente (sans nonSig) : (15+14)/2 = 14.5 → +4.0
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '11', dateExamen: '2026-01-25'),
        g(id: 3, valeur: '15', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '14', dateExamen: '2026-03-10'),
        g(id: 5, valeur: '2',  nonSignificatif: true, dateExamen: '2026-03-12'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(4.0, 0.001));
    });

    test('note nonSignificatif haute dans la fenêtre ancienne ignorée', () {
      // ancienne (sans nonSig) : 10.0 | récente : (14+14)/2 = 14.0 → +4.0
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '19', nonSignificatif: true, dateExamen: '2026-01-25'),
        g(id: 3, valeur: '14', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '14', dateExamen: '2026-03-10'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(4.0, 0.001));
    });

    test('fenêtre ancienne ne contient que des nonSignificatif → null', () {
      final grades = [
        g(id: 1, valeur: '5',  nonSignificatif: true, dateExamen: '2026-01-20'),
        g(id: 2, valeur: '3',  nonSignificatif: true, dateExamen: '2026-01-25'),
        g(id: 3, valeur: '14', dateExamen: '2026-03-01'),
      ];
      expect(calculateImprovement30Days(grades, today), isNull);
    });

    test('note saisie récemment mais dateExamen ancienne → fenêtre ancienne', () {
      // dateExamen 2026-01-20 → ancienne | dateExamen 2026-03-01 → récente
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20', dateSaisie: '2026-03-13'),
        g(id: 2, valeur: '14', dateExamen: '2026-03-01', dateSaisie: '2026-03-13'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(4.0, 0.001));
    });

    test('toutes les notes > 30 jours dans le passé — ancrage rétroactif détecte la progression', () {
      // today = 2026-03-14 → aucune note dans les 60 jours avec ancre "now"
      // note la plus récente : 2025-12-14 → ancre rétroactive
      //   récente : 2025-11-14..2025-12-14 → [14, 13] → moy 13.5
      //   ancienne: 2025-10-15..2025-11-14 → [10, 11] → moy 10.5 → amélioration +3.0
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2025-10-20'),
        g(id: 2, valeur: '11', dateExamen: '2025-11-05'),
        g(id: 3, valeur: '14', dateExamen: '2025-11-20'),
        g(id: 4, valeur: '13', dateExamen: '2025-12-10'),
      ];
      expect(calculateImprovement30Days(grades, today), closeTo(3.0, 0.001));
    });

    test('ancrage rétroactif retourne la meilleure amélioration si supérieure', () {
      // Avec ancre "now" : amélioration 1.5 pts
      // Avec ancre rétroactive (note la plus récente = 2026-03-10) : même calcul → 1.5 pts
      // Les deux ancres donnent le même résultat ici
      final grades = [
        g(id: 1, valeur: '10', dateExamen: '2026-01-20'),
        g(id: 2, valeur: '12', dateExamen: '2026-01-25'),
        g(id: 3, valeur: '13', dateExamen: '2026-03-01'),
        g(id: 4, valeur: '12', dateExamen: '2026-03-10'),
      ];
      // La meilleure amélioration (1.5) est retournée
      expect(calculateImprovement30Days(grades, today), closeTo(1.5, 0.001));
    });
  });

  // ══════════════════════════════════════════════════════════
  // BadgeContext — conditions de déverrouillage
  // ══════════════════════════════════════════════════════════

  BadgeContext ctx({
    int totalGrades = 0,
    double? generalAverage,
    int consecutiveGoodGrades = 0,
    int gradesAbove15 = 0,
    int gradesAbove18 = 0,
    int perfectGrades = 0,
    double? improvement30Days,
    bool hasReachedGoal = false,
    int subjectsAbove15 = 0,
    Map<String, double> subjectAverages = const {},
  }) =>
      BadgeContext(
        totalGrades: totalGrades,
        generalAverage: generalAverage,
        consecutiveGoodGrades: consecutiveGoodGrades,
        gradesAbove15: gradesAbove15,
        gradesAbove18: gradesAbove18,
        perfectGrades: perfectGrades,
        improvement30Days: improvement30Days,
        hasReachedGoal: hasReachedGoal,
        subjectsAbove15: subjectsAbove15,
        subjectAverages: subjectAverages,
      );

  BadgeModel badge(String id) => BadgeDefinitions.all.firstWhere((b) => b.id == id);

  // ── Découverte ──────────────────────────────────────────

  group('Badge Découverte — conditions', () {
    test('first_grade : totalGrades >= 1', () {
      expect(badge('first_grade').checkUnlock(ctx(totalGrades: 0)), isFalse);
      expect(badge('first_grade').checkUnlock(ctx(totalGrades: 1)), isTrue);
    });

    test('ten_grades : totalGrades >= 10', () {
      expect(badge('ten_grades').checkUnlock(ctx(totalGrades: 9)), isFalse);
      expect(badge('ten_grades').checkUnlock(ctx(totalGrades: 10)), isTrue);
    });

    test('fifty_grades : totalGrades >= 50', () {
      expect(badge('fifty_grades').checkUnlock(ctx(totalGrades: 49)), isFalse);
      expect(badge('fifty_grades').checkUnlock(ctx(totalGrades: 50)), isTrue);
    });

    test('hundred_grades : totalGrades >= 100', () {
      expect(badge('hundred_grades').checkUnlock(ctx(totalGrades: 99)), isFalse);
      expect(badge('hundred_grades').checkUnlock(ctx(totalGrades: 100)), isTrue);
    });
  });

  // ── Performance ─────────────────────────────────────────

  group('Badge Performance — conditions', () {
    test('above_average : generalAverage >= 12', () {
      expect(badge('above_average').checkUnlock(ctx(generalAverage: 11.9)), isFalse);
      expect(badge('above_average').checkUnlock(ctx(generalAverage: 12.0)), isTrue);
    });

    test('good_student : generalAverage >= 14', () {
      expect(badge('good_student').checkUnlock(ctx(generalAverage: 13.9)), isFalse);
      expect(badge('good_student').checkUnlock(ctx(generalAverage: 14.0)), isTrue);
    });

    test('excellent : generalAverage >= 16', () {
      expect(badge('excellent').checkUnlock(ctx(generalAverage: 15.9)), isFalse);
      expect(badge('excellent').checkUnlock(ctx(generalAverage: 16.0)), isTrue);
    });

    test('outstanding : generalAverage >= 18', () {
      expect(badge('outstanding').checkUnlock(ctx(generalAverage: 17.9)), isFalse);
      expect(badge('outstanding').checkUnlock(ctx(generalAverage: 18.0)), isTrue);
    });

    test('moyenne nulle → aucun badge performance', () {
      expect(badge('above_average').checkUnlock(ctx(generalAverage: 0)), isFalse);
    });
  });

  // ── Excellence ──────────────────────────────────────────

  group('Badge Excellence — conditions', () {
    test('first_15 : gradesAbove15 >= 1', () {
      expect(badge('first_15').checkUnlock(ctx(gradesAbove15: 0)), isFalse);
      expect(badge('first_15').checkUnlock(ctx(gradesAbove15: 1)), isTrue);
    });

    test('ten_15 : gradesAbove15 >= 10', () {
      expect(badge('ten_15').checkUnlock(ctx(gradesAbove15: 9)), isFalse);
      expect(badge('ten_15').checkUnlock(ctx(gradesAbove15: 10)), isTrue);
    });

    test('first_18 : gradesAbove18 >= 1', () {
      expect(badge('first_18').checkUnlock(ctx(gradesAbove18: 0)), isFalse);
      expect(badge('first_18').checkUnlock(ctx(gradesAbove18: 1)), isTrue);
    });

    test('perfect_score : perfectGrades >= 1', () {
      expect(badge('perfect_score').checkUnlock(ctx(perfectGrades: 0)), isFalse);
      expect(badge('perfect_score').checkUnlock(ctx(perfectGrades: 1)), isTrue);
    });

    test('five_perfect : perfectGrades >= 5', () {
      expect(badge('five_perfect').checkUnlock(ctx(perfectGrades: 4)), isFalse);
      expect(badge('five_perfect').checkUnlock(ctx(perfectGrades: 5)), isTrue);
    });
  });

  // ── Progression ─────────────────────────────────────────

  group('Badge Progression — conditions', () {
    test('improvement_05 : improvement >= 0.5', () {
      expect(badge('improvement_05').checkUnlock(ctx(improvement30Days: null)), isFalse);
      expect(badge('improvement_05').checkUnlock(ctx(improvement30Days: 0.4)), isFalse);
      expect(badge('improvement_05').checkUnlock(ctx(improvement30Days: 0.5)), isTrue);
    });

    test('improvement_1 : improvement >= 1.0', () {
      expect(badge('improvement_1').checkUnlock(ctx(improvement30Days: 0.9)), isFalse);
      expect(badge('improvement_1').checkUnlock(ctx(improvement30Days: 1.0)), isTrue);
    });

    test('improvement_2 : improvement >= 2.0', () {
      expect(badge('improvement_2').checkUnlock(ctx(improvement30Days: 1.9)), isFalse);
      expect(badge('improvement_2').checkUnlock(ctx(improvement30Days: 2.0)), isTrue);
    });

    test('improvement négatif → aucun badge', () {
      expect(badge('improvement_05').checkUnlock(ctx(improvement30Days: -1.0)), isFalse);
    });

    test('goal_reached : hasReachedGoal = true', () {
      expect(badge('goal_reached').checkUnlock(ctx(hasReachedGoal: false)), isFalse);
      expect(badge('goal_reached').checkUnlock(ctx(hasReachedGoal: true)), isTrue);
    });
  });

  // ── Régularité avancée ───────────────────────────────────

  group('Badge Régularité avancée — conditions', () {
    test('multi_subject_15 : subjectsAbove15 >= 3', () {
      expect(badge('multi_subject_15').checkUnlock(ctx(subjectsAbove15: 2)), isFalse);
      expect(badge('multi_subject_15').checkUnlock(ctx(subjectsAbove15: 3)), isTrue);
    });

    test('all_above_10 : toutes les matières >= 10', () {
      expect(
        badge('all_above_10').checkUnlock(ctx(subjectAverages: {})),
        isFalse,
      );
      expect(
        badge('all_above_10').checkUnlock(ctx(subjectAverages: {
          'MATHS': 12.0, 'FRANCAIS': 10.0, 'ANGLAIS': 14.5,
        })),
        isTrue,
      );
      expect(
        badge('all_above_10').checkUnlock(ctx(subjectAverages: {
          'MATHS': 15.0, 'FRANCAIS': 9.9,
        })),
        isFalse,
      );
      expect(
        badge('all_above_10').checkUnlock(ctx(subjectAverages: {
          'MATHS': 10.0, 'FRANCAIS': 15.0,
        })),
        isTrue,
      );
    });
  });
}

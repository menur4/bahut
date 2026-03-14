import 'package:flutter_test/flutter_test.dart';
import 'package:calcul_moyenne/features/grades/data/models/grade_model.dart';
import 'package:calcul_moyenne/features/gamification/domain/services/streak_calculator.dart';

// ─── Helper ───────────────────────────────────────────────────────────────────

GradeModel makeGrade({
  int id = 1,
  required String valeur,
  String sur = '20',
  bool nonSignificatif = false,
  String? dateSaisie,
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
    dateSaisie: dateSaisie,
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ── Règle : isValidForCalculation ─────────────────────────────────────────

  group('GradeModel.isValidForCalculation', () {
    test('note standard sur 20 — valide', () {
      final g = makeGrade(valeur: '14', sur: '20');
      expect(g.isValidForCalculation, isTrue);
      expect(g.valeurSur20, 14.0);
    });

    test('note sur 10 normalisée sur 20', () {
      final g = makeGrade(valeur: '8', sur: '10');
      expect(g.isValidForCalculation, isTrue);
      expect(g.valeurSur20, 16.0);
    });

    test('6/10 = 12.0/20 — exactement au seuil', () {
      final g = makeGrade(valeur: '6', sur: '10');
      expect(g.valeurSur20, 12.0);
    });

    test('5/10 = 10.0/20 — sous le seuil', () {
      final g = makeGrade(valeur: '5', sur: '10');
      expect(g.valeurSur20, 10.0);
    });

    test('Abs — invalide', () {
      final g = makeGrade(valeur: 'Abs');
      expect(g.isValidForCalculation, isFalse);
      expect(g.valeurSur20, isNull);
    });

    test('Disp — invalide', () {
      final g = makeGrade(valeur: 'Disp');
      expect(g.isValidForCalculation, isFalse);
    });

    test('NE — invalide', () {
      final g = makeGrade(valeur: 'NE');
      expect(g.isValidForCalculation, isFalse);
    });

    test('nonSignificatif true avec valeur numérique — invalide', () {
      final g = makeGrade(valeur: '4', nonSignificatif: true);
      expect(g.isValidForCalculation, isFalse);
    });

    test('nonSignificatif true sur 10 — invalide', () {
      final g = makeGrade(valeur: '3', sur: '10', nonSignificatif: true);
      expect(g.isValidForCalculation, isFalse);
    });
  });

  // ── Règle : calcul du streak de base ──────────────────────────────────────

  group('calculateMaxStreak — cas de base', () {
    test('aucune note → streak 0', () {
      expect(calculateMaxStreak([]), 0);
    });

    test('3 bonnes notes consécutives → streak 3', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '13', dateSaisie: '2026-01-03'),
      ];
      expect(calculateMaxStreak(grades), 3);
    });

    test('5 bonnes notes consécutives → streak 5', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '13', dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '16', dateSaisie: '2026-01-04'),
        makeGrade(id: 5, valeur: '12', dateSaisie: '2026-01-05'),
      ];
      expect(calculateMaxStreak(grades), 5);
    });

    test('mauvaise note casse le streak, repart de 0', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '8',  dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '13', dateSaisie: '2026-01-04'),
        makeGrade(id: 5, valeur: '14', dateSaisie: '2026-01-05'),
      ];
      expect(calculateMaxStreak(grades), 2);
    });

    test('le maximum historique est retenu même si la série en cours est plus courte', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '16', dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '8',  dateSaisie: '2026-01-04'),
        makeGrade(id: 5, valeur: '13', dateSaisie: '2026-01-05'),
      ];
      expect(calculateMaxStreak(grades), 3);
    });
  });

  // ── Règle : normalisation /10 → /20 ───────────────────────────────────────

  group('calculateMaxStreak — notes sur 10', () {
    test('6/10 = 12/20 — exactement au seuil, compte dans le streak', () {
      final grades = [
        makeGrade(id: 1, valeur: '6', sur: '10', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '7', sur: '10', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '8', sur: '10', dateSaisie: '2026-01-03'),
      ];
      expect(calculateMaxStreak(grades), 3);
    });

    test('5/10 = 10/20 — sous le seuil, casse le streak', () {
      final grades = [
        makeGrade(id: 1, valeur: '7', sur: '10', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '5', sur: '10', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '8', sur: '10', dateSaisie: '2026-01-03'),
      ];
      expect(calculateMaxStreak(grades), 1);
    });

    test('mélange /10 et /20 dans le même streak', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', sur: '20', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '7',  sur: '10', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '15', sur: '20', dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '8',  sur: '10', dateSaisie: '2026-01-04'),
      ];
      expect(calculateMaxStreak(grades), 4);
    });
  });

  // ── Règle : notes non significatives ignorées ──────────────────────────────

  group('calculateMaxStreak — nonSignificatif ignoré', () {
    test('note nonSignificatif entre deux bonnes notes ne casse pas le streak', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '4',  nonSignificatif: true, dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '13', dateSaisie: '2026-01-04'),
        makeGrade(id: 5, valeur: '16', dateSaisie: '2026-01-05'),
      ];
      expect(calculateMaxStreak(grades), 4);
    });

    test('note Abs entre deux bonnes notes ne casse pas le streak', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: 'Abs', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '13', dateSaisie: '2026-01-03'),
      ];
      expect(calculateMaxStreak(grades), 2);
    });

    test('plusieurs nonSignificatif consécutifs ignorés', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '3',  nonSignificatif: true, dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '2',  nonSignificatif: true, dateSaisie: '2026-01-03'),
        makeGrade(id: 4, valeur: '15', dateSaisie: '2026-01-04'),
        makeGrade(id: 5, valeur: '16', dateSaisie: '2026-01-05'),
      ];
      expect(calculateMaxStreak(grades), 3);
    });
  });

  // ── Règle : notes sans dateSaisie ─────────────────────────────────────────

  group('calculateMaxStreak — notes sans dateSaisie', () {
    test('note mauvaise sans date placée en fin — ne casse pas le streak daté', () {
      final grades = [
        makeGrade(id: 1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id: 2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id: 3, valeur: '5'),  // sans date, mauvaise note
        makeGrade(id: 4, valeur: '13', dateSaisie: '2026-01-03'),
      ];
      expect(calculateMaxStreak(grades), 3);
    });

    test('notes sans date triées par id ASC entre elles', () {
      final grades = [
        makeGrade(id: 3, valeur: '5'),   // sans date, mauvaise note, id=3
        makeGrade(id: 1, valeur: '14'),  // sans date, bonne note, id=1
        makeGrade(id: 2, valeur: '13'),  // sans date, bonne note, id=2
      ];
      // ordre final: id1(14) → id2(13) → id3(5) → streak max = 2
      expect(calculateMaxStreak(grades), 2);
    });
  });

  // ── Scénario réel ─────────────────────────────────────────────────────────

  group('calculateMaxStreak — scénario réel', () {
    test('20 bonnes notes avec quelques nonSignificatif et /10 intercalés → streak 20', () {
      final grades = [
        makeGrade(id:  1, valeur: '14', dateSaisie: '2026-01-01'),
        makeGrade(id:  2, valeur: '15', dateSaisie: '2026-01-02'),
        makeGrade(id:  3, valeur: '7',  sur: '10', dateSaisie: '2026-01-03'),
        makeGrade(id:  4, valeur: '13', dateSaisie: '2026-01-04'),
        makeGrade(id:  5, valeur: '4',  nonSignificatif: true, dateSaisie: '2026-01-05'),
        makeGrade(id:  6, valeur: '16', dateSaisie: '2026-01-06'),
        makeGrade(id:  7, valeur: '8',  sur: '10', dateSaisie: '2026-01-07'),
        makeGrade(id:  8, valeur: '14', dateSaisie: '2026-01-08'),
        makeGrade(id:  9, valeur: '15', dateSaisie: '2026-01-09'),
        makeGrade(id: 10, valeur: '13', dateSaisie: '2026-01-10'),
        makeGrade(id: 11, valeur: '3',  nonSignificatif: true, dateSaisie: '2026-01-11'),
        makeGrade(id: 12, valeur: '16', dateSaisie: '2026-01-12'),
        makeGrade(id: 13, valeur: '14', dateSaisie: '2026-01-13'),
        makeGrade(id: 14, valeur: '7',  sur: '10', dateSaisie: '2026-01-14'),
        makeGrade(id: 15, valeur: '15', dateSaisie: '2026-01-15'),
        makeGrade(id: 16, valeur: '13', dateSaisie: '2026-01-16'),
        makeGrade(id: 17, valeur: '14', dateSaisie: '2026-01-17'),
        makeGrade(id: 18, valeur: '16', dateSaisie: '2026-01-18'),
        makeGrade(id: 19, valeur: '15', dateSaisie: '2026-01-19'),
        makeGrade(id: 20, valeur: '14', dateSaisie: '2026-01-20'),
      ];
      // 20 entrées dont 2 nonSignificatif ignorées → 18 notes valides consécutives
      expect(calculateMaxStreak(grades), 18);
    });
  });
}

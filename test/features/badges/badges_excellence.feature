# Badges Excellence — Scénarios Gherkin
# Badges : first_15, ten_15, first_18, perfect_score, five_perfect
#
# Basés sur gradesAbove15, gradesAbove18, perfectGrades
# Ces compteurs utilisent grade.valeurSur20 — normalisé depuis /10 ou /20.
# Question ouverte : les notes nonSignificatif doivent-elles compter ?

Feature: Badges d'excellence

  # ─────────────────────────────────────────────
  # Règle : notes ≥ 15/20
  # ─────────────────────────────────────────────

  Rule: gradesAbove15 compte les notes valides avec valeurSur20 >= 15

    Scenario: 0 note >= 15 — first_15 non déverrouillé
      Given 0 note avec valeurSur20 >= 15
      Then le badge "first_15" n'est pas déverrouillé

    Scenario: 1 note >= 15/20 — first_15 déverrouillé
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 15     | 20  | false           |
      Then le badge "first_15" est déverrouillé
      And le badge "ten_15" n'est pas déverrouillé

    Scenario: Note 8/10 = 16/20 — compte dans gradesAbove15
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 8      | 10  | false           |
      Then le badge "first_15" est déverrouillé

    Scenario: Note 7/10 = 14/20 — ne compte pas dans gradesAbove15
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 7      | 10  | false           |
      Then le badge "first_15" n'est pas déverrouillé

    Scenario: 10 notes >= 15/20 — ten_15 déverrouillé
      Given 10 notes avec valeurSur20 >= 15
      Then le badge "first_15" est déverrouillé
      And le badge "ten_15" est déverrouillé

    Scenario: Note nonSignificatif >= 15 ne compte pas dans gradesAbove15
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 17     | 20  | true            |
      Then le badge "first_15" n'est pas déverrouillé

  # ─────────────────────────────────────────────
  # Règle : notes ≥ 18/20
  # ─────────────────────────────────────────────

  Rule: gradesAbove18 compte les notes valides avec valeurSur20 >= 18

    Scenario: 1 note >= 18/20 — first_18 déverrouillé
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 18     | 20  | false           |
      Then le badge "first_18" est déverrouillé

    Scenario: Note 9/10 = 18/20 — exactement au seuil, compte
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 9      | 10  | false           |
      Then le badge "first_18" est déverrouillé

    Scenario: Note nonSignificatif >= 18 ne compte pas
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 19     | 20  | true            |
      Then le badge "first_18" n'est pas déverrouillé

  # ─────────────────────────────────────────────
  # Règle : notes parfaites 20/20
  # ─────────────────────────────────────────────

  Rule: perfectGrades compte les notes valides avec valeurSur20 >= 20

    Scenario: 1 note 20/20 — perfect_score déverrouillé
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 20     | 20  | false           |
      Then le badge "perfect_score" est déverrouillé
      And le badge "five_perfect" n'est pas déverrouillé

    Scenario: Note 10/10 = 20/20 — parfaite, compte
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 10     | 10  | false           |
      Then le badge "perfect_score" est déverrouillé

    Scenario: 5 notes 20/20 — five_perfect déverrouillé
      Given 5 notes avec valeurSur20 = 20
      Then le badge "perfect_score" est déverrouillé
      And le badge "five_perfect" est déverrouillé

    Scenario: Note nonSignificatif 20/20 ne compte pas
      Given les notes suivantes :
        | valeur | sur | nonSignificatif |
        | 20     | 20  | true            |
      Then le badge "perfect_score" n'est pas déverrouillé

# Badges de régularité — Scénarios Gherkin
# Badges concernés : streak_3, streak_5, streak_10
# Condition : N notes consécutives >= 12/20 (normalisées)

Feature: Badges de régularité

  # ─────────────────────────────────────────────
  # Règles de base
  # ─────────────────────────────────────────────

  Rule: Une note valide est une note avec une valeur numérique et nonSignificatif = false

    Scenario: Note standard sur 20
      Given une note de valeur "14" sur "20" non significative false
      Then la note est valide pour le calcul
      And sa valeur normalisée sur 20 est 14.0

    Scenario: Note sur 10 normalisée sur 20
      Given une note de valeur "8" sur "10" non significative false
      Then la note est valide pour le calcul
      And sa valeur normalisée sur 20 est 16.0

    Scenario: Note sur 10 juste sous le seuil
      Given une note de valeur "5" sur "10" non significative false
      Then la note est valide pour le calcul
      And sa valeur normalisée sur 20 est 10.0

    Scenario: Note absente ignorée
      Given une note de valeur "Abs" sur "20" non significative false
      Then la note n'est pas valide pour le calcul

    Scenario: Note dispensée ignorée
      Given une note de valeur "Disp" sur "20" non significative false
      Then la note n'est pas valide pour le calcul

    Scenario: Note non évaluée ignorée
      Given une note de valeur "NE" sur "20" non significative false
      Then la note n'est pas valide pour le calcul

    Scenario: Note non significative ignorée même avec valeur numérique
      Given une note de valeur "4" sur "20" non significative true
      Then la note n'est pas valide pour le calcul

    Scenario: Note non significative sur 10 ignorée
      Given une note de valeur "3" sur "10" non significative true
      Then la note n'est pas valide pour le calcul

  # ─────────────────────────────────────────────
  # Calcul du streak
  # ─────────────────────────────────────────────

  Rule: Le streak compte les notes valides consécutives >= 12/20, dans l'ordre chronologique par dateSaisie

    Scenario: Aucune note — streak à 0
      Given aucune note
      Then le streak maximum est 0

    Scenario: 3 bonnes notes consécutives
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 13     | 20  | false           | 2026-01-03 |
      Then le streak maximum est 3

    Scenario: 5 bonnes notes consécutives
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 13     | 20  | false           | 2026-01-03 |
        | 16     | 20  | false           | 2026-01-04 |
        | 12     | 20  | false           | 2026-01-05 |
      Then le streak maximum est 5

    Scenario: Streak cassé par une mauvaise note repart de zéro
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 8      | 20  | false           | 2026-01-03 |
        | 13     | 20  | false           | 2026-01-04 |
        | 14     | 20  | false           | 2026-01-05 |
      Then le streak maximum est 2

    Scenario: Le streak maximum est retenu même si la série en cours est plus courte
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 16     | 20  | false           | 2026-01-03 |
        | 8      | 20  | false           | 2026-01-04 |
        | 13     | 20  | false           | 2026-01-05 |
      Then le streak maximum est 3

  Rule: Les notes sur 10 sont normalisées avant comparaison au seuil de 12/20

    Scenario: 6/10 = 12/20 — exactement au seuil, compte dans le streak
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 6      | 10  | false           | 2026-01-01 |
        | 7      | 10  | false           | 2026-01-02 |
        | 8      | 10  | false           | 2026-01-03 |
      Then le streak maximum est 3

    Scenario: 5/10 = 10/20 — sous le seuil, casse le streak
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 7      | 10  | false           | 2026-01-01 |
        | 5      | 10  | false           | 2026-01-02 |
        | 8      | 10  | false           | 2026-01-03 |
      Then le streak maximum est 1

    Scenario: Mélange /10 et /20 dans le même streak
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 7      | 10  | false           | 2026-01-02 |
        | 15     | 20  | false           | 2026-01-03 |
        | 8      | 10  | false           | 2026-01-04 |
      Then le streak maximum est 4

  Rule: Les notes non significatives sont ignorées et ne cassent pas le streak

    Scenario: Note nonSignificatif entre deux bonnes notes ne casse pas le streak
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 4      | 20  | true            | 2026-01-03 |
        | 13     | 20  | false           | 2026-01-04 |
        | 16     | 20  | false           | 2026-01-05 |
      Then le streak maximum est 4

    Scenario: Note Abs entre deux bonnes notes ne casse pas le streak
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | Abs    | 20  | false           | 2026-01-02 |
        | 13     | 20  | false           | 2026-01-03 |
      Then le streak maximum est 2

    Scenario: Plusieurs notes nonSignificatif consécutives ignorées
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 3      | 20  | true            | 2026-01-02 |
        | 2      | 20  | true            | 2026-01-03 |
        | 15     | 20  | false           | 2026-01-04 |
        | 16     | 20  | false           | 2026-01-05 |
      Then le streak maximum est 3

  Rule: Les notes sans dateSaisie sont traitées après les notes datées, ordonnées par id

    Scenario: Note sans date ignorée dans le tri ne casse pas un streak daté
      Given les notes suivantes :
        | id | valeur | sur | nonSignificatif | dateSaisie |
        | 1  | 14     | 20  | false           | 2026-01-01 |
        | 2  | 15     | 20  | false           | 2026-01-02 |
        | 3  | 5      | 20  | false           |            |
        | 4  | 13     | 20  | false           | 2026-01-03 |
      Then le streak maximum est 3

  # ─────────────────────────────────────────────
  # Déverrouillage des badges
  # ─────────────────────────────────────────────

  Rule: Les badges se déverrouillent selon le streak maximum atteint

    Scenario: streak_3 déverrouillé avec 3 notes consécutives >= 12/20
      Given un streak maximum de 3
      Then le badge "streak_3" est déverrouillé
      And le badge "streak_5" n'est pas déverrouillé
      And le badge "streak_10" n'est pas déverrouillé

    Scenario: streak_5 déverrouillé avec 5 notes consécutives >= 12/20
      Given un streak maximum de 5
      Then le badge "streak_3" est déverrouillé
      And le badge "streak_5" est déverrouillé
      And le badge "streak_10" n'est pas déverrouillé

    Scenario: streak_10 déverrouillé avec 10 notes consécutives >= 12/20
      Given un streak maximum de 10
      Then le badge "streak_3" est déverrouillé
      And le badge "streak_5" est déverrouillé
      And le badge "streak_10" est déverrouillé

    Scenario: Cas réel — 20 bonnes notes avec quelques nonSignificatif intercalées
      Given les notes suivantes dans l'ordre chronologique :
        | valeur | sur | nonSignificatif | dateSaisie |
        | 14     | 20  | false           | 2026-01-01 |
        | 15     | 20  | false           | 2026-01-02 |
        | 7      | 10  | false           | 2026-01-03 |
        | 13     | 20  | false           | 2026-01-04 |
        | 4      | 20  | true            | 2026-01-05 |
        | 16     | 20  | false           | 2026-01-06 |
        | 8      | 10  | false           | 2026-01-07 |
        | 14     | 20  | false           | 2026-01-08 |
        | 15     | 20  | false           | 2026-01-09 |
        | 13     | 20  | false           | 2026-01-10 |
        | 3      | 20  | true            | 2026-01-11 |
        | 16     | 20  | false           | 2026-01-12 |
        | 14     | 20  | false           | 2026-01-13 |
        | 7      | 10  | false           | 2026-01-14 |
        | 15     | 20  | false           | 2026-01-15 |
        | 13     | 20  | false           | 2026-01-16 |
        | 14     | 20  | false           | 2026-01-17 |
        | 16     | 20  | false           | 2026-01-18 |
        | 15     | 20  | false           | 2026-01-19 |
        | 14     | 20  | false           | 2026-01-20 |
      Then le streak maximum est 20
      And le badge "streak_3" est déverrouillé
      And le badge "streak_5" est déverrouillé
      And le badge "streak_10" est déverrouillé

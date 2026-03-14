# Badges Régularité (avancés) — Scénarios Gherkin
# Badges : multi_subject_15, all_above_10
#
# multi_subject_15 : subjectsAbove15 >= 3 (moyenne par matière >= 15)
# all_above_10     : toutes les matières ont une moyenne >= 10

Feature: Badges de régularité avancés

  # ─────────────────────────────────────────────
  # multi_subject_15
  # ─────────────────────────────────────────────

  Rule: multi_subject_15 se déverrouille quand au moins 3 matières ont une moyenne >= 15

    Scenario: 0 matière >= 15 — non déverrouillé
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 14.0    |
        | FRANCAIS| 13.5    |
      Then le badge "multi_subject_15" n'est pas déverrouillé

    Scenario: 2 matières >= 15 — non déverrouillé
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 16.0    |
        | FRANCAIS| 15.5    |
        | ANGLAIS | 13.0    |
      Then le badge "multi_subject_15" n'est pas déverrouillé

    Scenario: 3 matières >= 15 — déverrouillé
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 16.0    |
        | FRANCAIS| 15.0    |
        | ANGLAIS | 15.5    |
        | HISTOIRE| 12.0    |
      Then le badge "multi_subject_15" est déverrouillé

    Scenario: Exactement 15.0 — compte (seuil inclusif)
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 15.0    |
        | FRANCAIS| 15.0    |
        | ANGLAIS | 15.0    |
      Then le badge "multi_subject_15" est déverrouillé

    Scenario: 14.9 — ne compte pas
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 14.9    |
        | FRANCAIS| 14.9    |
        | ANGLAIS | 14.9    |
      Then le badge "multi_subject_15" n'est pas déverrouillé

  # ─────────────────────────────────────────────
  # all_above_10
  # ─────────────────────────────────────────────

  Rule: all_above_10 se déverrouille quand toutes les matières ont une moyenne >= 10

    Scenario: Aucune matière enregistrée — non déverrouillé
      Given aucune matière enregistrée
      Then le badge "all_above_10" n'est pas déverrouillé

    Scenario: Toutes les matières >= 10 — déverrouillé
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 12.0    |
        | FRANCAIS| 10.0    |
        | ANGLAIS | 14.5    |
      Then le badge "all_above_10" est déverrouillé

    Scenario: Une matière exactement à 10.0 — compte (seuil inclusif)
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 10.0    |
        | FRANCAIS| 15.0    |
      Then le badge "all_above_10" est déverrouillé

    Scenario: Une matière à 9.9 — non déverrouillé
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 15.0    |
        | FRANCAIS| 9.9     |
        | ANGLAIS | 12.0    |
      Then le badge "all_above_10" n'est pas déverrouillé

    Scenario: Une seule matière sous 10 suffit à bloquer le badge
      Given les moyennes par matière suivantes :
        | matière | moyenne |
        | MATHS   | 18.0    |
        | FRANCAIS| 17.0    |
        | ANGLAIS | 16.0    |
        | HISTOIRE| 9.5     |
      Then le badge "all_above_10" n'est pas déverrouillé

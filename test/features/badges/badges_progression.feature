# Badges de progression — Scénarios Gherkin
# Badges concernés : improvement_05, improvement_1, improvement_2, goal_reached
#
# improvement30Days = moyenne(notes J-30..J) - moyenne(notes J-60..J-30)
# Les deux fenêtres doivent contenir au moins une note pour que le calcul ait lieu.

Feature: Badges de progression

  # ─────────────────────────────────────────────
  # Règles de base — calcul de improvement30Days
  # ─────────────────────────────────────────────

  Rule: improvement30Days compare la moyenne des 30 derniers jours à celle des 30-60 jours passés

    Scenario: Aucune note — pas d'improvement calculé
      Given aucune note
      Then improvement30Days est null
      And aucun badge de progression n'est déverrouillé

    Scenario: Notes uniquement dans la fenêtre récente — pas d'improvement calculé
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 15     | 20  | false           | 2026-03-01  |
        | 14     | 20  | false           | 2026-03-10  |
      Then improvement30Days est null

    Scenario: Notes uniquement dans la fenêtre ancienne — pas d'improvement calculé
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 10     | 20  | false           | 2026-01-20  |
        | 11     | 20  | false           | 2026-01-25  |
      Then improvement30Days est null

    Scenario: Amélioration de 0.5 point — calcul correct
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 10     | 20  | false           | 2026-01-20  |
        | 12     | 20  | false           | 2026-01-25  |
        | 13     | 20  | false           | 2026-03-01  |
        | 12     | 20  | false           | 2026-03-10  |
      # ancienne fenêtre : (10+12)/2 = 11.0
      # récente fenêtre  : (13+12)/2 = 12.5
      # improvement = 12.5 - 11.0 = 1.5
      Then improvement30Days vaut 1.5

    Scenario: Régression — improvement négatif
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 16     | 20  | false           | 2026-01-20  |
        | 14     | 20  | false           | 2026-01-25  |
        | 10     | 20  | false           | 2026-03-01  |
        | 11     | 20  | false           | 2026-03-10  |
      # ancienne : (16+14)/2 = 15.0
      # récente  : (10+11)/2 = 10.5
      # improvement = 10.5 - 15.0 = -4.5
      Then improvement30Days vaut -4.5
      And aucun badge de progression n'est déverrouillé

  # ─────────────────────────────────────────────
  # Règle : normalisation /10 → /20
  # ─────────────────────────────────────────────

  Rule: Les notes sur 10 sont normalisées sur 20 avant le calcul de l'amélioration

    Scenario: Mélange /10 et /20 dans les deux fenêtres
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 5      | 10  | false           | 2026-01-20  |
        | 10     | 20  | false           | 2026-01-25  |
        | 7      | 10  | false           | 2026-03-01  |
        | 16     | 20  | false           | 2026-03-10  |
      # ancienne : (10/20 + 10/20)/2 = (10+10)/2 = 10.0
      # récente  : (14/20 + 16/20)/2 = (14+16)/2 = 15.0
      # improvement = 15.0 - 10.0 = 5.0
      Then improvement30Days vaut 5.0

  # ─────────────────────────────────────────────
  # Règle : notes nonSignificatif exclues
  # ─────────────────────────────────────────────

  Rule: Les notes nonSignificatif sont exclues du calcul de l'amélioration

    Scenario: Note nonSignificatif basse dans la fenêtre récente n'abaisse pas la moyenne
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 10     | 20  | false           | 2026-01-20  |
        | 11     | 20  | false           | 2026-01-25  |
        | 15     | 20  | false           | 2026-03-01  |
        | 14     | 20  | false           | 2026-03-10  |
        | 2      | 20  | true            | 2026-03-12  |
      # ancienne : (10+11)/2 = 10.5
      # récente (sans nonSig) : (15+14)/2 = 14.5
      # improvement = 14.5 - 10.5 = 4.0
      Then improvement30Days vaut 4.0

    Scenario: Note nonSignificatif haute dans la fenêtre ancienne n'élève pas la moyenne ancienne
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 10     | 20  | false           | 2026-01-20  |
        | 19     | 20  | true            | 2026-01-25  |
        | 14     | 20  | false           | 2026-03-01  |
        | 14     | 20  | false           | 2026-03-10  |
      # ancienne (sans nonSig) : 10.0
      # récente : (14+14)/2 = 14.0
      # improvement = 14.0 - 10.0 = 4.0
      Then improvement30Days vaut 4.0

    Scenario: Fenêtre ancienne ne contient que des nonSignificatif — pas d'improvement calculé
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  |
        | 5      | 20  | true            | 2026-01-20  |
        | 3      | 20  | true            | 2026-01-25  |
        | 14     | 20  | false           | 2026-03-01  |
      Then improvement30Days est null

  # ─────────────────────────────────────────────
  # Règle : date utilisée pour le classement
  # ─────────────────────────────────────────────

  Rule: La date de l'examen (dateExamen) détermine dans quelle fenêtre tombe la note

    Scenario: Note saisie récemment mais examen ancien tombe dans la bonne fenêtre
      Given aujourd'hui est le 2026-03-14
      And les notes suivantes :
        | valeur | sur | nonSignificatif | dateExamen  | dateSaisie  |
        | 10     | 20  | false           | 2026-01-20  | 2026-03-13  |
        | 14     | 20  | false           | 2026-03-01  | 2026-03-13  |
      # dateExamen 2026-01-20 → fenêtre ancienne (J-60..J-30)
      # dateExamen 2026-03-01 → fenêtre récente (J-30..J)
      Then improvement30Days vaut 4.0

  # ─────────────────────────────────────────────
  # Déverrouillage des badges improvement
  # ─────────────────────────────────────────────

  Rule: Les badges improvement se déverrouillent selon le seuil d'amélioration atteint

    Scenario: improvement_05 déverrouillé avec +0.5 point
      Given improvement30Days vaut 0.5
      Then le badge "improvement_05" est déverrouillé
      And le badge "improvement_1" n'est pas déverrouillé
      And le badge "improvement_2" n'est pas déverrouillé

    Scenario: improvement_1 déverrouillé avec +1.0 point
      Given improvement30Days vaut 1.0
      Then le badge "improvement_05" est déverrouillé
      And le badge "improvement_1" est déverrouillé
      And le badge "improvement_2" n'est pas déverrouillé

    Scenario: improvement_2 déverrouillé avec +2.0 points
      Given improvement30Days vaut 2.0
      Then le badge "improvement_05" est déverrouillé
      And le badge "improvement_1" est déverrouillé
      And le badge "improvement_2" est déverrouillé

    Scenario: improvement null — aucun badge
      Given improvement30Days est null
      Then le badge "improvement_05" n'est pas déverrouillé

    Scenario: improvement négatif — aucun badge
      Given improvement30Days vaut -1.0
      Then le badge "improvement_05" n'est pas déverrouillé

  # ─────────────────────────────────────────────
  # Badge goal_reached
  # ─────────────────────────────────────────────

  Rule: goal_reached se déverrouille quand la moyenne générale atteint l'objectif fixé

    Scenario: Objectif atteint exactement
      Given une moyenne générale de 14.0
      And un objectif fixé à 14.0
      Then le badge "goal_reached" est déverrouillé

    Scenario: Objectif dépassé
      Given une moyenne générale de 15.5
      And un objectif fixé à 14.0
      Then le badge "goal_reached" est déverrouillé

    Scenario: Objectif non atteint
      Given une moyenne générale de 13.9
      And un objectif fixé à 14.0
      Then le badge "goal_reached" n'est pas déverrouillé

    Scenario: Pas d'objectif fixé — badge non déverrouillé
      Given une moyenne générale de 18.0
      And aucun objectif fixé
      Then le badge "goal_reached" n'est pas déverrouillé

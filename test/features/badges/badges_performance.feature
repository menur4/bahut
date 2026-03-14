# Badges Performance — Scénarios Gherkin
# Badges : above_average (≥12), good_student (≥14), excellent (≥16), outstanding (≥18)
#
# Basés sur ctx.generalAverage = stats.generalAverage (calcul pondéré par coef)
# Les notes nonSignificatif sont déjà exclues par le moteur de calcul des statistiques.

Feature: Badges de performance

  Rule: Les badges se déverrouillent selon la moyenne générale pondérée

    Scenario: Moyenne 11.9 — aucun badge de performance
      Given une moyenne générale de 11.9
      Then le badge "above_average" n'est pas déverrouillé
      And le badge "good_student" n'est pas déverrouillé
      And le badge "excellent" n'est pas déverrouillé
      And le badge "outstanding" n'est pas déverrouillé

    Scenario: Moyenne exactement 12.0 — above_average déverrouillé
      Given une moyenne générale de 12.0
      Then le badge "above_average" est déverrouillé
      And le badge "good_student" n'est pas déverrouillé

    Scenario: Moyenne 14.0 — above_average et good_student déverrouillés
      Given une moyenne générale de 14.0
      Then le badge "above_average" est déverrouillé
      And le badge "good_student" est déverrouillé
      And le badge "excellent" n'est pas déverrouillé

    Scenario: Moyenne 16.0 — excellent déverrouillé
      Given une moyenne générale de 16.0
      Then le badge "excellent" est déverrouillé
      And le badge "outstanding" n'est pas déverrouillé

    Scenario: Moyenne 18.0 — tous les badges de performance déverrouillés
      Given une moyenne générale de 18.0
      Then le badge "above_average" est déverrouillé
      And le badge "good_student" est déverrouillé
      And le badge "excellent" est déverrouillé
      And le badge "outstanding" est déverrouillé

    Scenario: Moyenne nulle (pas encore de notes) — aucun badge
      Given une moyenne générale de 0
      Then le badge "above_average" n'est pas déverrouillé

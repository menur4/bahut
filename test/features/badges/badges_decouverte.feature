# Badges Découverte — Scénarios Gherkin
# Badges : first_grade, ten_grades, fifty_grades, hundred_grades
#
# Basés sur ctx.totalGrades = gradesState.grades.length
# Question ouverte : totalGrades doit-il compter les notes invalides (Abs, Disp, nonSignificatif) ?

Feature: Badges de découverte

  Rule: totalGrades représente le nombre de notes reçues (valides uniquement)

    Scenario: 0 notes — aucun badge
      Given 0 notes au total
      Then le badge "first_grade" n'est pas déverrouillé

    Scenario: 1 note valide — first_grade déverrouillé
      Given 1 note valide
      Then le badge "first_grade" est déverrouillé
      And le badge "ten_grades" n'est pas déverrouillé

    Scenario: 10 notes valides — ten_grades déverrouillé
      Given 10 notes valides
      Then le badge "first_grade" est déverrouillé
      And le badge "ten_grades" est déverrouillé
      And le badge "fifty_grades" n'est pas déverrouillé

    Scenario: 50 notes valides — fifty_grades déverrouillé
      Given 50 notes valides
      Then le badge "fifty_grades" est déverrouillé
      And le badge "hundred_grades" n'est pas déverrouillé

    Scenario: 100 notes valides — hundred_grades déverrouillé
      Given 100 notes valides
      Then le badge "hundred_grades" est déverrouillé

  Rule: Les notes Abs, Disp, NE et nonSignificatif ne comptent pas dans totalGrades

    Scenario: 1 note Abs + 0 note valide — first_grade non déverrouillé
      Given les notes suivantes :
        | valeur | nonSignificatif |
        | Abs    | false           |
      Then le badge "first_grade" n'est pas déverrouillé

    Scenario: 1 note nonSignificatif + 0 note valide — first_grade non déverrouillé
      Given les notes suivantes :
        | valeur | nonSignificatif |
        | 15     | true            |
      Then le badge "first_grade" n'est pas déverrouillé

    Scenario: 9 notes valides + 5 notes Abs — ten_grades non déverrouillé
      Given 9 notes valides et 5 notes Abs
      Then le badge "ten_grades" n'est pas déverrouillé

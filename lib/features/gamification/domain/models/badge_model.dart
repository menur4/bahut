import 'package:flutter/material.dart';

/// Catégories de badges
enum BadgeCategory {
  performance('Performance'),
  progression('Progression'),
  regularite('Régularité'),
  decouverte('Découverte'),
  excellence('Excellence');

  final String label;
  const BadgeCategory(this.label);
}

/// Rareté des badges
enum BadgeRarity {
  common('Commun', 0xFF9E9E9E),      // Gris
  uncommon('Peu commun', 0xFF4CAF50), // Vert
  rare('Rare', 0xFF2196F3),           // Bleu
  epic('Épique', 0xFF9C27B0),         // Violet
  legendary('Légendaire', 0xFFFF9800); // Or

  final String label;
  final int colorValue;
  const BadgeRarity(this.label, this.colorValue);

  Color get color => Color(colorValue);
}

/// Modèle d'un badge
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final bool Function(BadgeContext context) checkUnlock;
  final String? progressDescription;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
    required this.checkUnlock,
    this.progressDescription,
  });
}

/// Contexte pour vérifier le déblocage des badges
class BadgeContext {
  final int totalGrades;
  final double? generalAverage;
  final double? previousAverage;
  final int consecutiveGoodGrades;
  final int daysWithApp;
  final int subjectsAbove15;
  final int subjectsAbove18;
  final double? bestGrade;
  final double? improvement30Days;
  final bool hasReachedGoal;
  final int gradesAbove15;
  final int gradesAbove18;
  final int perfectGrades;
  final Map<String, double> subjectAverages;

  const BadgeContext({
    this.totalGrades = 0,
    this.generalAverage,
    this.previousAverage,
    this.consecutiveGoodGrades = 0,
    this.daysWithApp = 0,
    this.subjectsAbove15 = 0,
    this.subjectsAbove18 = 0,
    this.bestGrade,
    this.improvement30Days,
    this.hasReachedGoal = false,
    this.gradesAbove15 = 0,
    this.gradesAbove18 = 0,
    this.perfectGrades = 0,
    this.subjectAverages = const {},
  });
}

/// Badge débloqué par l'utilisateur
class UnlockedBadge {
  final String badgeId;
  final DateTime unlockedAt;
  final bool seen;

  const UnlockedBadge({
    required this.badgeId,
    required this.unlockedAt,
    this.seen = false,
  });

  UnlockedBadge copyWith({
    String? badgeId,
    DateTime? unlockedAt,
    bool? seen,
  }) {
    return UnlockedBadge(
      badgeId: badgeId ?? this.badgeId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badgeId': badgeId,
      'unlockedAt': unlockedAt.toIso8601String(),
      'seen': seen,
    };
  }

  factory UnlockedBadge.fromJson(Map<String, dynamic> json) {
    return UnlockedBadge(
      badgeId: json['badgeId'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      seen: json['seen'] as bool? ?? false,
    );
  }
}

/// Liste de tous les badges disponibles
class BadgeDefinitions {
  static final List<BadgeModel> all = [
    // === DÉCOUVERTE ===
    BadgeModel(
      id: 'first_grade',
      name: 'Première note',
      description: 'Reçois ta première note',
      icon: '🎯',
      category: BadgeCategory.decouverte,
      rarity: BadgeRarity.common,
      checkUnlock: (ctx) => ctx.totalGrades >= 1,
    ),
    BadgeModel(
      id: 'ten_grades',
      name: 'En route',
      description: 'Accumule 10 notes',
      icon: '📚',
      category: BadgeCategory.decouverte,
      rarity: BadgeRarity.common,
      checkUnlock: (ctx) => ctx.totalGrades >= 10,
    ),
    BadgeModel(
      id: 'fifty_grades',
      name: 'Collectionneur',
      description: 'Accumule 50 notes',
      icon: '🗂️',
      category: BadgeCategory.decouverte,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) => ctx.totalGrades >= 50,
    ),
    BadgeModel(
      id: 'hundred_grades',
      name: 'Vétéran',
      description: 'Accumule 100 notes',
      icon: '🏛️',
      category: BadgeCategory.decouverte,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => ctx.totalGrades >= 100,
    ),

    // === PERFORMANCE ===
    BadgeModel(
      id: 'above_average',
      name: 'Au-dessus du lot',
      description: 'Atteins une moyenne générale de 12/20',
      icon: '📈',
      category: BadgeCategory.performance,
      rarity: BadgeRarity.common,
      checkUnlock: (ctx) => (ctx.generalAverage ?? 0) >= 12,
    ),
    BadgeModel(
      id: 'good_student',
      name: 'Bon élève',
      description: 'Atteins une moyenne générale de 14/20',
      icon: '⭐',
      category: BadgeCategory.performance,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) => (ctx.generalAverage ?? 0) >= 14,
    ),
    BadgeModel(
      id: 'excellent',
      name: 'Excellent',
      description: 'Atteins une moyenne générale de 16/20',
      icon: '🌟',
      category: BadgeCategory.performance,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => (ctx.generalAverage ?? 0) >= 16,
    ),
    BadgeModel(
      id: 'outstanding',
      name: 'Exceptionnel',
      description: 'Atteins une moyenne générale de 18/20',
      icon: '💫',
      category: BadgeCategory.performance,
      rarity: BadgeRarity.epic,
      checkUnlock: (ctx) => (ctx.generalAverage ?? 0) >= 18,
    ),

    // === EXCELLENCE ===
    BadgeModel(
      id: 'first_15',
      name: 'Belle note',
      description: 'Obtiens une note de 15/20 ou plus',
      icon: '✨',
      category: BadgeCategory.excellence,
      rarity: BadgeRarity.common,
      checkUnlock: (ctx) => ctx.gradesAbove15 >= 1,
    ),
    BadgeModel(
      id: 'ten_15',
      name: 'Régulier',
      description: 'Obtiens 10 notes de 15/20 ou plus',
      icon: '🎖️',
      category: BadgeCategory.excellence,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) => ctx.gradesAbove15 >= 10,
    ),
    BadgeModel(
      id: 'first_18',
      name: 'Très belle note',
      description: 'Obtiens une note de 18/20 ou plus',
      icon: '🏅',
      category: BadgeCategory.excellence,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => ctx.gradesAbove18 >= 1,
    ),
    BadgeModel(
      id: 'perfect_score',
      name: 'Perfection',
      description: 'Obtiens un 20/20',
      icon: '👑',
      category: BadgeCategory.excellence,
      rarity: BadgeRarity.legendary,
      checkUnlock: (ctx) => ctx.perfectGrades >= 1,
    ),
    BadgeModel(
      id: 'five_perfect',
      name: 'Génie',
      description: 'Obtiens 5 notes de 20/20',
      icon: '🧠',
      category: BadgeCategory.excellence,
      rarity: BadgeRarity.legendary,
      checkUnlock: (ctx) => ctx.perfectGrades >= 5,
    ),

    // === PROGRESSION ===
    BadgeModel(
      id: 'goal_reached',
      name: 'Objectif atteint',
      description: 'Atteins ton objectif de moyenne',
      icon: '🎯',
      category: BadgeCategory.progression,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => ctx.hasReachedGoal,
    ),
    BadgeModel(
      id: 'improvement_05',
      name: 'Progression',
      description: 'Améliore ta moyenne de 0.5 point en 30 jours',
      icon: '📊',
      category: BadgeCategory.progression,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) => (ctx.improvement30Days ?? 0) >= 0.5,
    ),
    BadgeModel(
      id: 'improvement_1',
      name: 'Belle progression',
      description: 'Améliore ta moyenne de 1 point en 30 jours',
      icon: '🚀',
      category: BadgeCategory.progression,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => (ctx.improvement30Days ?? 0) >= 1.0,
    ),
    BadgeModel(
      id: 'improvement_2',
      name: 'Transformation',
      description: 'Améliore ta moyenne de 2 points en 30 jours',
      icon: '🦋',
      category: BadgeCategory.progression,
      rarity: BadgeRarity.epic,
      checkUnlock: (ctx) => (ctx.improvement30Days ?? 0) >= 2.0,
    ),

    // === RÉGULARITÉ ===
    BadgeModel(
      id: 'streak_3',
      name: 'Série',
      description: '3 bonnes notes consécutives (≥12)',
      icon: '🔥',
      category: BadgeCategory.regularite,
      rarity: BadgeRarity.common,
      checkUnlock: (ctx) => ctx.consecutiveGoodGrades >= 3,
    ),
    BadgeModel(
      id: 'streak_5',
      name: 'En feu',
      description: '5 bonnes notes consécutives (≥12)',
      icon: '🔥',
      category: BadgeCategory.regularite,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) => ctx.consecutiveGoodGrades >= 5,
    ),
    BadgeModel(
      id: 'streak_10',
      name: 'Inarrêtable',
      description: '10 bonnes notes consécutives (≥12)',
      icon: '💥',
      category: BadgeCategory.regularite,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => ctx.consecutiveGoodGrades >= 10,
    ),
    BadgeModel(
      id: 'multi_subject_15',
      name: 'Polyvalent',
      description: 'Moyenne ≥15 dans 3 matières différentes',
      icon: '🎨',
      category: BadgeCategory.regularite,
      rarity: BadgeRarity.rare,
      checkUnlock: (ctx) => ctx.subjectsAbove15 >= 3,
    ),
    BadgeModel(
      id: 'all_above_10',
      name: 'Équilibré',
      description: 'Toutes tes matières au-dessus de 10',
      icon: '⚖️',
      category: BadgeCategory.regularite,
      rarity: BadgeRarity.uncommon,
      checkUnlock: (ctx) {
        if (ctx.subjectAverages.isEmpty) return false;
        return ctx.subjectAverages.values.every((avg) => avg >= 10);
      },
    ),
  ];

  static BadgeModel? getById(String id) {
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<BadgeModel> getByCategory(BadgeCategory category) {
    return all.where((b) => b.category == category).toList();
  }

  static List<BadgeModel> getByRarity(BadgeRarity rarity) {
    return all.where((b) => b.rarity == rarity).toList();
  }
}

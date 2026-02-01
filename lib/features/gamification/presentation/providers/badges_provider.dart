import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../grades/data/models/grade_model.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../../statistics/presentation/providers/goals_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';
import '../../domain/models/badge_model.dart';

const _unlockedBadgesKey = 'unlocked_badges';
const _badgeStatsKey = 'badge_stats';

/// État des badges
class BadgesState {
  final List<UnlockedBadge> unlockedBadges;
  final List<String> newlyUnlockedIds;
  final bool isLoading;
  final int consecutiveGoodGrades;
  final int daysWithApp;

  const BadgesState({
    this.unlockedBadges = const [],
    this.newlyUnlockedIds = const [],
    this.isLoading = true,
    this.consecutiveGoodGrades = 0,
    this.daysWithApp = 0,
  });

  int get unlockedCount => unlockedBadges.length;
  int get totalBadges => BadgeDefinitions.all.length;
  int get unseenCount => unlockedBadges.where((b) => !b.seen).length;

  bool isUnlocked(String badgeId) {
    return unlockedBadges.any((b) => b.badgeId == badgeId);
  }

  UnlockedBadge? getUnlocked(String badgeId) {
    try {
      return unlockedBadges.firstWhere((b) => b.badgeId == badgeId);
    } catch (_) {
      return null;
    }
  }

  BadgesState copyWith({
    List<UnlockedBadge>? unlockedBadges,
    List<String>? newlyUnlockedIds,
    bool? isLoading,
    int? consecutiveGoodGrades,
    int? daysWithApp,
  }) {
    return BadgesState(
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      newlyUnlockedIds: newlyUnlockedIds ?? this.newlyUnlockedIds,
      isLoading: isLoading ?? this.isLoading,
      consecutiveGoodGrades: consecutiveGoodGrades ?? this.consecutiveGoodGrades,
      daysWithApp: daysWithApp ?? this.daysWithApp,
    );
  }
}

/// Provider pour les badges
final badgesProvider = StateNotifierProvider<BadgesNotifier, BadgesState>((ref) {
  return BadgesNotifier(ref);
});

/// Provider pour le contexte des badges (recalculé automatiquement)
final badgeContextProvider = Provider<BadgeContext>((ref) {
  final gradesState = ref.watch(gradesStateProvider);
  final stats = ref.watch(globalStatsProvider);
  final goalsState = ref.watch(goalsProvider);
  final badgesState = ref.watch(badgesProvider);

  // Calculer les notes au-dessus de 15 et 18
  int gradesAbove15 = 0;
  int gradesAbove18 = 0;
  int perfectGrades = 0;

  for (final grade in gradesState.grades) {
    final val = grade.valeurSur20;
    if (val != null) {
      if (val >= 15) gradesAbove15++;
      if (val >= 18) gradesAbove18++;
      if (val >= 20) perfectGrades++;
    }
  }

  // Calculer les matières au-dessus de 15 et 18
  int subjectsAbove15 = 0;
  int subjectsAbove18 = 0;
  final subjectAverages = <String, double>{};

  for (final subject in stats.subjectStats) {
    subjectAverages[subject.subjectCode] = subject.average;
    if (subject.average >= 15) subjectsAbove15++;
    if (subject.average >= 18) subjectsAbove18++;
  }

  // Vérifier si l'objectif est atteint
  bool hasReachedGoal = false;
  if (goalsState.generalGoal != null && stats.generalAverage > 0) {
    hasReachedGoal = stats.generalAverage >= goalsState.generalGoal!.targetAverage;
  }

  // Trouver la meilleure note
  double? bestGrade;
  for (final grade in gradesState.grades) {
    final val = grade.valeurSur20;
    if (val != null && (bestGrade == null || val > bestGrade)) {
      bestGrade = val;
    }
  }

  return BadgeContext(
    totalGrades: gradesState.grades.length,
    generalAverage: stats.generalAverage > 0 ? stats.generalAverage : null,
    consecutiveGoodGrades: badgesState.consecutiveGoodGrades,
    daysWithApp: badgesState.daysWithApp,
    subjectsAbove15: subjectsAbove15,
    subjectsAbove18: subjectsAbove18,
    bestGrade: bestGrade,
    hasReachedGoal: hasReachedGoal,
    gradesAbove15: gradesAbove15,
    gradesAbove18: gradesAbove18,
    perfectGrades: perfectGrades,
    subjectAverages: subjectAverages,
  );
});

/// Notifier pour gérer les badges
class BadgesNotifier extends StateNotifier<BadgesState> {
  final Ref _ref;

  BadgesNotifier(this._ref) : super(const BadgesState()) {
    _loadBadges();
    _setupListeners();
  }

  void _setupListeners() {
    // Écouter les changements de notes pour vérifier les badges
    _ref.listen(gradesStateProvider, (previous, next) {
      if (previous?.grades.length != next.grades.length) {
        _updateConsecutiveGrades(next.grades);
        checkAndUnlockBadges();
      }
    });

    // Écouter les changements de stats
    _ref.listen(globalStatsProvider, (previous, next) {
      checkAndUnlockBadges();
    });

    // Écouter les changements d'objectifs
    _ref.listen(goalsProvider, (previous, next) {
      checkAndUnlockBadges();
    });
  }

  void _updateConsecutiveGrades(List<dynamic> grades) {
    // Calculer les notes consécutives au-dessus de 12
    int consecutive = 0;
    int maxConsecutive = 0;

    // Trier par date
    final sortedGrades = List.from(grades)
      ..sort((a, b) {
        final dateA = a.dateTime;
        final dateB = b.dateTime;
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });

    for (final grade in sortedGrades) {
      final val = grade.valeurSur20;
      if (val != null && val >= 12) {
        consecutive++;
        if (consecutive > maxConsecutive) {
          maxConsecutive = consecutive;
        }
      } else {
        consecutive = 0;
      }
    }

    if (maxConsecutive != state.consecutiveGoodGrades) {
      state = state.copyWith(consecutiveGoodGrades: maxConsecutive);
      _saveStats();
    }
  }

  Future<void> _loadBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Charger les badges débloqués
      final badgesJson = prefs.getString(_unlockedBadgesKey);
      List<UnlockedBadge> unlocked = [];
      if (badgesJson != null) {
        final List<dynamic> decoded = jsonDecode(badgesJson);
        unlocked = decoded
            .map((e) => UnlockedBadge.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Charger les stats
      final statsJson = prefs.getString(_badgeStatsKey);
      int consecutiveGrades = 0;
      int daysWithApp = 1;
      if (statsJson != null) {
        final stats = jsonDecode(statsJson) as Map<String, dynamic>;
        consecutiveGrades = stats['consecutiveGoodGrades'] as int? ?? 0;
        daysWithApp = stats['daysWithApp'] as int? ?? 1;

        // Vérifier si c'est un nouveau jour
        final lastVisit = stats['lastVisit'] as String?;
        if (lastVisit != null) {
          final lastDate = DateTime.parse(lastVisit);
          final today = DateTime.now();
          if (lastDate.day != today.day ||
              lastDate.month != today.month ||
              lastDate.year != today.year) {
            daysWithApp++;
          }
        }
      }

      state = state.copyWith(
        unlockedBadges: unlocked,
        consecutiveGoodGrades: consecutiveGrades,
        daysWithApp: daysWithApp,
        isLoading: false,
      );

      await _saveStats();

      // Vérifier les nouveaux badges
      checkAndUnlockBadges();
    } catch (e) {
      debugPrint('[BADGES] Erreur chargement: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _saveBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        state.unlockedBadges.map((b) => b.toJson()).toList(),
      );
      await prefs.setString(_unlockedBadgesKey, json);
    } catch (e) {
      debugPrint('[BADGES] Erreur sauvegarde: $e');
    }
  }

  Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stats = {
        'consecutiveGoodGrades': state.consecutiveGoodGrades,
        'daysWithApp': state.daysWithApp,
        'lastVisit': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_badgeStatsKey, jsonEncode(stats));
    } catch (e) {
      debugPrint('[BADGES] Erreur sauvegarde stats: $e');
    }
  }

  /// Vérifie et débloque les nouveaux badges
  void checkAndUnlockBadges() {
    if (state.isLoading) return;

    final context = _ref.read(badgeContextProvider);
    final newlyUnlocked = <String>[];

    for (final badge in BadgeDefinitions.all) {
      // Si déjà débloqué, passer
      if (state.isUnlocked(badge.id)) continue;

      // Vérifier si le badge peut être débloqué
      try {
        if (badge.checkUnlock(context)) {
          newlyUnlocked.add(badge.id);
        }
      } catch (e) {
        debugPrint('[BADGES] Erreur vérification ${badge.id}: $e');
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      final now = DateTime.now();
      final newBadges = newlyUnlocked
          .map((id) => UnlockedBadge(badgeId: id, unlockedAt: now))
          .toList();

      state = state.copyWith(
        unlockedBadges: [...state.unlockedBadges, ...newBadges],
        newlyUnlockedIds: newlyUnlocked,
      );

      _saveBadges();
      debugPrint('[BADGES] Nouveaux badges débloqués: $newlyUnlocked');
    }
  }

  /// Marque un badge comme vu
  void markAsSeen(String badgeId) {
    final index = state.unlockedBadges.indexWhere((b) => b.badgeId == badgeId);
    if (index == -1) return;

    final updated = List<UnlockedBadge>.from(state.unlockedBadges);
    updated[index] = updated[index].copyWith(seen: true);

    state = state.copyWith(
      unlockedBadges: updated,
      newlyUnlockedIds: state.newlyUnlockedIds.where((id) => id != badgeId).toList(),
    );

    _saveBadges();
  }

  /// Marque tous les badges comme vus
  void markAllAsSeen() {
    final updated = state.unlockedBadges
        .map((b) => b.copyWith(seen: true))
        .toList();

    state = state.copyWith(
      unlockedBadges: updated,
      newlyUnlockedIds: [],
    );

    _saveBadges();
  }

  /// Efface les badges nouvellement débloqués (après affichage)
  void clearNewlyUnlocked() {
    state = state.copyWith(newlyUnlockedIds: []);
  }
}

/// Provider pour les badges récemment débloqués
final newlyUnlockedBadgesProvider = Provider<List<BadgeModel>>((ref) {
  final badgesState = ref.watch(badgesProvider);
  return badgesState.newlyUnlockedIds
      .map((id) => BadgeDefinitions.getById(id))
      .whereType<BadgeModel>()
      .toList();
});

/// Provider pour les badges par catégorie
final badgesByCategoryProvider = Provider<Map<BadgeCategory, List<({BadgeModel badge, bool unlocked})>>>((ref) {
  final badgesState = ref.watch(badgesProvider);
  final result = <BadgeCategory, List<({BadgeModel badge, bool unlocked})>>{};

  for (final category in BadgeCategory.values) {
    final badges = BadgeDefinitions.getByCategory(category);
    result[category] = badges.map((badge) {
      return (badge: badge, unlocked: badgesState.isUnlocked(badge.id));
    }).toList();
  }

  return result;
});

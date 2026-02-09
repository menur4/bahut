import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

/// Provider pour l'objectif de moyenne
final averageGoalProvider =
    StateNotifierProvider<AverageGoalNotifier, double?>((ref) {
  return AverageGoalNotifier();
});

/// Notifier pour gérer l'objectif de moyenne
class AverageGoalNotifier extends StateNotifier<double?> {
  AverageGoalNotifier() : super(null) {
    _loadGoal();
  }

  /// Charge l'objectif depuis les préférences
  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getDouble(AppConstants.prefAverageGoal);
    state = goal;
  }

  /// Définit un nouvel objectif
  Future<void> setGoal(double? goal) async {
    final prefs = await SharedPreferences.getInstance();
    if (goal != null && goal > 0 && goal <= 20) {
      await prefs.setDouble(AppConstants.prefAverageGoal, goal);
      state = goal;
    } else {
      await prefs.remove(AppConstants.prefAverageGoal);
      state = null;
    }
  }

  /// Supprime l'objectif
  Future<void> clearGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefAverageGoal);
    state = null;
  }
}

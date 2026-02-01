import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';

/// Fréquence de synchronisation en arrière-plan
enum SyncFrequency {
  minutes15(Duration(minutes: 15), 'Toutes les 15 min'),
  minutes30(Duration(minutes: 30), 'Toutes les 30 min'),
  hourly(Duration(hours: 1), 'Toutes les heures'),
  every3Hours(Duration(hours: 3), 'Toutes les 3 heures'),
  every6Hours(Duration(hours: 6), 'Toutes les 6 heures'),
  every12Hours(Duration(hours: 12), 'Toutes les 12 heures'),
  daily(Duration(hours: 24), 'Une fois par jour');

  final Duration duration;
  final String label;

  const SyncFrequency(this.duration, this.label);

  static SyncFrequency fromString(String? value) {
    return SyncFrequency.values.firstWhere(
      (f) => f.name == value,
      orElse: () => SyncFrequency.hourly,
    );
  }
}

/// Nom de la tâche de synchronisation
const String backgroundSyncTaskName = 'backgroundSyncTask';
const String backgroundSyncTaskTag = 'backgroundSync';

/// Callback pour le workmanager (doit être une fonction top-level)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[BACKGROUND_SYNC] Task started: $task');

    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool(AppConstants.prefBackgroundSyncEnabled) ?? false;

      if (!isEnabled) {
        debugPrint('[BACKGROUND_SYNC] Sync disabled, skipping');
        return true;
      }

      // Marquer qu'une sync est en attente pour:
      // - Les notes (si activé)
      // - Le calendrier (si activé)
      final gradesSyncEnabled = prefs.getBool(AppConstants.prefGradesSyncEnabled) ?? true;
      final calendarSyncEnabled = prefs.getBool(AppConstants.prefCalendarSyncEnabled) ?? false;

      if (gradesSyncEnabled || calendarSyncEnabled) {
        await prefs.setBool(AppConstants.prefPendingBackgroundSync, true);
        debugPrint('[BACKGROUND_SYNC] Marked pending sync (grades: $gradesSyncEnabled, calendar: $calendarSyncEnabled)');
      }

      return true;
    } catch (e) {
      debugPrint('[BACKGROUND_SYNC] Error: $e');
      return false;
    }
  });
}

/// Service pour gérer la synchronisation en arrière-plan
class BackgroundSyncService {
  static final BackgroundSyncService _instance = BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();

  bool _isInitialized = false;

  /// Initialise le workmanager
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    _isInitialized = true;
    debugPrint('[BACKGROUND_SYNC] Workmanager initialized');
  }

  /// Planifie la synchronisation périodique
  Future<void> schedulePeriodicSync(SyncFrequency frequency) async {
    await initialize();

    // Annuler les tâches existantes
    await cancelSync();

    // Planifier la nouvelle tâche
    await Workmanager().registerPeriodicTask(
      backgroundSyncTaskName,
      backgroundSyncTaskName,
      frequency: frequency.duration,
      tag: backgroundSyncTaskTag,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    debugPrint('[BACKGROUND_SYNC] Scheduled periodic sync: ${frequency.label}');
  }

  /// Annule la synchronisation en arrière-plan
  Future<void> cancelSync() async {
    await initialize();
    await Workmanager().cancelByTag(backgroundSyncTaskTag);
    debugPrint('[BACKGROUND_SYNC] Cancelled all sync tasks');
  }

  /// Lance une synchronisation immédiate en arrière-plan
  Future<void> syncNow() async {
    await initialize();
    await Workmanager().registerOneOffTask(
      '${backgroundSyncTaskName}_immediate',
      backgroundSyncTaskName,
      tag: backgroundSyncTaskTag,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    debugPrint('[BACKGROUND_SYNC] Scheduled immediate sync');
  }

  /// Vérifie si une sync est en attente et la traite
  Future<bool> checkPendingSync() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getBool(AppConstants.prefPendingBackgroundSync) ?? false;
    if (pending) {
      await prefs.setBool(AppConstants.prefPendingBackgroundSync, false);
    }
    return pending;
  }
}

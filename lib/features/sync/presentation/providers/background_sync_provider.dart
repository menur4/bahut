import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/background_sync_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../grades/presentation/providers/grades_provider.dart';
import '../../../calendar_sync/presentation/providers/calendar_sync_provider.dart' show calendarSyncStateProvider;

/// État de la synchronisation en arrière-plan
class BackgroundSyncState {
  final bool isEnabled;
  final SyncFrequency frequency;
  final bool syncGrades;
  final bool notifyNewGrades;
  final bool syncCalendar;
  final DateTime? lastSyncTime;
  final bool isSyncing;
  final String? errorMessage;

  const BackgroundSyncState({
    this.isEnabled = false,
    this.frequency = SyncFrequency.hourly,
    this.syncGrades = true,
    this.notifyNewGrades = true,
    this.syncCalendar = false,
    this.lastSyncTime,
    this.isSyncing = false,
    this.errorMessage,
  });

  BackgroundSyncState copyWith({
    bool? isEnabled,
    SyncFrequency? frequency,
    bool? syncGrades,
    bool? notifyNewGrades,
    bool? syncCalendar,
    DateTime? lastSyncTime,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return BackgroundSyncState(
      isEnabled: isEnabled ?? this.isEnabled,
      frequency: frequency ?? this.frequency,
      syncGrades: syncGrades ?? this.syncGrades,
      notifyNewGrades: notifyNewGrades ?? this.notifyNewGrades,
      syncCalendar: syncCalendar ?? this.syncCalendar,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage,
    );
  }
}

/// Provider pour la synchronisation en arrière-plan
final backgroundSyncProvider =
    StateNotifierProvider<BackgroundSyncNotifier, BackgroundSyncState>((ref) {
  return BackgroundSyncNotifier(ref);
});

class BackgroundSyncNotifier extends StateNotifier<BackgroundSyncState> {
  final Ref _ref;
  final BackgroundSyncService _syncService = BackgroundSyncService();

  BackgroundSyncNotifier(this._ref) : super(const BackgroundSyncState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final isEnabled = prefs.getBool(AppConstants.prefBackgroundSyncEnabled) ?? false;
    final frequencyStr = prefs.getString(AppConstants.prefBackgroundSyncFrequency);
    final syncGrades = prefs.getBool(AppConstants.prefGradesSyncEnabled) ?? true;
    final notifyNewGrades = prefs.getBool(AppConstants.prefGradesNotifyEnabled) ?? true;
    final syncCalendar = prefs.getBool(AppConstants.prefCalendarSyncEnabled) ?? false;
    final lastSyncStr = prefs.getString(AppConstants.prefLastSync);

    state = state.copyWith(
      isEnabled: isEnabled,
      frequency: SyncFrequency.fromString(frequencyStr),
      syncGrades: syncGrades,
      notifyNewGrades: notifyNewGrades,
      syncCalendar: syncCalendar,
      lastSyncTime: lastSyncStr != null ? DateTime.tryParse(lastSyncStr) : null,
    );

    // Vérifier si une sync en arrière-plan est en attente
    await _checkPendingSync();
  }

  Future<void> _checkPendingSync() async {
    final hasPending = await _syncService.checkPendingSync();
    if (hasPending && state.isEnabled) {
      debugPrint('[BACKGROUND_SYNC_PROVIDER] Pending sync detected, triggering...');
      await syncNow();
    }
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefBackgroundSyncEnabled, state.isEnabled);
    await prefs.setString(AppConstants.prefBackgroundSyncFrequency, state.frequency.name);
    await prefs.setBool(AppConstants.prefGradesSyncEnabled, state.syncGrades);
    await prefs.setBool(AppConstants.prefGradesNotifyEnabled, state.notifyNewGrades);
    await prefs.setBool(AppConstants.prefCalendarSyncEnabled, state.syncCalendar);
  }

  /// Active ou désactive la synchronisation en arrière-plan
  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(isEnabled: enabled);
    await _savePreferences();

    if (enabled) {
      await _syncService.schedulePeriodicSync(state.frequency);
    } else {
      await _syncService.cancelSync();
    }
  }

  /// Change la fréquence de synchronisation
  Future<void> setFrequency(SyncFrequency frequency) async {
    state = state.copyWith(frequency: frequency);
    await _savePreferences();

    if (state.isEnabled) {
      await _syncService.schedulePeriodicSync(frequency);
    }
  }

  /// Active ou désactive la synchronisation des notes
  Future<void> setSyncGrades(bool enabled) async {
    state = state.copyWith(syncGrades: enabled);
    await _savePreferences();
  }

  /// Active ou désactive les notifications de nouvelles notes
  Future<void> setNotifyNewGrades(bool enabled) async {
    state = state.copyWith(notifyNewGrades: enabled);
    await _savePreferences();

    if (enabled) {
      // Demander les permissions de notification
      final notificationService = _ref.read(notificationServiceProvider);
      await notificationService.requestPermissions();
    }
  }

  /// Active ou désactive la synchronisation du calendrier
  Future<void> setSyncCalendar(bool enabled) async {
    state = state.copyWith(syncCalendar: enabled);
    await _savePreferences();
  }

  /// Lance une synchronisation manuelle immédiate
  Future<void> syncNow() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      // Synchroniser les notes si activé
      if (state.syncGrades) {
        await _syncGrades();
      }

      // Synchroniser le calendrier si activé
      if (state.syncCalendar) {
        try {
          await _ref.read(calendarSyncStateProvider.notifier).syncNow();
        } catch (e) {
          debugPrint('[BACKGROUND_SYNC_PROVIDER] Calendar sync error: $e');
        }
      }

      // Mettre à jour l'heure de dernière sync
      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefLastSync, now.toIso8601String());

      state = state.copyWith(
        isSyncing: false,
        lastSyncTime: now,
      );
    } catch (e) {
      debugPrint('[BACKGROUND_SYNC_PROVIDER] Sync error: $e');
      state = state.copyWith(
        isSyncing: false,
        errorMessage: 'Erreur lors de la synchronisation',
      );
    }
  }

  Future<void> _syncGrades() async {
    final gradesNotifier = _ref.read(gradesStateProvider.notifier);
    final gradesBefore = _ref.read(gradesStateProvider).grades;
    final beforeIds = gradesBefore.map((g) => g.id).toSet();

    // Récupérer les nouvelles notes
    await gradesNotifier.fetchGrades();

    final gradesAfter = _ref.read(gradesStateProvider).grades;

    // Détecter les nouvelles notes
    final newGrades = gradesAfter.where((g) => !beforeIds.contains(g.id)).toList();

    if (newGrades.isNotEmpty && state.notifyNewGrades) {
      debugPrint('[BACKGROUND_SYNC_PROVIDER] ${newGrades.length} new grades detected');

      // Envoyer une notification
      final notificationService = _ref.read(notificationServiceProvider);
      final firstSubject = newGrades.first.libelleMatiere;

      await notificationService.showNewGradesNotification(
        count: newGrades.length,
        subjectName: newGrades.length == 1 ? firstSubject : null,
      );
    }
  }

  /// Formate l'heure de dernière synchronisation
  String get lastSyncFormatted {
    if (state.lastSyncTime == null) return 'Jamais';

    final now = DateTime.now();
    final diff = now.difference(state.lastSyncTime!);

    if (diff.inMinutes < 1) {
      return 'À l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours} h';
    } else {
      return 'Il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
    }
  }
}

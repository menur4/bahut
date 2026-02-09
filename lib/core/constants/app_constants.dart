/// Constantes générales de l'application
class AppConstants {
  AppConstants._();

  /// Nom de l'application
  static const String appName = 'Calcul Moyenne';

  /// Clés pour le stockage sécurisé
  static const String secureStorageCredentials = 'ed_credentials';
  static const String secureStorageToken = 'ed_token';
  static const String secureStorageUserId = 'ed_user_id';
  static const String secureStorageSelectedChild = 'ed_selected_child';
  static const String secureStorageDeviceCn = 'ed_device_cn';
  static const String secureStorageDeviceCv = 'ed_device_cv';

  /// Clés pour shared preferences
  static const String prefBiometricEnabled = 'biometric_enabled';
  static const String prefGradesCache = 'grades_cache';
  static const String prefChildrenCache = 'children_cache';
  static const String prefLastSync = 'last_sync';
  static const String prefSeenGradeIds = 'seen_grade_ids';
  static const String prefNotificationsEnabled = 'notifications_enabled';

  /// Clés pour la synchronisation calendrier
  static const String prefCalendarSyncEnabled = 'calendar_sync_enabled';
  static const String prefCalendarSyncHomework = 'calendar_sync_homework';
  static const String prefCalendarSyncTests = 'calendar_sync_tests';
  static const String prefCalendarSyncSchedule = 'calendar_sync_schedule';
  static const String prefCalendarSelectedId = 'calendar_selected_id';
  static const String prefCalendarLastSync = 'calendar_last_sync';

  /// Clés pour la synchronisation en arrière-plan
  static const String prefBackgroundSyncEnabled = 'background_sync_enabled';
  static const String prefBackgroundSyncFrequency = 'background_sync_frequency';
  static const String prefPendingBackgroundSync = 'pending_background_sync';

  /// Clés pour la synchronisation des notes
  static const String prefGradesSyncEnabled = 'grades_sync_enabled';
  static const String prefGradesNotifyEnabled = 'grades_notify_enabled';
  static const String prefLastKnownGradeIds = 'last_known_grade_ids';

  /// Clé pour l'objectif de moyenne
  static const String prefAverageGoal = 'average_goal';

  /// Durée de validité du cache (en heures)
  static const int cacheValidityHours = 24;
}

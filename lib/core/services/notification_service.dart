import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../constants/app_constants.dart';

/// Provider pour le service de notifications
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Canaux de notification
class NotificationChannels {
  static const String newGrades = 'new_grades';
  static const String homeworkReminders = 'homework_reminders';
  static const String averageAlerts = 'average_alerts';
  static const String general = 'general';
}

/// IDs de notification réservés
class NotificationIds {
  static const int averageDropAlert = 1000;
  static const int weeklyReport = 1001;
  // Les rappels de devoirs utilisent l'ID du devoir
}

/// Service de gestion des notifications locales
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  static bool _timezoneInitialized = false;

  /// Initialise le service de notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialiser les timezones
    if (!_timezoneInitialized) {
      tz_data.initializeTimeZones();
      _timezoneInitialized = true;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Créer les canaux Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    _isInitialized = true;
  }

  /// Crée les canaux de notification Android
  Future<void> _createNotificationChannels() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.newGrades,
        'Nouvelles notes',
        description: 'Notifications pour les nouvelles notes',
        importance: Importance.high,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.homeworkReminders,
        'Rappels de devoirs',
        description: 'Rappels pour les devoirs à rendre',
        importance: Importance.high,
      ),
    );

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.averageAlerts,
        'Alertes de moyenne',
        description: 'Alertes quand la moyenne change significativement',
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// Callback quand une notification est tapée
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('[NOTIF] Notification tapped: ${response.payload}');
    // TODO: Naviguer vers l'écran approprié selon le payload
  }

  /// Demande les permissions de notification
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return result ?? false;
    }
    return false;
  }

  /// Vérifie si les notifications sont activées dans les préférences
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefNotificationsEnabled) ?? false;
  }

  /// Active ou désactive les notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefNotificationsEnabled, enabled);
  }

  /// Vérifie si les rappels de devoirs sont activés
  Future<bool> areHomeworkRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('homework_reminders_enabled') ?? true;
  }

  /// Active ou désactive les rappels de devoirs
  Future<void> setHomeworkRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('homework_reminders_enabled', enabled);
  }

  /// Vérifie si les alertes de moyenne sont activées
  Future<bool> areAverageAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('average_alerts_enabled') ?? true;
  }

  /// Active ou désactive les alertes de moyenne
  Future<void> setAverageAlertsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('average_alerts_enabled', enabled);
  }

  // =============================================
  // NOUVELLES NOTES
  // =============================================

  /// Affiche une notification pour les nouvelles notes
  Future<void> showNewGradesNotification({
    required int count,
    String? subjectName,
    List<String>? gradeDetails,
  }) async {
    if (!_isInitialized) await initialize();

    final isEnabled = await areNotificationsEnabled();
    if (!isEnabled) return;

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.newGrades,
      'Nouvelles notes',
      channelDescription: 'Notifications pour les nouvelles notes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: gradeDetails != null && gradeDetails.length > 1
          ? InboxStyleInformation(
              gradeDetails,
              summaryText: '$count nouvelles notes',
            )
          : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = count == 1 ? 'Nouvelle note 📝' : '$count nouvelles notes 📝';
    final body = subjectName != null
        ? 'Nouvelle note en $subjectName'
        : count == 1
            ? 'Une nouvelle note a été ajoutée'
            : '$count nouvelles notes ont été ajoutées';

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'grades',
    );
  }

  // =============================================
  // RAPPELS DE DEVOIRS
  // =============================================

  /// Programme un rappel pour un devoir
  Future<void> scheduleHomeworkReminder({
    required int homeworkId,
    required String subject,
    required String description,
    required DateTime dueDate,
    Duration reminderBefore = const Duration(days: 1),
  }) async {
    if (!_isInitialized) await initialize();

    final isEnabled = await areNotificationsEnabled();
    final remindersEnabled = await areHomeworkRemindersEnabled();
    if (!isEnabled || !remindersEnabled) return;

    final reminderTime = dueDate.subtract(reminderBefore);

    // Ne pas programmer si la date est déjà passée
    if (reminderTime.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.homeworkReminders,
      'Rappels de devoirs',
      channelDescription: 'Rappels pour les devoirs à rendre',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = '📚 Devoir à rendre demain';
    final body = '$subject: ${_truncate(description, 100)}';

    await _notifications.zonedSchedule(
      homeworkId,
      title,
      body,
      tz.TZDateTime.from(reminderTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'homework:$homeworkId',
    );

    debugPrint('[NOTIF] Rappel programmé pour le devoir $homeworkId à $reminderTime');
  }

  /// Programme un rappel pour un contrôle
  Future<void> scheduleTestReminder({
    required int testId,
    required String subject,
    required String description,
    required DateTime testDate,
  }) async {
    if (!_isInitialized) await initialize();

    final isEnabled = await areNotificationsEnabled();
    final remindersEnabled = await areHomeworkRemindersEnabled();
    if (!isEnabled || !remindersEnabled) return;

    // Rappel 2 jours avant pour les contrôles
    final reminderTime = testDate.subtract(const Duration(days: 2));

    if (reminderTime.isBefore(DateTime.now())) return;

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.homeworkReminders,
      'Rappels de devoirs',
      channelDescription: 'Rappels pour les devoirs à rendre',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFFFF9800), // Orange pour les contrôles
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = '⚠️ Contrôle dans 2 jours';
    final body = '$subject: ${_truncate(description, 100)}';

    await _notifications.zonedSchedule(
      testId + 100000, // Offset pour différencier des devoirs
      title,
      body,
      tz.TZDateTime.from(reminderTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'test:$testId',
    );
  }

  /// Annule un rappel de devoir
  Future<void> cancelHomeworkReminder(int homeworkId) async {
    await _notifications.cancel(homeworkId);
    debugPrint('[NOTIF] Rappel annulé pour le devoir $homeworkId');
  }

  /// Annule tous les rappels de devoirs
  Future<void> cancelAllHomeworkReminders() async {
    // On ne peut pas annuler uniquement par canal, donc on garde une liste
    // Pour l'instant, on annule tout
    debugPrint('[NOTIF] Annulation de tous les rappels non implémentée');
  }

  // =============================================
  // ALERTES DE MOYENNE
  // =============================================

  /// Affiche une alerte si la moyenne a baissé
  Future<void> showAverageDropAlert({
    required double previousAverage,
    required double currentAverage,
    String? subject,
  }) async {
    if (!_isInitialized) await initialize();

    final isEnabled = await areNotificationsEnabled();
    final alertsEnabled = await areAverageAlertsEnabled();
    if (!isEnabled || !alertsEnabled) return;

    final drop = previousAverage - currentAverage;
    if (drop < 0.5) return; // Seuil minimum de 0.5 point

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.averageAlerts,
      'Alertes de moyenne',
      channelDescription: 'Alertes quand la moyenne change significativement',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = subject != null
        ? '📉 Moyenne en baisse en $subject'
        : '📉 Moyenne générale en baisse';
    final body =
        '${previousAverage.toStringAsFixed(2)} → ${currentAverage.toStringAsFixed(2)} (-${drop.toStringAsFixed(2)})';

    await _notifications.show(
      NotificationIds.averageDropAlert,
      title,
      body,
      details,
      payload: 'average_drop',
    );
  }

  /// Affiche une notification de félicitations pour une bonne note
  Future<void> showGoodGradeNotification({
    required String subject,
    required double grade,
    required double maxGrade,
  }) async {
    if (!_isInitialized) await initialize();

    final isEnabled = await areNotificationsEnabled();
    if (!isEnabled) return;

    // Seuil pour une "bonne" note (>= 16/20)
    final normalizedGrade = (grade / maxGrade) * 20;
    if (normalizedGrade < 16) return;

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.newGrades,
      'Nouvelles notes',
      channelDescription: 'Notifications pour les nouvelles notes',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String emoji;
    if (normalizedGrade >= 19) {
      emoji = '🏆';
    } else if (normalizedGrade >= 17) {
      emoji = '🌟';
    } else {
      emoji = '👏';
    }

    final title = '$emoji Excellente note !';
    final body = '${grade.toStringAsFixed(1)}/${maxGrade.toStringAsFixed(0)} en $subject';

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'good_grade',
    );
  }

  // =============================================
  // UTILITAIRES
  // =============================================

  /// Tronque un texte à une longueur maximale
  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Annule toutes les notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Obtient les notifications en attente
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }
}

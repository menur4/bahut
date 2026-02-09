import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/api_constants.dart';
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
/// Cette fonction s'exécute en isolation, sans accès aux providers Riverpod.
/// Elle effectue directement l'appel API et envoie les notifications.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('[BACKGROUND_SYNC] Task started: $task');

    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled =
          prefs.getBool(AppConstants.prefBackgroundSyncEnabled) ?? false;

      if (!isEnabled) {
        debugPrint('[BACKGROUND_SYNC] Sync disabled, skipping');
        return true;
      }

      final gradesSyncEnabled =
          prefs.getBool(AppConstants.prefGradesSyncEnabled) ?? true;

      if (gradesSyncEnabled) {
        await _checkNewGradesInBackground(prefs);
      }

      return true;
    } catch (e) {
      debugPrint('[BACKGROUND_SYNC] Error: $e');
      return false;
    }
  });
}

/// Vérifie les nouvelles notes directement depuis la tâche en arrière-plan
Future<void> _checkNewGradesInBackground(SharedPreferences prefs) async {
  const secureStorage = FlutterSecureStorage();

  // Récupérer le token et l'ID de l'enfant depuis le stockage sécurisé
  final token =
      await secureStorage.read(key: AppConstants.secureStorageToken);
  final childIdStr =
      await secureStorage.read(key: AppConstants.secureStorageSelectedChild);

  if (token == null || token.isEmpty) {
    debugPrint('[BACKGROUND_SYNC] No token, skipping');
    return;
  }

  if (childIdStr == null || childIdStr.isEmpty) {
    debugPrint('[BACKGROUND_SYNC] No child ID, skipping');
    return;
  }

  final childId = int.tryParse(childIdStr);
  if (childId == null) {
    debugPrint('[BACKGROUND_SYNC] Invalid child ID: $childIdStr');
    return;
  }

  debugPrint('[BACKGROUND_SYNC] Fetching grades for child $childId');

  // Appel API direct sans passer par ApiClient (pas de Riverpod en background)
  final httpClient = HttpClient();
  try {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.gradesEndpoint(childId)}?verbe=get&v=${ApiConstants.apiVersionNumber}');

    final request = await httpClient.postUrl(uri);
    request.headers.set('User-Agent', ApiConstants.userAgent);
    request.headers.set('Accept', 'application/json, text/plain, */*');
    request.headers.set('Origin', 'https://www.ecoledirecte.com');
    request.headers.set('Referer', 'https://www.ecoledirecte.com/');
    request.headers.set('X-Token', token);
    request.headers
        .set('Content-Type', 'application/x-www-form-urlencoded');

    final body = 'data=${jsonEncode({})}';
    request.write(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    debugPrint('[BACKGROUND_SYNC] API response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      debugPrint('[BACKGROUND_SYNC] API error: ${response.statusCode}');
      return;
    }

    final responseData = jsonDecode(responseBody) as Map<String, dynamic>;
    final code = responseData['code'] as int?;

    if (code != 200) {
      debugPrint('[BACKGROUND_SYNC] API returned code: $code');
      // Token expiré, on ne peut rien faire en background
      return;
    }

    // Sauvegarder le nouveau token si présent
    final newToken = response.headers.value('x-token');
    if (newToken != null && newToken.isNotEmpty) {
      await secureStorage.write(
          key: AppConstants.secureStorageToken, value: newToken);
      debugPrint('[BACKGROUND_SYNC] Token updated');
    }

    // Parser les notes
    final data = responseData['data'] as Map<String, dynamic>?;
    if (data == null) return;

    final notesList = data['notes'] as List? ?? [];
    final currentIds = <int>{};
    final gradesBySubject = <String, List<String>>{};

    for (final note in notesList) {
      final noteMap = note as Map<String, dynamic>;
      final id = noteMap['id'] as int?;
      if (id != null) {
        currentIds.add(id);
      }
    }

    debugPrint(
        '[BACKGROUND_SYNC] Fetched ${currentIds.length} grades');

    // Comparer avec les IDs déjà vus
    final seenIdsJson = prefs.getString(AppConstants.prefSeenGradeIds);
    final seenIds = seenIdsJson != null
        ? Set<int>.from(
            (jsonDecode(seenIdsJson) as List).map((e) => e as int))
        : <int>{};

    final newIds = currentIds.difference(seenIds);

    debugPrint(
        '[BACKGROUND_SYNC] Seen: ${seenIds.length}, New: ${newIds.length}');

    if (newIds.isEmpty) {
      // Mettre à jour les IDs vus même s'il n'y a pas de nouvelles notes
      await prefs.setString(
        AppConstants.prefSeenGradeIds,
        jsonEncode(currentIds.toList()),
      );
      return;
    }

    // Collecter les détails des nouvelles notes
    for (final note in notesList) {
      final noteMap = note as Map<String, dynamic>;
      final id = noteMap['id'] as int?;
      if (id != null && newIds.contains(id)) {
        final subject = noteMap['libelleMatiere'] as String? ?? '';
        final valeur = noteMap['valeur'] as String? ?? '';
        final noteSur = noteMap['noteSur'] as String? ?? '20';
        gradesBySubject
            .putIfAbsent(subject, () => [])
            .add('$valeur/$noteSur');
      }
    }

    // Sauvegarder les IDs comme vus
    await prefs.setString(
      AppConstants.prefSeenGradeIds,
      jsonEncode(currentIds.toList()),
    );

    // Vérifier si les notifications sont activées
    final notifyEnabled =
        prefs.getBool(AppConstants.prefGradesNotifyEnabled) ?? true;
    final notificationsEnabled =
        prefs.getBool(AppConstants.prefNotificationsEnabled) ?? false;

    if (!notifyEnabled || !notificationsEnabled) {
      debugPrint(
          '[BACKGROUND_SYNC] Notifications disabled, skipping notification');
      return;
    }

    // Envoyer la notification
    await _showBackgroundNotification(newIds.length, gradesBySubject);

    debugPrint(
        '[BACKGROUND_SYNC] Notification sent for ${newIds.length} new grades');
  } finally {
    httpClient.close();
  }
}

/// Affiche une notification depuis la tâche en arrière-plan
Future<void> _showBackgroundNotification(
  int count,
  Map<String, List<String>> gradesBySubject,
) async {
  final notifications = FlutterLocalNotificationsPlugin();

  const androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  await notifications.initialize(initSettings);

  // Construire le détail des notes
  final details = <String>[];
  for (final entry in gradesBySubject.entries) {
    for (final grade in entry.value) {
      details.add('${entry.key}: $grade');
    }
  }

  final androidDetails = AndroidNotificationDetails(
    'new_grades',
    'Nouvelles notes',
    channelDescription: 'Notifications pour les nouvelles notes',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    styleInformation: details.length > 1
        ? InboxStyleInformation(
            details,
            summaryText: '$count nouvelles notes',
          )
        : null,
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final notifDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  final title = count == 1 ? 'Nouvelle note' : '$count nouvelles notes';
  String body;
  if (count == 1 && gradesBySubject.isNotEmpty) {
    final subject = gradesBySubject.keys.first;
    final grade = gradesBySubject.values.first.first;
    body = '$subject: $grade';
  } else {
    body = details.take(3).join(', ');
    if (details.length > 3) {
      body += '...';
    }
  }

  await notifications.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    notifDetails,
    payload: 'grades',
  );
}

/// Service pour gérer la synchronisation en arrière-plan
class BackgroundSyncService {
  static final BackgroundSyncService _instance =
      BackgroundSyncService._internal();
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

    debugPrint(
        '[BACKGROUND_SYNC] Scheduled periodic sync: ${frequency.label}');
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
    final pending =
        prefs.getBool(AppConstants.prefPendingBackgroundSync) ?? false;
    if (pending) {
      await prefs.setBool(AppConstants.prefPendingBackgroundSync, false);
    }
    return pending;
  }
}

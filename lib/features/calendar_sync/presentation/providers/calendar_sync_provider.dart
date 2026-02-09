import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/background_sync_service.dart';
import '../../../../core/services/calendar_service.dart';
import '../../../homework/presentation/providers/homework_provider.dart';
import '../../../schedule/presentation/providers/schedule_provider.dart';

/// État de la synchronisation calendrier
class CalendarSyncState {
  final bool isEnabled;
  final bool syncHomework;
  final bool syncTests;
  final bool syncSchedule;
  final String? selectedCalendarId;
  final String? selectedCalendarName;
  final DateTime? lastSyncTime;
  final bool isSyncing;
  final bool isLoadingCalendars;
  final String? errorMessage;
  final List<Calendar> availableCalendars;
  final bool hasPermission;
  final bool backgroundSyncEnabled;
  final SyncFrequency syncFrequency;

  const CalendarSyncState({
    this.isEnabled = false,
    this.syncHomework = true,
    this.syncTests = true,
    this.syncSchedule = false,
    this.selectedCalendarId,
    this.selectedCalendarName,
    this.lastSyncTime,
    this.isSyncing = false,
    this.isLoadingCalendars = false,
    this.errorMessage,
    this.availableCalendars = const [],
    this.hasPermission = false,
    this.backgroundSyncEnabled = false,
    this.syncFrequency = SyncFrequency.daily,
  });

  CalendarSyncState copyWith({
    bool? isEnabled,
    bool? syncHomework,
    bool? syncTests,
    bool? syncSchedule,
    String? selectedCalendarId,
    String? selectedCalendarName,
    DateTime? lastSyncTime,
    bool? isSyncing,
    bool? isLoadingCalendars,
    String? errorMessage,
    List<Calendar>? availableCalendars,
    bool? hasPermission,
    bool? backgroundSyncEnabled,
    SyncFrequency? syncFrequency,
  }) {
    return CalendarSyncState(
      isEnabled: isEnabled ?? this.isEnabled,
      syncHomework: syncHomework ?? this.syncHomework,
      syncTests: syncTests ?? this.syncTests,
      syncSchedule: syncSchedule ?? this.syncSchedule,
      selectedCalendarId: selectedCalendarId ?? this.selectedCalendarId,
      selectedCalendarName: selectedCalendarName ?? this.selectedCalendarName,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isSyncing: isSyncing ?? this.isSyncing,
      isLoadingCalendars: isLoadingCalendars ?? this.isLoadingCalendars,
      errorMessage: errorMessage,
      availableCalendars: availableCalendars ?? this.availableCalendars,
      hasPermission: hasPermission ?? this.hasPermission,
      backgroundSyncEnabled: backgroundSyncEnabled ?? this.backgroundSyncEnabled,
      syncFrequency: syncFrequency ?? this.syncFrequency,
    );
  }

  /// Formatage de la dernière synchronisation
  String get lastSyncFormatted {
    if (lastSyncTime == null) return 'Jamais';

    final now = DateTime.now();
    final diff = now.difference(lastSyncTime!);

    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return 'Il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
  }
}

/// Provider pour l'état de synchronisation calendrier
final calendarSyncStateProvider =
    StateNotifierProvider<CalendarSyncNotifier, CalendarSyncState>((ref) {
  return CalendarSyncNotifier(ref);
});

/// Notifier pour gérer la synchronisation calendrier
class CalendarSyncNotifier extends StateNotifier<CalendarSyncState> {
  final Ref _ref;

  CalendarSyncNotifier(this._ref) : super(const CalendarSyncState()) {
    _initTimezone();
    _loadPreferences();
  }

  /// Initialise le timezone
  void _initTimezone() {
    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    } catch (e) {
      debugPrint('[CALENDAR_SYNC] Timezone already initialized');
    }
  }

  /// Charge les préférences sauvegardées
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isEnabled = prefs.getBool(AppConstants.prefCalendarSyncEnabled) ?? false;
      final syncHomework = prefs.getBool(AppConstants.prefCalendarSyncHomework) ?? true;
      final syncTests = prefs.getBool(AppConstants.prefCalendarSyncTests) ?? true;
      final syncSchedule = prefs.getBool(AppConstants.prefCalendarSyncSchedule) ?? false;
      final selectedCalendarId = prefs.getString(AppConstants.prefCalendarSelectedId);
      final lastSyncMs = prefs.getInt(AppConstants.prefCalendarLastSync);
      final lastSync = lastSyncMs != null
          ? DateTime.fromMillisecondsSinceEpoch(lastSyncMs)
          : null;

      // Préférences de sync en arrière-plan
      final backgroundSyncEnabled = prefs.getBool(AppConstants.prefBackgroundSyncEnabled) ?? false;
      final syncFrequencyStr = prefs.getString(AppConstants.prefBackgroundSyncFrequency);
      final syncFrequency = SyncFrequency.fromString(syncFrequencyStr);

      state = state.copyWith(
        isEnabled: isEnabled,
        syncHomework: syncHomework,
        syncTests: syncTests,
        syncSchedule: syncSchedule,
        selectedCalendarId: selectedCalendarId,
        lastSyncTime: lastSync,
        backgroundSyncEnabled: backgroundSyncEnabled,
        syncFrequency: syncFrequency,
      );

      // Charger les calendriers disponibles si activé
      if (isEnabled) {
        await _loadCalendars();
      }

      // Vérifier s'il y a une sync en attente (déclenchée en background)
      final pendingSync = prefs.getBool(AppConstants.prefPendingBackgroundSync) ?? false;
      if (pendingSync && isEnabled) {
        await prefs.setBool(AppConstants.prefPendingBackgroundSync, false);
        // Lancer la sync
        syncNow();
      }
    } catch (e) {
      debugPrint('[CALENDAR_SYNC] Error loading preferences: $e');
    }
  }

  /// Charge les calendriers disponibles
  Future<void> _loadCalendars() async {
    debugPrint('[CALENDAR_SYNC] _loadCalendars called');
    final calendarService = _ref.read(calendarServiceProvider);

    final hasPerms = await calendarService.hasPermissions();
    debugPrint('[CALENDAR_SYNC] hasPermissions: $hasPerms');
    if (!hasPerms) {
      state = state.copyWith(hasPermission: false, availableCalendars: []);
      return;
    }

    final calendars = await calendarService.getAvailableCalendars();
    debugPrint('[CALENDAR_SYNC] Got ${calendars.length} calendars');

    // Trouver le nom du calendrier sélectionné
    String? selectedName;
    if (state.selectedCalendarId != null) {
      final selected = calendars.where((c) => c.id == state.selectedCalendarId);
      if (selected.isNotEmpty) {
        selectedName = selected.first.name;
      }
    }

    state = state.copyWith(
      hasPermission: true,
      availableCalendars: calendars,
      selectedCalendarName: selectedName,
    );
    debugPrint('[CALENDAR_SYNC] State updated with ${state.availableCalendars.length} calendars');
  }

  /// Active ou désactive la synchronisation
  Future<void> toggleSync(bool enabled) async {
    debugPrint('[CALENDAR_SYNC] toggleSync called with enabled=$enabled');

    if (enabled) {
      // Afficher le loader
      state = state.copyWith(isLoadingCalendars: true, errorMessage: null);

      // Demander les permissions
      final calendarService = _ref.read(calendarServiceProvider);
      final hasPerms = await calendarService.requestPermissions();
      debugPrint('[CALENDAR_SYNC] requestPermissions returned: $hasPerms');

      if (!hasPerms) {
        // Sur Android 13+, parfois la permission est accordée mais pas encore détectée
        // Attendre un peu et réessayer plusieurs fois
        bool permGranted = false;
        for (int i = 0; i < 5; i++) {
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
          final hasPermsRetry = await calendarService.hasPermissions();
          debugPrint('[CALENDAR_SYNC] hasPermissions retry $i: $hasPermsRetry');
          if (hasPermsRetry) {
            permGranted = true;
            break;
          }
        }

        if (!permGranted) {
          state = state.copyWith(
            isLoadingCalendars: false,
            errorMessage: "Permission d'accès au calendrier refusée",
            hasPermission: false,
          );
          debugPrint('[CALENDAR_SYNC] Permission denied, returning');
          return;
        }
      }

      // Mettre à jour hasPermission immédiatement
      state = state.copyWith(hasPermission: true);

      // Attendre que le système soit prêt après l'acceptation des permissions
      // C'est crucial sur Android où les calendriers ne sont pas immédiatement disponibles
      debugPrint('[CALENDAR_SYNC] Waiting for system to be ready...');
      await Future.delayed(const Duration(milliseconds: 1500));

      // Charger les calendriers avec plusieurs tentatives
      List<Calendar> calendars = [];
      for (int attempt = 0; attempt < 5; attempt++) {
        debugPrint('[CALENDAR_SYNC] Loading calendars, attempt ${attempt + 1}');
        calendars = await calendarService.getAvailableCalendarsForced();
        debugPrint('[CALENDAR_SYNC] Got ${calendars.length} calendars');

        if (calendars.isNotEmpty) {
          break;
        }

        // Attendre avant de réessayer (délai croissant)
        await Future.delayed(Duration(milliseconds: 800 * (attempt + 1)));
      }

      // Masquer le loader
      state = state.copyWith(isLoadingCalendars: false, availableCalendars: calendars);

      // Sélectionner automatiquement le premier calendrier valide si aucun n'est sélectionné
      if (state.selectedCalendarId == null && calendars.isNotEmpty) {
        // Trouver le premier calendrier avec un id valide
        final validCalendar = calendars
            .where((c) => c.id != null && c.id!.isNotEmpty)
            .firstOrNull;

        if (validCalendar != null) {
          await selectCalendar(validCalendar.id!, validCalendar.name);
          debugPrint('[CALENDAR_SYNC] Auto-selected calendar: ${validCalendar.name}');
        } else {
          debugPrint('[CALENDAR_SYNC] No valid calendar found (all have null ids)');
          state = state.copyWith(
            errorMessage: 'Aucun calendrier valide trouvé. Vérifiez que vous avez un compte calendrier configuré.',
          );
          return;
        }
      }

      if (calendars.isEmpty) {
        state = state.copyWith(
          isEnabled: false,
          errorMessage: 'Aucun calendrier trouvé. Vérifiez que vous avez un compte calendrier (Google, Samsung, etc.) configuré sur votre téléphone.',
        );
        await _savePreference(AppConstants.prefCalendarSyncEnabled, false);
        return;
      }
    }

    state = state.copyWith(isEnabled: enabled, errorMessage: null);
    await _savePreference(AppConstants.prefCalendarSyncEnabled, enabled);
    debugPrint('[CALENDAR_SYNC] Sync ${enabled ? 'enabled' : 'disabled'}, state.isEnabled=${state.isEnabled}');
  }

  /// Toggle synchronisation des devoirs
  Future<void> toggleHomework(bool value) async {
    state = state.copyWith(syncHomework: value);
    await _savePreference(AppConstants.prefCalendarSyncHomework, value);
  }

  /// Toggle synchronisation des contrôles
  Future<void> toggleTests(bool value) async {
    state = state.copyWith(syncTests: value);
    await _savePreference(AppConstants.prefCalendarSyncTests, value);
  }

  /// Toggle synchronisation de l'emploi du temps
  Future<void> toggleSchedule(bool value) async {
    state = state.copyWith(syncSchedule: value);
    await _savePreference(AppConstants.prefCalendarSyncSchedule, value);
  }

  /// Sélectionne un calendrier
  Future<void> selectCalendar(String calendarId, String? name) async {
    state = state.copyWith(
      selectedCalendarId: calendarId,
      selectedCalendarName: name,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefCalendarSelectedId, calendarId);
  }

  /// Sauvegarde une préférence booléenne
  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// Lance la synchronisation
  Future<void> syncNow() async {
    if (!state.isEnabled) return;
    if (state.isSyncing) return;
    if (state.selectedCalendarId == null) {
      state = state.copyWith(errorMessage: 'Aucun calendrier sélectionné');
      return;
    }

    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      final calendarService = _ref.read(calendarServiceProvider);
      final calendarId = state.selectedCalendarId!;

      // Période de sync: 7 jours passés → 60 jours futurs
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 7));
      final endDate = now.add(const Duration(days: 60));

      // Récupérer les événements existants pour éviter les doublons
      final existingEvents = await calendarService.getExistingEventTitles(
        calendarId: calendarId,
        start: startDate,
        end: endDate,
      );

      int addedCount = 0;

      // Synchroniser les devoirs et contrôles
      if (state.syncHomework || state.syncTests) {
        // Charger l'emploi du temps sur une période étendue pour trouver les horaires des contrôles
        debugPrint('[CALENDAR_SYNC] Fetching extended schedule for test times...');
        await _ref.read(scheduleStateProvider.notifier).fetchSchedule(
          startDate: now,
          endDate: endDate,
          forceRefresh: true,
        );

        addedCount += await _syncHomework(
          calendarService,
          calendarId,
          existingEvents,
        );
      }

      // Synchroniser l'emploi du temps
      if (state.syncSchedule) {
        addedCount += await _syncSchedule(
          calendarService,
          calendarId,
          existingEvents,
        );
      }

      // Sauvegarder le timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        AppConstants.prefCalendarLastSync,
        DateTime.now().millisecondsSinceEpoch,
      );

      state = state.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
        errorMessage: null,
      );

      debugPrint('[CALENDAR_SYNC] Sync completed: $addedCount events added');
    } catch (e) {
      debugPrint('[CALENDAR_SYNC] Sync error: $e');
      state = state.copyWith(
        isSyncing: false,
        errorMessage: 'Erreur lors de la synchronisation',
      );
    }
  }

  /// Synchronise les devoirs et contrôles
  Future<int> _syncHomework(
    CalendarService calendarService,
    String calendarId,
    Set<String> existingEvents,
  ) async {
    final homeworkState = _ref.read(homeworkStateProvider);
    final homeworks = homeworkState.data?.homeworks ?? [];
    final scheduleState = _ref.read(scheduleStateProvider);
    final courses = scheduleState.data?.courses ?? [];

    debugPrint('[CALENDAR_SYNC] Syncing ${homeworks.length} homework items');
    debugPrint('[CALENDAR_SYNC] Schedule has ${courses.length} courses loaded');
    if (courses.isNotEmpty) {
      final firstDate = courses.first.startDateTime;
      final lastDate = courses.last.startDateTime;
      debugPrint('[CALENDAR_SYNC] Schedule range: $firstDate to $lastDate');
    }

    int addedCount = 0;

    for (final homework in homeworks) {
      if (homework.dueDate == null) continue;

      final isTest = homework.isInterrogation;

      // Vérifier si on doit sync ce type
      if (isTest && !state.syncTests) continue;
      if (!isTest && !state.syncHomework) continue;

      final title = isTest
          ? '[Contrôle] ${homework.matiere ?? 'Évaluation'}'
          : '[Devoir] ${homework.matiere ?? 'Devoir'}';

      // Chercher l'heure du cours correspondant dans l'emploi du temps
      DateTime startTime = homework.dueDate!;
      DateTime? endTime;

      // Trouver le cours de cette matière ce jour-là
      final matchingCourse = courses.where((course) {
        if (course.startDateTime == null) return false;
        // Même jour
        if (course.startDateTime!.year != homework.dueDate!.year ||
            course.startDateTime!.month != homework.dueDate!.month ||
            course.startDateTime!.day != homework.dueDate!.day) {
          return false;
        }
        // Même matière (comparer le code ou le nom, avec normalisation)
        final courseCode = (course.codeMatiere ?? '').toLowerCase().trim();
        final courseName = (course.matiere ?? '').toLowerCase().trim();
        final homeworkCode = (homework.codeMatiere ?? '').toLowerCase().trim();
        final homeworkName = (homework.matiere ?? '').toLowerCase().trim();

        // Correspondance par code matière
        if (courseCode.isNotEmpty && homeworkCode.isNotEmpty && courseCode == homeworkCode) {
          return true;
        }
        // Correspondance par nom exact
        if (courseName.isNotEmpty && homeworkName.isNotEmpty && courseName == homeworkName) {
          return true;
        }
        // Correspondance partielle (le nom du cours contient le nom du devoir ou vice versa)
        if (courseName.isNotEmpty && homeworkName.isNotEmpty) {
          if (courseName.contains(homeworkName) || homeworkName.contains(courseName)) {
            return true;
          }
        }
        return false;
      }).firstOrNull;

      if (matchingCourse != null && matchingCourse.startDateTime != null) {
        // Utiliser l'heure exacte du cours
        startTime = matchingCourse.startDateTime!;
        endTime = matchingCourse.endDateTime;
        debugPrint('[CALENDAR_SYNC] ✓ Found course for "${homework.matiere}" on ${homework.dueDate}: ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime?.hour}:${endTime?.minute.toString().padLeft(2, '0')}');
      } else {
        // Pas de cours trouvé, mettre à 8h00 par défaut (durée 1h)
        startTime = DateTime(
          homework.dueDate!.year,
          homework.dueDate!.month,
          homework.dueDate!.day,
          8, 0,
        );
        endTime = startTime.add(const Duration(hours: 1));

        // Debug: lister les cours disponibles ce jour-là
        final coursesOnDay = courses.where((c) =>
          c.startDateTime != null &&
          c.startDateTime!.year == homework.dueDate!.year &&
          c.startDateTime!.month == homework.dueDate!.month &&
          c.startDateTime!.day == homework.dueDate!.day
        ).toList();

        if (coursesOnDay.isEmpty) {
          debugPrint('[CALENDAR_SYNC] ✗ No courses loaded for ${homework.dueDate} (matière: ${homework.matiere}, code: ${homework.codeMatiere})');
        } else {
          debugPrint('[CALENDAR_SYNC] ✗ No match for "${homework.matiere}" (code: ${homework.codeMatiere}). Courses on ${homework.dueDate}:');
          for (final c in coursesOnDay) {
            debugPrint('   - ${c.matiere} (code: ${c.codeMatiere}) at ${c.startDateTime?.hour}:${c.startDateTime?.minute.toString().padLeft(2, '0')}');
          }
        }
      }

      final eventKey = '${title}_${startTime.toIso8601String()}';
      if (existingEvents.contains(eventKey)) {
        continue; // Éviter les doublons
      }

      final description = homework.contenu.isNotEmpty
          ? homework.contenu
          : null;

      final success = await calendarService.addEvent(
        calendarId: calendarId,
        title: title,
        start: startTime,
        end: endTime,
        allDay: false, // Événement avec heure précise
        description: description,
        // Pas de rappel pour ne pas encombrer les notifications
      );

      if (success) addedCount++;
    }

    return addedCount;
  }

  /// Synchronise l'emploi du temps
  Future<int> _syncSchedule(
    CalendarService calendarService,
    String calendarId,
    Set<String> existingEvents,
  ) async {
    final scheduleState = _ref.read(scheduleStateProvider);
    final courses = scheduleState.data?.courses ?? [];

    int addedCount = 0;

    for (final course in courses) {
      if (course.startDateTime == null || course.endDateTime == null) continue;
      if (course.isAnnule) continue; // Ne pas ajouter les cours annulés

      final title = course.displayMatiere;
      final eventKey = '${title}_${course.startDateTime!.toIso8601String()}';

      if (existingEvents.contains(eventKey)) {
        continue; // Éviter les doublons
      }

      final description = course.displayProf.isNotEmpty
          ? 'Prof: ${course.displayProf}'
          : null;

      final success = await calendarService.addEvent(
        calendarId: calendarId,
        title: title,
        start: course.startDateTime!,
        end: course.endDateTime,
        location: course.salle,
        description: description,
        allDay: false,
      );

      if (success) addedCount++;
    }

    return addedCount;
  }

  /// Rafraîchit la liste des calendriers
  Future<void> refreshCalendars() async {
    await _loadCalendars();
  }

  /// Active ou désactive la synchronisation en arrière-plan
  Future<void> toggleBackgroundSync(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefBackgroundSyncEnabled, enabled);

    state = state.copyWith(backgroundSyncEnabled: enabled);

    final backgroundService = BackgroundSyncService();

    if (enabled) {
      // Planifier la sync périodique
      await backgroundService.schedulePeriodicSync(state.syncFrequency);
    } else {
      // Annuler la sync
      await backgroundService.cancelSync();
    }

    debugPrint('[CALENDAR_SYNC] Background sync ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Définit la fréquence de synchronisation
  Future<void> setSyncFrequency(SyncFrequency frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefBackgroundSyncFrequency, frequency.name);

    state = state.copyWith(syncFrequency: frequency);

    // Reprogrammer la sync si elle est activée
    if (state.backgroundSyncEnabled) {
      final backgroundService = BackgroundSyncService();
      await backgroundService.schedulePeriodicSync(frequency);
    }

    debugPrint('[CALENDAR_SYNC] Sync frequency set to: ${frequency.label}');
  }
}

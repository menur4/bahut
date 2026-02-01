import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

/// Provider pour le service calendrier
final calendarServiceProvider = Provider<CalendarService>((ref) {
  return CalendarService();
});

/// Service pour accéder au calendrier natif du téléphone
class CalendarService {
  final DeviceCalendarPlugin _calendarPlugin = DeviceCalendarPlugin();

  static const String _bahutCalendarName = 'Bahut';

  /// Demande les permissions d'accès au calendrier
  Future<bool> requestPermissions() async {
    try {
      debugPrint('[CALENDAR] Checking existing permissions...');
      var permissionsGranted = await _calendarPlugin.hasPermissions();
      debugPrint('[CALENDAR] hasPermissions: isSuccess=${permissionsGranted.isSuccess}, data=${permissionsGranted.data}');

      if (permissionsGranted.isSuccess && permissionsGranted.data == true) {
        debugPrint('[CALENDAR] Permissions already granted');
        return true;
      }

      debugPrint('[CALENDAR] Requesting permissions...');
      permissionsGranted = await _calendarPlugin.requestPermissions();
      debugPrint('[CALENDAR] requestPermissions: isSuccess=${permissionsGranted.isSuccess}, data=${permissionsGranted.data}');

      final result = permissionsGranted.isSuccess && permissionsGranted.data == true;
      debugPrint('[CALENDAR] Final permission result: $result');
      return result;
    } catch (e, stack) {
      debugPrint('[CALENDAR] Error requesting permissions: $e');
      debugPrint('[CALENDAR] Stack: $stack');
      return false;
    }
  }

  /// Vérifie si les permissions sont accordées
  Future<bool> hasPermissions() async {
    try {
      final result = await _calendarPlugin.hasPermissions();
      return result.isSuccess && result.data == true;
    } catch (e) {
      return false;
    }
  }

  /// Récupère la liste des calendriers disponibles
  /// Avec retry pour contourner le bug Android 16 où les calendriers sont null
  Future<List<Calendar>> getAvailableCalendars() async {
    try {
      final hasPerms = await hasPermissions();
      debugPrint('[CALENDAR] hasPermissions: $hasPerms');
      if (!hasPerms) {
        return [];
      }

      // Essayer plusieurs fois avec délai (bug Android 16)
      List<Calendar> writableCalendars = [];
      for (int attempt = 0; attempt < 5; attempt++) {
        if (attempt > 0) {
          debugPrint('[CALENDAR] Retry attempt $attempt after delay...');
          await Future.delayed(Duration(milliseconds: 300 * attempt));
        }

        final result = await _calendarPlugin.retrieveCalendars();
        debugPrint('[CALENDAR] retrieveCalendars isSuccess: ${result.isSuccess}');
        debugPrint('[CALENDAR] retrieveCalendars data: ${result.data?.length ?? 0} calendars');

        if (result.isSuccess && result.data != null) {
          // Log tous les calendriers trouvés
          for (final cal in result.data!) {
            debugPrint('[CALENDAR] Found: ${cal.name} (id: ${cal.id}, isReadOnly: ${cal.isReadOnly})');
          }

          // Filtrer les calendriers:
          // 1. Doit avoir un id non null (requis pour fonctionner)
          // 2. Doit être en écriture (isReadOnly != true)
          writableCalendars = result.data!
              .where((cal) => cal.id != null && cal.id!.isNotEmpty && cal.isReadOnly != true)
              .toList();

          debugPrint('[CALENDAR] Writable calendars with valid id: ${writableCalendars.length}');

          // Si on a trouvé des calendriers valides, arrêter les retries
          if (writableCalendars.isNotEmpty) {
            break;
          }
        }
      }

      return writableCalendars;
    } catch (e) {
      debugPrint('[CALENDAR] Error getting calendars: $e');
      return [];
    }
  }

  /// Trouve ou crée le calendrier Bahut
  Future<String?> getOrCreateBahutCalendar() async {
    try {
      final calendars = await getAvailableCalendars();

      // Chercher un calendrier existant nommé Bahut
      for (final calendar in calendars) {
        if (calendar.name == _bahutCalendarName) {
          debugPrint('[CALENDAR] Found existing Bahut calendar: ${calendar.id}');
          return calendar.id;
        }
      }

      // Si on n'a pas pu créer, retourner le premier calendrier disponible
      if (calendars.isNotEmpty) {
        debugPrint('[CALENDAR] Using default calendar: ${calendars.first.id}');
        return calendars.first.id;
      }

      return null;
    } catch (e) {
      debugPrint('[CALENDAR] Error getting/creating calendar: $e');
      return null;
    }
  }

  /// Ajoute un événement au calendrier
  Future<bool> addEvent({
    required String calendarId,
    required String title,
    required DateTime start,
    DateTime? end,
    String? description,
    String? location,
    bool allDay = false,
    List<int>? reminderMinutes,
  }) async {
    try {
      final event = Event(calendarId);
      event.title = title;
      event.description = description;
      event.location = location;
      event.allDay = allDay;

      // Convertir en TZDateTime
      final tzStart = tz.TZDateTime.from(start, tz.local);
      event.start = tzStart;

      if (end != null) {
        event.end = tz.TZDateTime.from(end, tz.local);
      } else if (allDay) {
        // Pour les événements journée entière, fin = début + 1 jour
        event.end = tzStart.add(const Duration(days: 1));
      } else {
        // Par défaut, durée d'1 heure
        event.end = tzStart.add(const Duration(hours: 1));
      }

      // Ajouter les rappels
      if (reminderMinutes != null && reminderMinutes.isNotEmpty) {
        event.reminders = reminderMinutes
            .map((minutes) => Reminder(minutes: minutes))
            .toList();
      }

      final result = await _calendarPlugin.createOrUpdateEvent(event);
      if (result?.isSuccess == true) {
        debugPrint('[CALENDAR] Event added: $title');
        return true;
      }

      debugPrint('[CALENDAR] Failed to add event: ${result?.errors}');
      return false;
    } catch (e) {
      debugPrint('[CALENDAR] Error adding event: $e');
      return false;
    }
  }

  /// Supprime tous les événements Bahut dans une période donnée
  Future<int> clearEventsInRange({
    required String calendarId,
    required DateTime start,
    required DateTime end,
    String? titlePrefix,
  }) async {
    try {
      final tzStart = tz.TZDateTime.from(start, tz.local);
      final tzEnd = tz.TZDateTime.from(end, tz.local);

      final result = await _calendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: tzStart, endDate: tzEnd),
      );

      if (!result.isSuccess || result.data == null) {
        return 0;
      }

      int deletedCount = 0;
      for (final event in result.data!) {
        // Si un préfixe est spécifié, ne supprimer que les événements correspondants
        if (titlePrefix != null &&
            event.title != null &&
            !event.title!.startsWith(titlePrefix)) {
          continue;
        }

        final deleteResult = await _calendarPlugin.deleteEvent(
          calendarId,
          event.eventId,
        );
        if (deleteResult.isSuccess) {
          deletedCount++;
        }
      }

      debugPrint('[CALENDAR] Deleted $deletedCount events');
      return deletedCount;
    } catch (e) {
      debugPrint('[CALENDAR] Error clearing events: $e');
      return 0;
    }
  }

  /// Récupère les événements existants pour éviter les doublons
  Future<Set<String>> getExistingEventTitles({
    required String calendarId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final tzStart = tz.TZDateTime.from(start, tz.local);
      final tzEnd = tz.TZDateTime.from(end, tz.local);

      final result = await _calendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: tzStart, endDate: tzEnd),
      );

      if (!result.isSuccess || result.data == null) {
        return {};
      }

      return result.data!
          .where((e) => e.title != null)
          .map((e) => '${e.title}_${e.start?.toIso8601String()}')
          .toSet();
    } catch (e) {
      debugPrint('[CALENDAR] Error getting existing events: $e');
      return {};
    }
  }
}

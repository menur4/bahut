import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// Modèle pour un cours dans l'emploi du temps
@freezed
class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
    int? id,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    String? text,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    String? typeCours,
    String? salle,
    String? prof,
    @JsonKey(name: 'classe') String? classe,
    @JsonKey(name: 'classeId') int? classeId,
    String? classeCode,
    String? color,
    @Default(false) bool isFlexible,
    @Default(false) bool isModifie,
    @Default(false) bool isAnnule,
    @Default(false) bool contenuDeSeance,
    @Default(false) bool devoirAFaire,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  /// Parse la date de début (format: "2026-02-02 10:40")
  DateTime? get startDateTime {
    if (startDate == null) return null;
    try {
      // Format API: "YYYY-MM-DD HH:MM"
      final parts = startDate!.split(' ');
      if (parts.length != 2) return null;
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 2) return null;
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Parse la date de fin (format: "2026-02-02 11:35")
  DateTime? get endDateTime {
    if (endDate == null) return null;
    try {
      // Format API: "YYYY-MM-DD HH:MM"
      final parts = endDate!.split(' ');
      if (parts.length != 2) return null;
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 2) return null;
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Durée du cours en minutes
  int get durationMinutes {
    final start = startDateTime;
    final end = endDateTime;
    if (start == null || end == null) return 0;
    return end.difference(start).inMinutes;
  }

  /// Heure de début formatée (HH:mm)
  String get startTimeFormatted {
    final dt = startDateTime;
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Heure de fin formatée (HH:mm)
  String get endTimeFormatted {
    final dt = endDateTime;
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Nom de la matière à afficher
  String get displayMatiere => matiere ?? text ?? 'Cours';

  /// Nom du professeur formaté
  String get displayProf => prof ?? '';
}

/// État de l'emploi du temps pour une période
@freezed
class ScheduleData with _$ScheduleData {
  const ScheduleData._();

  const factory ScheduleData({
    @Default([]) List<CourseModel> courses,
    DateTime? startDate,
    DateTime? endDate,
  }) = _ScheduleData;

  /// Grouper les cours par jour
  Map<DateTime, List<CourseModel>> get coursesByDay {
    final map = <DateTime, List<CourseModel>>{};
    for (final course in courses) {
      final dt = course.startDateTime;
      if (dt == null) continue;
      final dayKey = DateTime(dt.year, dt.month, dt.day);
      map.putIfAbsent(dayKey, () => []).add(course);
    }
    // Trier les cours par heure dans chaque jour
    for (final day in map.keys) {
      map[day]!.sort((a, b) {
        final aStart = a.startDateTime;
        final bStart = b.startDateTime;
        if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
      });
    }
    return map;
  }

  /// Cours d'aujourd'hui
  List<CourseModel> get todayCourses {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    return coursesByDay[todayKey] ?? [];
  }

  /// Prochain cours
  CourseModel? get nextCourse {
    final now = DateTime.now();
    for (final course in courses) {
      final start = course.startDateTime;
      if (start != null && start.isAfter(now)) {
        return course;
      }
    }
    return null;
  }
}

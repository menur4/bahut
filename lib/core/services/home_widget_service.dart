import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/grades/data/models/grade_model.dart';
import '../../features/homework/data/models/homework_model.dart';
import '../../features/schedule/data/models/schedule_model.dart';

/// Provider pour le service de widgets
final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService();
});

/// Identifiants des widgets
class WidgetIds {
  /// iOS App Group ID
  static const String iOSAppGroupId = 'group.com.bahut.app';

  /// Nom du widget Android
  static const String androidAverageWidget = 'AverageWidgetProvider';
  static const String androidHomeworkWidget = 'HomeworkWidgetProvider';
  static const String androidScheduleWidget = 'ScheduleWidgetProvider';

  /// Clés de données partagées
  static const String keyGeneralAverage = 'general_average';
  static const String keyClassAverage = 'class_average';
  static const String keyGradeCount = 'grade_count';
  static const String keyLastUpdate = 'last_update';
  static const String keyChildName = 'child_name';
  static const String keyHomeworkList = 'homework_list';
  static const String keyScheduleList = 'schedule_list';
  static const String keyNextCourse = 'next_course';
}

/// Données pour le widget de moyenne
class AverageWidgetData {
  final double generalAverage;
  final double? classAverage;
  final int gradeCount;
  final String? childName;
  final DateTime lastUpdate;

  const AverageWidgetData({
    required this.generalAverage,
    this.classAverage,
    required this.gradeCount,
    this.childName,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() => {
        'generalAverage': generalAverage,
        'classAverage': classAverage,
        'gradeCount': gradeCount,
        'childName': childName,
        'lastUpdate': lastUpdate.toIso8601String(),
      };
}

/// Données pour le widget de devoirs
class HomeworkWidgetData {
  final String subject;
  final String description;
  final DateTime dueDate;
  final bool isTest;

  const HomeworkWidgetData({
    required this.subject,
    required this.description,
    required this.dueDate,
    this.isTest = false,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isTest': isTest,
      };
}

/// Données pour le widget d'emploi du temps
class ScheduleWidgetData {
  final String subject;
  final String startTime;
  final String endTime;
  final String? room;
  final String? teacher;

  const ScheduleWidgetData({
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.room,
    this.teacher,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
        'teacher': teacher,
      };
}

/// Service de gestion des widgets d'écran d'accueil
class HomeWidgetService {
  bool _isInitialized = false;

  /// Initialise le service de widgets
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configurer l'App Group pour iOS
      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(WidgetIds.iOSAppGroupId);
      }

      // Enregistrer le callback pour les interactions
      HomeWidget.widgetClicked.listen(_onWidgetClicked);

      _isInitialized = true;
      debugPrint('[WIDGET] Service initialisé');
    } catch (e) {
      debugPrint('[WIDGET] Erreur initialisation: $e');
    }
  }

  /// Callback quand un widget est cliqué
  void _onWidgetClicked(Uri? uri) {
    if (uri == null) return;
    debugPrint('[WIDGET] Widget cliqué: $uri');
    // TODO: Naviguer vers l'écran approprié
  }

  /// Met à jour le widget de moyenne générale
  Future<void> updateAverageWidget({
    required double generalAverage,
    double? classAverage,
    required int gradeCount,
    String? childName,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      // Sauvegarder les données pour le widget
      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyGeneralAverage,
        generalAverage.toStringAsFixed(2),
      );

      if (classAverage != null) {
        await HomeWidget.saveWidgetData<String>(
          WidgetIds.keyClassAverage,
          classAverage.toStringAsFixed(2),
        );
      }

      await HomeWidget.saveWidgetData<int>(
        WidgetIds.keyGradeCount,
        gradeCount,
      );

      if (childName != null) {
        await HomeWidget.saveWidgetData<String>(
          WidgetIds.keyChildName,
          childName,
        );
      }

      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyLastUpdate,
        DateTime.now().toIso8601String(),
      );

      // Mettre à jour le widget
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: WidgetIds.androidAverageWidget,
          androidName: WidgetIds.androidAverageWidget,
        );
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: 'AverageWidget');
      }

      debugPrint('[WIDGET] Widget moyenne mis à jour: $generalAverage');
    } catch (e) {
      debugPrint('[WIDGET] Erreur mise à jour widget moyenne: $e');
    }
  }

  /// Met à jour le widget des devoirs
  Future<void> updateHomeworkWidget({
    required List<HomeworkModel> homework,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      // Filtrer les devoirs non faits et trier par date
      final pending = homework
          .where((h) => !h.effectue && h.dueDate != null)
          .toList()
        ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      // Prendre les 5 prochains devoirs
      final upcomingHomework = pending.take(5).map((h) {
        return HomeworkWidgetData(
          subject: h.matiere ?? 'Devoir',
          description: _truncate(h.decodedContenu, 50),
          dueDate: h.dueDate!,
          isTest: h.isInterrogation,
        );
      }).toList();

      // Sérialiser en JSON
      final jsonData = jsonEncode(upcomingHomework.map((h) => h.toJson()).toList());

      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyHomeworkList,
        jsonData,
      );

      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyLastUpdate,
        DateTime.now().toIso8601String(),
      );

      // Mettre à jour le widget
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: WidgetIds.androidHomeworkWidget,
          androidName: WidgetIds.androidHomeworkWidget,
        );
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: 'HomeworkWidget');
      }

      debugPrint('[WIDGET] Widget devoirs mis à jour: ${upcomingHomework.length} devoirs');
    } catch (e) {
      debugPrint('[WIDGET] Erreur mise à jour widget devoirs: $e');
    }
  }

  /// Met à jour le widget d'emploi du temps
  Future<void> updateScheduleWidget({
    required ScheduleData? scheduleData,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      if (scheduleData == null) {
        debugPrint('[WIDGET] Pas de données d\'emploi du temps');
        return;
      }

      // Obtenir les cours du jour
      final todayCourses = scheduleData.todayCourses;

      // Convertir en données de widget
      final scheduleWidgetData = todayCourses.map((course) {
        return ScheduleWidgetData(
          subject: course.displayMatiere,
          startTime: course.startTimeFormatted,
          endTime: course.endTimeFormatted,
          room: course.salle,
          teacher: course.prof,
        );
      }).toList();

      // Sérialiser en JSON
      final jsonData = jsonEncode(scheduleWidgetData.map((s) => s.toJson()).toList());

      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyScheduleList,
        jsonData,
      );

      // Prochain cours
      final nextCourse = scheduleData.nextCourse;
      if (nextCourse != null) {
        final nextCourseData = ScheduleWidgetData(
          subject: nextCourse.displayMatiere,
          startTime: nextCourse.startTimeFormatted,
          endTime: nextCourse.endTimeFormatted,
          room: nextCourse.salle,
          teacher: nextCourse.prof,
        );
        await HomeWidget.saveWidgetData<String>(
          WidgetIds.keyNextCourse,
          jsonEncode(nextCourseData.toJson()),
        );
      }

      await HomeWidget.saveWidgetData<String>(
        WidgetIds.keyLastUpdate,
        DateTime.now().toIso8601String(),
      );

      // Mettre à jour le widget
      if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
          name: WidgetIds.androidScheduleWidget,
          androidName: WidgetIds.androidScheduleWidget,
        );
      } else if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: 'ScheduleWidget');
      }

      debugPrint('[WIDGET] Widget emploi du temps mis à jour: ${todayCourses.length} cours');
    } catch (e) {
      debugPrint('[WIDGET] Erreur mise à jour widget emploi du temps: $e');
    }
  }

  /// Met à jour tous les widgets
  Future<void> updateAllWidgets({
    double? generalAverage,
    double? classAverage,
    int? gradeCount,
    String? childName,
    List<HomeworkModel>? homework,
    ScheduleData? scheduleData,
  }) async {
    if (generalAverage != null && gradeCount != null) {
      await updateAverageWidget(
        generalAverage: generalAverage,
        classAverage: classAverage,
        gradeCount: gradeCount,
        childName: childName,
      );
    }

    if (homework != null) {
      await updateHomeworkWidget(homework: homework);
    }

    if (scheduleData != null) {
      await updateScheduleWidget(scheduleData: scheduleData);
    }
  }

  /// Tronque un texte
  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_core_spotlight/flutter_core_spotlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/grades/data/models/grade_model.dart';

/// Provider pour le service Spotlight
final spotlightServiceProvider = Provider<SpotlightService>((ref) {
  return SpotlightService();
});

/// Domaines d'indexation Spotlight
class SpotlightDomains {
  static const String grades = 'com.bahut.grades';
  static const String subjects = 'com.bahut.subjects';
  static const String homework = 'com.bahut.homework';
}

/// Service de gestion de l'indexation Spotlight (iOS)
class SpotlightService {
  bool _isInitialized = false;

  /// Initialise le service Spotlight
  Future<void> initialize() async {
    if (!Platform.isIOS) {
      debugPrint('[SPOTLIGHT] Service désactivé (non-iOS)');
      return;
    }

    if (_isInitialized) return;

    _isInitialized = true;
    debugPrint('[SPOTLIGHT] Service initialisé');
  }

  /// Indexe une note dans Spotlight
  Future<void> indexGrade(GradeModel grade) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      final subjectName = grade.libelleMatiere;
      final gradeValue = '${grade.valeur}/${grade.noteSur}';

      final item = FlutterSpotlightItem(
        uniqueIdentifier: 'grade_${grade.id}',
        domainIdentifier: SpotlightDomains.grades,
        attributeTitle: '$subjectName: $gradeValue',
        attributeDescription: grade.devoir ?? 'Note en $subjectName',
      );

      await FlutterCoreSpotlight.instance.indexSearchableItems([item]);
      debugPrint('[SPOTLIGHT] Note indexée: ${grade.id}');
    } catch (e) {
      debugPrint('[SPOTLIGHT] Erreur indexation note: $e');
    }
  }

  /// Indexe plusieurs notes
  Future<void> indexGrades(List<GradeModel> grades) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      final items = grades.where((g) => g.id != null).map((grade) {
        final subjectName = grade.libelleMatiere;
        final gradeValue = '${grade.valeur}/${grade.noteSur}';

        return FlutterSpotlightItem(
          uniqueIdentifier: 'grade_${grade.id}',
          domainIdentifier: SpotlightDomains.grades,
          attributeTitle: '$subjectName: $gradeValue',
          attributeDescription: grade.devoir ?? 'Note en $subjectName',
        );
      }).toList();

      if (items.isNotEmpty) {
        await FlutterCoreSpotlight.instance.indexSearchableItems(items);
        debugPrint('[SPOTLIGHT] ${items.length} notes indexées');
      }
    } catch (e) {
      debugPrint('[SPOTLIGHT] Erreur indexation notes: $e');
    }
  }

  /// Indexe une matière avec sa moyenne
  Future<void> indexSubject({
    required String subjectCode,
    required String subjectName,
    required double average,
    double? classAverage,
  }) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      final description = classAverage != null
          ? 'Moyenne: ${average.toStringAsFixed(2)} (Classe: ${classAverage.toStringAsFixed(2)})'
          : 'Moyenne: ${average.toStringAsFixed(2)}';

      final item = FlutterSpotlightItem(
        uniqueIdentifier: 'subject_$subjectCode',
        domainIdentifier: SpotlightDomains.subjects,
        attributeTitle: subjectName,
        attributeDescription: description,
      );

      await FlutterCoreSpotlight.instance.indexSearchableItems([item]);
      debugPrint('[SPOTLIGHT] Matière indexée: $subjectName');
    } catch (e) {
      debugPrint('[SPOTLIGHT] Erreur indexation matière: $e');
    }
  }

  /// Indexe les matières avec leurs moyennes
  Future<void> indexSubjects(Map<String, ({String name, double average, double? classAverage})> subjects) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      final items = subjects.entries.map((entry) {
        final code = entry.key;
        final data = entry.value;
        final description = data.classAverage != null
            ? 'Moyenne: ${data.average.toStringAsFixed(2)} (Classe: ${data.classAverage!.toStringAsFixed(2)})'
            : 'Moyenne: ${data.average.toStringAsFixed(2)}';

        return FlutterSpotlightItem(
          uniqueIdentifier: 'subject_$code',
          domainIdentifier: SpotlightDomains.subjects,
          attributeTitle: data.name,
          attributeDescription: description,
        );
      }).toList();

      if (items.isNotEmpty) {
        await FlutterCoreSpotlight.instance.indexSearchableItems(items);
        debugPrint('[SPOTLIGHT] ${items.length} matières indexées');
      }
    } catch (e) {
      debugPrint('[SPOTLIGHT] Erreur indexation matières: $e');
    }
  }

  /// Supprime une note de l'index
  Future<void> removeGrade(int gradeId) async {
    if (!Platform.isIOS || !_isInitialized) return;

    try {
      await FlutterCoreSpotlight.instance.deleteSearchableItems(['grade_$gradeId']);
      debugPrint('[SPOTLIGHT] Note supprimée: $gradeId');
    } catch (e) {
      debugPrint('[SPOTLIGHT] Erreur suppression note: $e');
    }
  }

  /// Met à jour l'index complet à partir des données actuelles
  Future<void> updateFullIndex({
    required List<GradeModel> grades,
    required Map<String, ({String name, double average, double? classAverage})> subjects,
  }) async {
    if (!Platform.isIOS) return;
    if (!_isInitialized) await initialize();

    // Réindexer (les items existants avec le même ID seront mis à jour)
    await indexGrades(grades);
    await indexSubjects(subjects);

    debugPrint('[SPOTLIGHT] Index mis à jour');
  }
}

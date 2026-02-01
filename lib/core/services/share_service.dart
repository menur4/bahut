import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/grades/data/models/grade_model.dart';

/// Provider pour le service de partage
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

/// Service pour partager du contenu
class ShareService {
  /// Partage une note
  Future<void> shareGrade(GradeModel grade, {Rect? sharePositionOrigin}) async {
    final buffer = StringBuffer();

    buffer.writeln('📚 ${grade.libelleMatiere}');
    buffer.writeln('');
    buffer.writeln('📊 Note: ${grade.valeur}/${grade.noteSur}');

    if (grade.coef.isNotEmpty && grade.coefDouble > 0) {
      buffer.writeln('⚖️ Coefficient: ${grade.coef}');
    }

    if (grade.dateTime != null) {
      buffer.writeln('📅 Date: ${_formatDate(grade.dateTime)}');
    }

    if (grade.devoir.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('📝 ${grade.devoir}');
    }

    buffer.writeln('');
    buffer.writeln('— Partagé depuis Bahut');

    await Share.share(
      buffer.toString(),
      subject: 'Note de ${grade.libelleMatiere}',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage un bulletin (moyennes par matière)
  Future<void> shareBulletin({
    required String childName,
    required String periodName,
    required double generalAverage,
    required Map<String, double> subjectAverages,
    required Map<String, String> subjectNames,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('📊 Bulletin de $childName');
    buffer.writeln('📅 $periodName');
    buffer.writeln('');
    buffer.writeln('═══════════════════════════');
    buffer.writeln('📈 Moyenne générale: ${generalAverage.toStringAsFixed(2)}/20');
    buffer.writeln('═══════════════════════════');
    buffer.writeln('');
    buffer.writeln('📚 Détail par matière:');
    buffer.writeln('');

    // Trier par nom de matière
    final sortedSubjects = subjectAverages.entries.toList()
      ..sort((a, b) => (subjectNames[a.key] ?? a.key)
          .compareTo(subjectNames[b.key] ?? b.key));

    for (final entry in sortedSubjects) {
      final subjectName = subjectNames[entry.key] ?? entry.key;
      final average = entry.value;
      final emoji = _getSubjectEmoji(subjectName);
      buffer.writeln('$emoji $subjectName: ${average.toStringAsFixed(2)}/20');
    }

    buffer.writeln('');
    buffer.writeln('— Partagé depuis Bahut');

    await Share.share(
      buffer.toString(),
      subject: 'Bulletin de $childName - $periodName',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage un résumé des statistiques
  Future<void> shareStatistics({
    required String childName,
    required double currentAverage,
    required double? evolution,
    required int totalGrades,
    required String bestSubject,
    required double bestAverage,
    required String worstSubject,
    required double worstAverage,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('📈 Statistiques de $childName');
    buffer.writeln('');
    buffer.writeln('📊 Moyenne actuelle: ${currentAverage.toStringAsFixed(2)}/20');

    if (evolution != null) {
      final sign = evolution >= 0 ? '+' : '';
      final emoji = evolution >= 0 ? '📈' : '📉';
      buffer.writeln('$emoji Évolution: $sign${evolution.toStringAsFixed(2)} points');
    }

    buffer.writeln('');
    buffer.writeln('📚 Nombre de notes: $totalGrades');
    buffer.writeln('');
    buffer.writeln('🏆 Meilleure matière: $bestSubject (${bestAverage.toStringAsFixed(2)}/20)');
    buffer.writeln('📉 À améliorer: $worstSubject (${worstAverage.toStringAsFixed(2)}/20)');
    buffer.writeln('');
    buffer.writeln('— Partagé depuis Bahut');

    await Share.share(
      buffer.toString(),
      subject: 'Statistiques de $childName',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Partage l'emploi du temps d'une journée
  Future<void> shareSchedule({
    required String childName,
    required DateTime date,
    required List<Map<String, String>> courses,
    Rect? sharePositionOrigin,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('📅 Emploi du temps de $childName');
    buffer.writeln('📆 ${_formatDate(date)}');
    buffer.writeln('');
    buffer.writeln('═══════════════════════════');

    if (courses.isEmpty) {
      buffer.writeln('Pas de cours ce jour');
    } else {
      for (final course in courses) {
        final time = course['time'] ?? '';
        final subject = course['subject'] ?? '';
        final room = course['room'] ?? '';
        final teacher = course['teacher'] ?? '';

        buffer.writeln('');
        buffer.writeln('🕐 $time');
        buffer.writeln('📚 $subject');
        if (room.isNotEmpty) buffer.writeln('🚪 Salle: $room');
        if (teacher.isNotEmpty) buffer.writeln('👤 $teacher');
      }
    }

    buffer.writeln('');
    buffer.writeln('— Partagé depuis Bahut');

    await Share.share(
      buffer.toString(),
      subject: 'Emploi du temps - ${_formatDate(date)}',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getSubjectEmoji(String subject) {
    final lowerSubject = subject.toLowerCase();

    if (lowerSubject.contains('math')) return '🔢';
    if (lowerSubject.contains('français') || lowerSubject.contains('francais')) return '📖';
    if (lowerSubject.contains('anglais')) return '🇬🇧';
    if (lowerSubject.contains('espagnol')) return '🇪🇸';
    if (lowerSubject.contains('allemand')) return '🇩🇪';
    if (lowerSubject.contains('histoire') || lowerSubject.contains('géo')) return '🌍';
    if (lowerSubject.contains('physique') || lowerSubject.contains('chimie')) return '⚗️';
    if (lowerSubject.contains('svt') || lowerSubject.contains('biologie')) return '🧬';
    if (lowerSubject.contains('techno')) return '⚙️';
    if (lowerSubject.contains('eps') || lowerSubject.contains('sport')) return '⚽';
    if (lowerSubject.contains('musique')) return '🎵';
    if (lowerSubject.contains('arts') || lowerSubject.contains('plastiques')) return '🎨';
    if (lowerSubject.contains('philo')) return '🤔';
    if (lowerSubject.contains('latin') || lowerSubject.contains('grec')) return '📜';
    if (lowerSubject.contains('info') || lowerSubject.contains('nsi')) return '💻';
    if (lowerSubject.contains('éco') || lowerSubject.contains('ses')) return '💰';

    return '📚';
  }
}

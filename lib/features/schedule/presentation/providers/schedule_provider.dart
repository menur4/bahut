import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/schedule_model.dart';

/// État de l'emploi du temps
class ScheduleState {
  final bool isLoading;
  final String? errorMessage;
  final ScheduleData? data;
  final DateTime selectedDate;
  final DateTime? lastUpdated;

  ScheduleState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
    DateTime? selectedDate,
    this.lastUpdated,
  }) : selectedDate = selectedDate ?? DateTime.now();

  ScheduleState copyWith({
    bool? isLoading,
    String? errorMessage,
    ScheduleData? data,
    DateTime? selectedDate,
    DateTime? lastUpdated,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      data: data ?? this.data,
      selectedDate: selectedDate ?? this.selectedDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Cours du jour sélectionné
  List<CourseModel> get selectedDayCourses {
    if (data == null) return [];
    final dayKey = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return data!.coursesByDay[dayKey] ?? [];
  }
}

/// Provider pour l'état de l'emploi du temps
final scheduleStateProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
  return ScheduleNotifier(ref);
});

/// Notifier pour gérer l'emploi du temps
class ScheduleNotifier extends StateNotifier<ScheduleState> {
  final Ref _ref;
  static const String _cacheKey = 'schedule_cache';

  ScheduleNotifier(this._ref) : super(ScheduleState()) {
    _loadFromCache();
  }

  /// Charger depuis le cache
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      if (cacheJson != null) {
        final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
        final coursesList = (cacheData['courses'] as List?)
                ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        final data = ScheduleData(courses: coursesList);
        final lastUpdated = cacheData['lastUpdated'] != null
            ? DateTime.parse(cacheData['lastUpdated'])
            : null;
        state = state.copyWith(
          data: data,
          lastUpdated: lastUpdated,
        );
        debugPrint('[SCHEDULE] Chargé depuis cache: ${coursesList.length} cours');
      }
    } catch (e) {
      debugPrint('[SCHEDULE] Erreur cache: $e');
    }
  }

  /// Sauvegarder dans le cache
  Future<void> _saveToCache(ScheduleData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'courses': data.courses.map((c) => c.toJson()).toList(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheData));
    } catch (e) {
      debugPrint('[SCHEDULE] Erreur sauvegarde cache: $e');
    }
  }

  /// Changer la date sélectionnée
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Aller à aujourd'hui
  void goToToday() {
    state = state.copyWith(selectedDate: DateTime.now());
  }

  /// Aller à la semaine précédente
  void previousWeek() {
    state = state.copyWith(
      selectedDate: state.selectedDate.subtract(const Duration(days: 7)),
    );
  }

  /// Aller à la semaine suivante
  void nextWeek() {
    state = state.copyWith(
      selectedDate: state.selectedDate.add(const Duration(days: 7)),
    );
  }

  /// Récupérer l'emploi du temps pour une période
  Future<void> fetchSchedule({
    DateTime? startDate,
    DateTime? endDate,
    bool forceRefresh = false,
  }) async {
    final authState = _ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild == null) {
      state = state.copyWith(errorMessage: 'Aucun élève sélectionné');
      return;
    }

    if (state.isLoading) return;

    // Définir la période (semaine courante par défaut)
    final now = state.selectedDate;
    final weekStart = startDate ??
        now.subtract(Duration(days: now.weekday - 1)); // Lundi
    final weekEnd = endDate ??
        weekStart.add(const Duration(days: 6)); // Dimanche

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apiClient = _ref.read(apiClientProvider);
      final endpoint = ApiConstants.emploiDuTempsEndpoint(selectedChild.id);

      final dateDebut =
          '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
      final dateFin =
          '${weekEnd.year}-${weekEnd.month.toString().padLeft(2, '0')}-${weekEnd.day.toString().padLeft(2, '0')}';

      debugPrint('[SCHEDULE] Fetching: $endpoint ($dateDebut -> $dateFin)');

      final response = await apiClient.post(
        endpoint,
        data: {
          'dateDebut': dateDebut,
          'dateFin': dateFin,
          'avecTrous': false,
        },
        queryParameters: {
          'verbe': 'get',
          'v': ApiConstants.apiVersionNumber,
        },
      );

      final code = response['code'] as int?;
      debugPrint('[SCHEDULE] Response code: $code');
      debugPrint('[SCHEDULE] Response data type: ${response['data']?.runtimeType}');
      debugPrint('[SCHEDULE] Response data: ${response['data']}');

      if (code != 200) {
        throw Exception(response['message'] ?? 'Erreur inconnue');
      }

      final responseData = response['data'] as List?;
      if (responseData == null || responseData.isEmpty) {
        debugPrint('[SCHEDULE] Pas de données reçues');
        state = state.copyWith(
          isLoading: false,
          data: const ScheduleData(courses: []),
          lastUpdated: DateTime.now(),
        );
        return;
      }

      // Debug: afficher le premier élément pour voir le format
      debugPrint('[SCHEDULE] Premier élément: ${responseData.first}');

      final courses = responseData.map((e) {
        return CourseModel.fromJson(e as Map<String, dynamic>);
      }).toList();

      // Trier par date de début
      courses.sort((a, b) {
        final aStart = a.startDateTime;
        final bStart = b.startDateTime;
        if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
      });

      final data = ScheduleData(
        courses: courses,
        startDate: weekStart,
        endDate: weekEnd,
      );

      debugPrint('[SCHEDULE] Récupéré: ${courses.length} cours');

      await _saveToCache(data);

      state = state.copyWith(
        isLoading: false,
        data: data,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[SCHEDULE] Erreur: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Récupérer les détails d'un cours (cahier de texte)
  Future<Map<String, dynamic>?> fetchCourseDetails(DateTime date, String codeMatiere) async {
    final authState = _ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild == null) {
      throw Exception('Aucun élève sélectionné');
    }

    try {
      final apiClient = _ref.read(apiClientProvider);
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      // Endpoint: /v3/Eleves/{id}/cahierdetexte/{date}.awp
      final endpoint = '/${ApiConstants.apiVersion}/Eleves/${selectedChild.id}/cahierdetexte/$dateStr.awp';

      debugPrint('[SCHEDULE] Fetching course details: $endpoint');

      final response = await apiClient.post(
        endpoint,
        data: {},
        queryParameters: {
          'verbe': 'get',
          'v': ApiConstants.apiVersionNumber,
        },
      );

      final code = response['code'] as int?;
      if (code != 200) {
        debugPrint('[SCHEDULE] Course details error: ${response['message']}');
        return null;
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) return null;

      // Chercher la matière correspondante
      final matieres = data['matieres'] as List?;
      if (matieres == null) return null;

      for (final matiere in matieres) {
        final m = matiere as Map<String, dynamic>;
        final matiereCode = m['codeMatiere'] as String?;

        if (matiereCode == codeMatiere) {
          String? contenuDeSeance;
          String? travailAFaire;

          // Extraire le contenu de séance
          final contenu = m['contenuDeSeance'] as Map<String, dynamic>?;
          if (contenu != null) {
            final contenuEncoded = contenu['contenu'] as String?;
            if (contenuEncoded != null && contenuEncoded.isNotEmpty) {
              try {
                contenuDeSeance = _decodeBase64Html(contenuEncoded);
              } catch (e) {
                debugPrint('[SCHEDULE] Error decoding contenu: $e');
              }
            }
          }

          // Extraire le travail à faire
          final aFaire = m['aFaire'] as Map<String, dynamic>?;
          if (aFaire != null) {
            final contenuEncoded = aFaire['contenu'] as String?;
            if (contenuEncoded != null && contenuEncoded.isNotEmpty) {
              try {
                travailAFaire = _decodeBase64Html(contenuEncoded);
              } catch (e) {
                debugPrint('[SCHEDULE] Error decoding aFaire: $e');
              }
            }
          }

          if (contenuDeSeance != null || travailAFaire != null) {
            return {
              'contenuDeSeance': contenuDeSeance,
              'travailAFaire': travailAFaire,
            };
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('[SCHEDULE] Error fetching course details: $e');
      // Ne pas propager l'exception - simplement retourner null
      // Le cahier de texte peut ne pas être disponible pour cet établissement
      return null;
    }
  }

  /// Décoder le contenu HTML encodé en base64
  String _decodeBase64Html(String encoded) {
    try {
      final decoded = utf8.decode(base64Decode(encoded));
      // Nettoyer le HTML basique
      return decoded
          .replaceAll(RegExp(r'<br\s*/?>'), '\n')
          .replaceAll(RegExp(r'<p>'), '')
          .replaceAll(RegExp(r'</p>'), '\n')
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .trim();
    } catch (e) {
      return encoded;
    }
  }

  /// Vider le cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    state = ScheduleState();
  }
}

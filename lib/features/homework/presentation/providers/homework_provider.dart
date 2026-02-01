import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/homework_model.dart';

/// État des devoirs
class HomeworkState {
  final bool isLoading;
  final String? errorMessage;
  final HomeworkData? data;
  final DateTime? lastUpdated;

  const HomeworkState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
    this.lastUpdated,
  });

  HomeworkState copyWith({
    bool? isLoading,
    String? errorMessage,
    HomeworkData? data,
    DateTime? lastUpdated,
  }) {
    return HomeworkState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      data: data ?? this.data,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Nombre de devoirs à faire
  int get pendingCount => data?.pending.length ?? 0;

  /// Nombre de devoirs effectués
  int get completedCount => data?.completed.length ?? 0;
}

/// Provider pour l'état des devoirs
final homeworkStateProvider =
    StateNotifierProvider<HomeworkNotifier, HomeworkState>((ref) {
  return HomeworkNotifier(ref);
});

/// Notifier pour gérer les devoirs
class HomeworkNotifier extends StateNotifier<HomeworkState> {
  final Ref _ref;
  static const String _cacheKey = 'homework_cache';

  HomeworkNotifier(this._ref) : super(const HomeworkState()) {
    _loadFromCache();
  }

  /// Charger depuis le cache
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      if (cacheJson != null) {
        final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
        final homeworksList = (cacheData['homeworks'] as List?)
                ?.map((e) => HomeworkModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        final homeworksByDate =
            (cacheData['homeworksByDate'] as Map<String, dynamic>?)?.map(
                  (key, value) => MapEntry(
                    key,
                    (value as List)
                        .map((e) =>
                            HomeworkModel.fromJson(e as Map<String, dynamic>))
                        .toList(),
                  ),
                ) ??
                {};
        final data = HomeworkData(
          homeworks: homeworksList,
          homeworksByDate: homeworksByDate,
        );
        final lastUpdated = cacheData['lastUpdated'] != null
            ? DateTime.parse(cacheData['lastUpdated'])
            : null;
        state = state.copyWith(
          data: data,
          lastUpdated: lastUpdated,
        );
        debugPrint('[HOMEWORK] Chargé depuis cache: ${homeworksList.length} devoirs');
      }
    } catch (e) {
      debugPrint('[HOMEWORK] Erreur cache: $e');
    }
  }

  /// Sauvegarder dans le cache
  Future<void> _saveToCache(HomeworkData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'homeworks': data.homeworks.map((h) => h.toJson()).toList(),
        'homeworksByDate': data.homeworksByDate.map(
          (key, value) => MapEntry(
            key,
            value.map((h) => h.toJson()).toList(),
          ),
        ),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheData));
    } catch (e) {
      debugPrint('[HOMEWORK] Erreur sauvegarde cache: $e');
    }
  }

  /// Décoder le contenu base64
  String _decodeBase64Content(String? content) {
    if (content == null || content.isEmpty) return '';
    try {
      final bytes = base64Decode(content);
      return utf8.decode(bytes);
    } catch (_) {
      return content;
    }
  }

  /// Récupérer les devoirs
  Future<void> fetchHomework({bool forceRefresh = false}) async {
    final authState = _ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild == null) {
      state = state.copyWith(errorMessage: 'Aucun élève sélectionné');
      return;
    }

    if (state.isLoading) return;

    // Utiliser le cache si récent
    if (!forceRefresh && state.data != null && state.lastUpdated != null) {
      final age = DateTime.now().difference(state.lastUpdated!);
      if (age.inMinutes < 5) {
        debugPrint('[HOMEWORK] Cache encore valide');
        return;
      }
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apiClient = _ref.read(apiClientProvider);
      final endpoint = ApiConstants.cahierDeTexteEndpoint(selectedChild.id);

      debugPrint('[HOMEWORK] Fetching: $endpoint');

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
        throw Exception(response['message'] ?? 'Erreur inconnue');
      }

      final responseData = response['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        state = state.copyWith(
          isLoading: false,
          data: const HomeworkData(),
          lastUpdated: DateTime.now(),
        );
        return;
      }

      // Parser les devoirs par date
      // Format API: {"2026-02-02": [{matiere, codeMatiere, aFaire: true, idDevoir, ...}]}
      final homeworksByDate = <String, List<HomeworkModel>>{};
      final allHomeworks = <HomeworkModel>[];

      responseData.forEach((dateStr, dayData) {
        // dayData est une liste directe de devoirs
        if (dayData is List) {
          final dayHomeworks = <HomeworkModel>[];

          for (final homeworkData in dayData) {
            if (homeworkData is Map<String, dynamic>) {
              final homework = HomeworkModel(
                idDevoir: homeworkData['idDevoir'] as int?,
                matiere: homeworkData['matiere'] as String?,
                codeMatiere: homeworkData['codeMatiere'] as String?,
                aFaire: homeworkData['aFaire'] as bool? ?? false,
                donneLe: homeworkData['donneLe'] as String?,
                pourLe: dateStr,
                effectue: homeworkData['effectue'] as bool? ?? false,
                interrogation: homeworkData['interrogation'] == true ? 'true' : null,
                documentsAFaire: homeworkData['documentsAFaire'] as bool? ?? false,
              );
              dayHomeworks.add(homework);
              allHomeworks.add(homework);
            }
          }

          if (dayHomeworks.isNotEmpty) {
            homeworksByDate[dateStr] = dayHomeworks;
          }
        }
      });

      final data = HomeworkData(
        homeworks: allHomeworks,
        homeworksByDate: homeworksByDate,
      );

      debugPrint('[HOMEWORK] Récupéré: ${allHomeworks.length} devoirs sur ${homeworksByDate.length} jours');

      await _saveToCache(data);

      state = state.copyWith(
        isLoading: false,
        data: data,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[HOMEWORK] Erreur: $e');
      String errorMsg = e.toString();

      // Message plus clair pour l'erreur 403
      if (errorMsg.contains('403') || errorMsg.contains('Réponse invalide')) {
        errorMsg = 'Le cahier de texte n\'est pas disponible pour ce compte.\n\nCette fonctionnalité peut ne pas être activée par l\'établissement.';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    }
  }

  /// Vider le cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    state = const HomeworkState();
  }
}

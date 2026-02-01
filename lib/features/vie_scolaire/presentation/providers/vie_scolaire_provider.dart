import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/vie_scolaire_model.dart';

/// État de la vie scolaire
class VieScolaireState {
  final bool isLoading;
  final String? errorMessage;
  final VieScolaireData? data;
  final DateTime? lastUpdated;

  const VieScolaireState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
    this.lastUpdated,
  });

  VieScolaireState copyWith({
    bool? isLoading,
    String? errorMessage,
    VieScolaireData? data,
    DateTime? lastUpdated,
  }) {
    return VieScolaireState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      data: data ?? this.data,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Nombre total d'absences
  int get totalAbsences => data?.absences.length ?? 0;

  /// Nombre total de retards
  int get totalRetards => data?.retards.length ?? 0;

  /// Nombre total de sanctions
  int get totalSanctions => data?.sanctions.length ?? 0;

  /// Nombre total d'encouragements
  int get totalEncouragements => data?.encouragements.length ?? 0;
}

/// Provider pour l'état de la vie scolaire
final vieScolaireStateProvider =
    StateNotifierProvider<VieScolaireNotifier, VieScolaireState>((ref) {
  return VieScolaireNotifier(ref);
});

/// Notifier pour gérer la vie scolaire
class VieScolaireNotifier extends StateNotifier<VieScolaireState> {
  final Ref _ref;
  static const String _cacheKey = 'vie_scolaire_cache';

  VieScolaireNotifier(this._ref) : super(const VieScolaireState()) {
    _loadFromCache();
  }

  /// Charger depuis le cache
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_cacheKey);
      if (cacheJson != null) {
        final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
        final data = VieScolaireData.fromJson(cacheData['data']);
        final lastUpdated = cacheData['lastUpdated'] != null
            ? DateTime.parse(cacheData['lastUpdated'])
            : null;
        state = state.copyWith(
          data: data,
          lastUpdated: lastUpdated,
        );
        debugPrint('[VIE_SCOLAIRE] Chargé depuis cache: ${data.absencesRetards.length} éléments');
      }
    } catch (e) {
      debugPrint('[VIE_SCOLAIRE] Erreur cache: $e');
    }
  }

  /// Sauvegarder dans le cache
  Future<void> _saveToCache(VieScolaireData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'data': data.toJson(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheData));
    } catch (e) {
      debugPrint('[VIE_SCOLAIRE] Erreur sauvegarde cache: $e');
    }
  }

  /// Récupérer les données de vie scolaire
  Future<void> fetchVieScolaire({bool forceRefresh = false}) async {
    final authState = _ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild == null) {
      state = state.copyWith(errorMessage: 'Aucun élève sélectionné');
      return;
    }

    // Ne pas recharger si déjà en cours
    if (state.isLoading) return;

    // Utiliser le cache si récent (moins de 5 minutes) et pas de forceRefresh
    if (!forceRefresh && state.data != null && state.lastUpdated != null) {
      final age = DateTime.now().difference(state.lastUpdated!);
      if (age.inMinutes < 5) {
        debugPrint('[VIE_SCOLAIRE] Cache encore valide');
        return;
      }
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apiClient = _ref.read(apiClientProvider);
      final endpoint = ApiConstants.vieScolaireEndpoint(selectedChild.id);

      debugPrint('[VIE_SCOLAIRE] Fetching: $endpoint');

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
        throw Exception('Données invalides');
      }

      // Parser les données
      final absencesRetardsList =
          (responseData['absencesRetards'] as List?)?.map((e) {
                return AbsenceRetardModel.fromJson(e as Map<String, dynamic>);
              }).toList() ??
              [];

      final sanctionsEncouragementsList =
          (responseData['sanctionsEncouragements'] as List?)?.map((e) {
                return SanctionEncouragementModel.fromJson(
                    e as Map<String, dynamic>);
              }).toList() ??
              [];

      VieScolaireParametrage? parametrage;
      if (responseData['parametrage'] != null) {
        parametrage = VieScolaireParametrage.fromJson(
            responseData['parametrage'] as Map<String, dynamic>);
      }

      final data = VieScolaireData(
        absencesRetards: absencesRetardsList,
        sanctionsEncouragements: sanctionsEncouragementsList,
        parametrage: parametrage,
      );

      debugPrint('[VIE_SCOLAIRE] Récupéré: ${absencesRetardsList.length} absences/retards, ${sanctionsEncouragementsList.length} sanctions/encouragements');

      await _saveToCache(data);

      state = state.copyWith(
        isLoading: false,
        data: data,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[VIE_SCOLAIRE] Erreur: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Vider le cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    state = const VieScolaireState();
  }
}

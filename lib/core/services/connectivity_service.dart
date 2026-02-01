import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// État de connectivité
enum ConnectivityStatus {
  /// Connecté à internet
  connected,

  /// Déconnecté
  disconnected,

  /// Vérification en cours
  checking,
}

/// Provider pour le statut de connectivité
final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>((ref) {
  return ConnectivityNotifier();
});

/// Provider simple pour savoir si on est en ligne
final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStatusProvider) == ConnectivityStatus.connected;
});

/// Provider pour savoir si on est hors ligne
final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityStatusProvider) == ConnectivityStatus.disconnected;
});

/// Notifier pour gérer le statut de connectivité
class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  Timer? _periodicCheck;
  static const _checkInterval = Duration(seconds: 30);
  static const _checkTimeout = Duration(seconds: 5);

  ConnectivityNotifier() : super(ConnectivityStatus.checking) {
    // Vérification initiale
    checkConnectivity();

    // Vérification périodique
    _periodicCheck = Timer.periodic(_checkInterval, (_) {
      checkConnectivity();
    });
  }

  @override
  void dispose() {
    _periodicCheck?.cancel();
    super.dispose();
  }

  /// Vérifie la connectivité en faisant un ping
  Future<void> checkConnectivity() async {
    try {
      // Essayer de résoudre une adresse DNS
      final result = await InternetAddress.lookup('google.com')
          .timeout(_checkTimeout);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (state != ConnectivityStatus.connected) {
          state = ConnectivityStatus.connected;
          debugPrint('[CONNECTIVITY] Status: connected');
        }
      } else {
        _setDisconnected();
      }
    } on SocketException catch (_) {
      _setDisconnected();
    } on TimeoutException catch (_) {
      _setDisconnected();
    } catch (e) {
      debugPrint('[CONNECTIVITY] Error checking connectivity: $e');
      _setDisconnected();
    }
  }

  void _setDisconnected() {
    if (state != ConnectivityStatus.disconnected) {
      state = ConnectivityStatus.disconnected;
      debugPrint('[CONNECTIVITY] Status: disconnected');
    }
  }

  /// Force une vérification immédiate
  Future<bool> forceCheck() async {
    state = ConnectivityStatus.checking;
    await checkConnectivity();
    return state == ConnectivityStatus.connected;
  }
}

/// Extension pour faciliter l'utilisation dans les widgets
extension ConnectivityRefExtension on WidgetRef {
  /// Vérifie si on est en ligne
  bool get isOnline => read(isOnlineProvider);

  /// Vérifie si on est hors ligne
  bool get isOffline => read(isOfflineProvider);

  /// Force une vérification de connectivité
  Future<bool> checkConnectivity() {
    return read(connectivityStatusProvider.notifier).forceCheck();
  }
}

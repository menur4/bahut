import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Types de retour haptique conformes aux HIG Apple
enum HapticType {
  /// Impact léger - navigation, sélection d'élément
  lightImpact,

  /// Impact moyen - action confirmée
  mediumImpact,

  /// Impact lourd - action importante
  heavyImpact,

  /// Clic de sélection - changement de valeur (slider, picker)
  selectionClick,

  /// Notification de succès - action réussie
  success,

  /// Notification d'avertissement - attention requise
  warning,

  /// Notification d'erreur - action échouée
  error,
}

/// Clé de stockage pour la préférence haptic
const String _hapticEnabledKey = 'haptic_enabled';

/// Provider pour l'état d'activation des retours haptiques
final hapticEnabledProvider =
    StateNotifierProvider<HapticEnabledNotifier, bool>((ref) {
  return HapticEnabledNotifier();
});

/// Notifier pour gérer l'activation des retours haptiques
class HapticEnabledNotifier extends StateNotifier<bool> {
  HapticEnabledNotifier() : super(true) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(_hapticEnabledKey);
      if (enabled != null) {
        state = enabled;
      }
    } catch (e) {
      // Garder la valeur par défaut
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticEnabledKey, enabled);
    } catch (e) {
      // Ignorer les erreurs de sauvegarde
    }
  }

  Future<void> toggle() async {
    await setEnabled(!state);
  }
}

/// Provider pour le service de retour haptique
final hapticServiceProvider = Provider<HapticService>((ref) {
  final isEnabled = ref.watch(hapticEnabledProvider);
  return HapticService(isEnabled: isEnabled);
});

/// Service de retour haptique centralisé conforme aux HIG Apple
///
/// Utilisation:
/// ```dart
/// final haptic = ref.read(hapticServiceProvider);
/// haptic.lightImpact(); // Pour une navigation
/// haptic.selectionClick(); // Pour un changement de valeur
/// haptic.success(); // Pour une action réussie
/// ```
class HapticService {
  final bool isEnabled;

  const HapticService({this.isEnabled = true});

  /// Vérifie si les haptics sont disponibles sur cette plateforme
  bool get _isSupported => Platform.isIOS || Platform.isAndroid;

  /// Impact léger - Pour navigation, sélection légère
  /// Utilisation: Tap sur un élément de liste, navigation entre écrans
  void lightImpact() {
    if (!isEnabled || !_isSupported) return;
    HapticFeedback.lightImpact();
  }

  /// Impact moyen - Pour actions confirmées
  /// Utilisation: Validation d'un formulaire, ajout à une liste
  void mediumImpact() {
    if (!isEnabled || !_isSupported) return;
    HapticFeedback.mediumImpact();
  }

  /// Impact lourd - Pour actions importantes
  /// Utilisation: Suppression, déconnexion, action irréversible
  void heavyImpact() {
    if (!isEnabled || !_isSupported) return;
    HapticFeedback.heavyImpact();
  }

  /// Clic de sélection - Pour changements de valeur
  /// Utilisation: Slider, picker, switch toggle
  void selectionClick() {
    if (!isEnabled || !_isSupported) return;
    HapticFeedback.selectionClick();
  }

  /// Notification de succès
  /// Utilisation: Connexion réussie, sauvegarde effectuée
  void success() {
    if (!isEnabled || !_isSupported) return;
    // iOS UINotificationFeedbackGenerator.notificationOccurred(.success)
    // Sur Flutter, utiliser une séquence pour simuler le succès
    if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Notification d'avertissement
  /// Utilisation: Champ invalide, limite atteinte
  void warning() {
    if (!isEnabled || !_isSupported) return;
    if (Platform.isIOS) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Notification d'erreur
  /// Utilisation: Échec de connexion, erreur de validation
  void error() {
    if (!isEnabled || !_isSupported) return;
    // Séquence double tap pour erreur
    HapticFeedback.heavyImpact();
  }

  /// Feedback selon le type demandé
  void feedback(HapticType type) {
    switch (type) {
      case HapticType.lightImpact:
        lightImpact();
      case HapticType.mediumImpact:
        mediumImpact();
      case HapticType.heavyImpact:
        heavyImpact();
      case HapticType.selectionClick:
        selectionClick();
      case HapticType.success:
        success();
      case HapticType.warning:
        warning();
      case HapticType.error:
        error();
    }
  }
}

/// Extension pour utiliser les haptics directement depuis WidgetRef
extension HapticRefExtension on WidgetRef {
  /// Accès rapide au service haptic
  HapticService get haptic => read(hapticServiceProvider);
}

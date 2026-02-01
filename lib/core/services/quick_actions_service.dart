import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

/// Provider pour le service de quick actions
final quickActionsServiceProvider = Provider<QuickActionsService>((ref) {
  return QuickActionsService();
});

/// Types d'actions rapides disponibles
enum QuickActionType {
  viewGrades('view_grades', 'Voir mes notes', 'assignment'),
  todayHomework('today_homework', 'Devoirs du jour', 'book'),
  viewSchedule('view_schedule', 'Emploi du temps', 'calendar_today'),
  simulator('simulator', 'Simulateur', 'calculate');

  final String type;
  final String title;
  final String iconName;

  const QuickActionType(this.type, this.title, this.iconName);

  /// Obtient l'icône iOS appropriée
  String get iOSIcon {
    switch (this) {
      case QuickActionType.viewGrades:
        return 'doc.text.fill';
      case QuickActionType.todayHomework:
        return 'book.fill';
      case QuickActionType.viewSchedule:
        return 'calendar';
      case QuickActionType.simulator:
        return 'function';
    }
  }

  /// Obtient le nom de ressource Android
  String get androidIcon => 'ic_$iconName';
}

/// Callback type pour les actions rapides
typedef QuickActionCallback = void Function(QuickActionType action);

/// Service de gestion des Quick Actions (3D Touch / Long press)
class QuickActionsService {
  final QuickActions _quickActions = const QuickActions();
  QuickActionCallback? _callback;
  bool _isInitialized = false;

  /// Initialise les quick actions
  Future<void> initialize({QuickActionCallback? onAction}) async {
    if (_isInitialized) return;

    _callback = onAction;

    try {
      // Configurer les actions disponibles
      await _quickActions.setShortcutItems(_buildShortcutItems());

      // Écouter les clics sur les actions
      _quickActions.initialize((type) {
        debugPrint('[QUICK_ACTION] Action déclenchée: $type');
        _handleAction(type);
      });

      _isInitialized = true;
      debugPrint('[QUICK_ACTION] Service initialisé avec ${QuickActionType.values.length} actions');
    } catch (e) {
      debugPrint('[QUICK_ACTION] Erreur initialisation: $e');
    }
  }

  /// Construit la liste des raccourcis
  List<ShortcutItem> _buildShortcutItems() {
    return QuickActionType.values.map((action) {
      return ShortcutItem(
        type: action.type,
        localizedTitle: action.title,
        icon: Platform.isIOS ? action.iOSIcon : action.androidIcon,
      );
    }).toList();
  }

  /// Gère une action déclenchée
  void _handleAction(String type) {
    final action = QuickActionType.values.firstWhere(
      (a) => a.type == type,
      orElse: () => QuickActionType.viewGrades,
    );

    _callback?.call(action);
  }

  /// Met à jour le callback d'action
  void setCallback(QuickActionCallback callback) {
    _callback = callback;
  }

  /// Met à jour les raccourcis avec des badges dynamiques
  Future<void> updateShortcuts({
    int? newGradesCount,
    int? pendingHomeworkCount,
  }) async {
    if (!_isInitialized) return;

    try {
      final items = <ShortcutItem>[];

      // Action "Voir mes notes" avec badge si nouvelles notes
      final gradesSubtitle = newGradesCount != null && newGradesCount > 0
          ? '$newGradesCount nouvelles'
          : null;
      items.add(ShortcutItem(
        type: QuickActionType.viewGrades.type,
        localizedTitle: QuickActionType.viewGrades.title,
        localizedSubtitle: gradesSubtitle,
        icon: Platform.isIOS
            ? QuickActionType.viewGrades.iOSIcon
            : QuickActionType.viewGrades.androidIcon,
      ));

      // Action "Devoirs du jour" avec badge si devoirs en attente
      final homeworkSubtitle = pendingHomeworkCount != null && pendingHomeworkCount > 0
          ? '$pendingHomeworkCount à faire'
          : null;
      items.add(ShortcutItem(
        type: QuickActionType.todayHomework.type,
        localizedTitle: QuickActionType.todayHomework.title,
        localizedSubtitle: homeworkSubtitle,
        icon: Platform.isIOS
            ? QuickActionType.todayHomework.iOSIcon
            : QuickActionType.todayHomework.androidIcon,
      ));

      // Action "Emploi du temps"
      items.add(ShortcutItem(
        type: QuickActionType.viewSchedule.type,
        localizedTitle: QuickActionType.viewSchedule.title,
        icon: Platform.isIOS
            ? QuickActionType.viewSchedule.iOSIcon
            : QuickActionType.viewSchedule.androidIcon,
      ));

      // Action "Simulateur"
      items.add(ShortcutItem(
        type: QuickActionType.simulator.type,
        localizedTitle: QuickActionType.simulator.title,
        icon: Platform.isIOS
            ? QuickActionType.simulator.iOSIcon
            : QuickActionType.simulator.androidIcon,
      ));

      await _quickActions.setShortcutItems(items);
      debugPrint('[QUICK_ACTION] Raccourcis mis à jour');
    } catch (e) {
      debugPrint('[QUICK_ACTION] Erreur mise à jour raccourcis: $e');
    }
  }

  /// Efface tous les raccourcis
  Future<void> clearShortcuts() async {
    try {
      await _quickActions.clearShortcutItems();
      debugPrint('[QUICK_ACTION] Raccourcis effacés');
    } catch (e) {
      debugPrint('[QUICK_ACTION] Erreur effacement raccourcis: $e');
    }
  }

  /// Obtient la route correspondant à une action
  static String getRouteForAction(QuickActionType action) {
    switch (action) {
      case QuickActionType.viewGrades:
        return '/grades';
      case QuickActionType.todayHomework:
        return '/homework';
      case QuickActionType.viewSchedule:
        return '/schedule';
      case QuickActionType.simulator:
        return '/simulation';
    }
  }
}

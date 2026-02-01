import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/services/background_sync_service.dart';
import 'core/services/home_widget_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/quick_actions_service.dart';
import 'core/services/spotlight_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les locales pour la date
  await initializeDateFormatting('fr_FR', null);

  // Initialiser le service de notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialiser le service de synchronisation en arrière-plan
  final backgroundSyncService = BackgroundSyncService();
  await backgroundSyncService.initialize();

  // Initialiser le service de widgets d'écran d'accueil
  final homeWidgetService = HomeWidgetService();
  await homeWidgetService.initialize();

  // Initialiser les Quick Actions (3D Touch / Long press)
  final quickActionsService = QuickActionsService();
  await quickActionsService.initialize();

  // Initialiser le service Spotlight (iOS)
  final spotlightService = SpotlightService();
  await spotlightService.initialize();

  // Configuration de la barre de statut (style Chanel - noir sur blanc)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: CalculMoyenneApp(),
    ),
  );
}

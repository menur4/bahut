import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/services/quick_actions_service.dart';
import 'core/services/system_integration_service.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/grades/presentation/providers/grades_provider.dart';
import 'features/homework/presentation/providers/homework_provider.dart';
import 'features/schedule/presentation/providers/schedule_provider.dart';
import 'router/app_router.dart';

/// Application principale avec thèmes dynamiques et navigation adaptative
class CalculMoyenneApp extends ConsumerStatefulWidget {
  const CalculMoyenneApp({super.key});

  @override
  ConsumerState<CalculMoyenneApp> createState() => _CalculMoyenneAppState();
}

class _CalculMoyenneAppState extends ConsumerState<CalculMoyenneApp>
    with WidgetsBindingObserver {
  bool _systemIntegrationSetup = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Mise à jour initiale de la luminosité après le premier frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformBrightness();
      _setupSystemIntegration();
    });
  }

  /// Configure les intégrations système (widgets, quick actions)
  void _setupSystemIntegration() {
    if (_systemIntegrationSetup) return;
    _systemIntegrationSetup = true;

    try {
      // Configurer le callback des Quick Actions
      final quickActionsService = ref.read(quickActionsServiceProvider);
      quickActionsService.setCallback((action) {
        try {
          final route = QuickActionsService.getRouteForAction(action);
          // Naviguer vers la route correspondante
          final router = ref.read(appRouterProvider);
          router.go(route);
        } catch (e) {
          debugPrint('[APP] Erreur navigation quick action: $e');
        }
      });

      // Écouter les changements de données pour mettre à jour les widgets
      ref.listenManual(gradesStateProvider, (previous, next) {
        if (previous?.grades.length != next.grades.length ||
            previous?.generalAverage != next.generalAverage) {
          _updateSystemIntegrations();
        }
      });

      ref.listenManual(homeworkStateProvider, (previous, next) {
        if (previous?.data?.homeworks.length != next.data?.homeworks.length) {
          _updateSystemIntegrations();
        }
      });

      ref.listenManual(scheduleStateProvider, (previous, next) {
        if (previous?.data?.todayCourses.length != next.data?.todayCourses.length) {
          _updateSystemIntegrations();
        }
      });

      debugPrint('[APP] Intégrations système configurées');
    } catch (e) {
      debugPrint('[APP] Erreur configuration intégrations système: $e');
    }
  }

  /// Met à jour les intégrations système (widgets, Spotlight)
  Future<void> _updateSystemIntegrations() async {
    try {
      final systemService = ref.read(systemIntegrationServiceProvider);
      await systemService.updateAll();
    } catch (e) {
      debugPrint('[APP] Erreur mise à jour intégrations système: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _updatePlatformBrightness();
  }

  void _updatePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    ref.read(platformBrightnessProvider.notifier).state = brightness;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final appThemeType = ref.watch(appThemeTypeProvider);

    // Palettes light et dark basées sur le thème sélectionné
    final lightPalette = AppThemes.getPalette(appThemeType);
    final darkPalette = AppThemes.getDarkPalette(appThemeType);

    // Générer les thèmes Material
    final materialLightTheme = AppThemes.generateThemeData(lightPalette);
    final materialDarkTheme = AppThemes.generateThemeData(darkPalette);

    // Thème Cupertino light basé sur la palette
    final cupertinoLightTheme = CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: lightPalette.primary,
      scaffoldBackgroundColor: lightPalette.backgroundSecondary,
      barBackgroundColor: lightPalette.backgroundPrimary,
      textTheme: CupertinoTextThemeData(
        primaryColor: lightPalette.primary,
        textStyle: TextStyle(color: lightPalette.textPrimary),
      ),
    );

    // Thème Cupertino dark basé sur la palette dark
    final cupertinoDarkTheme = CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPalette.primary,
      scaffoldBackgroundColor: darkPalette.backgroundSecondary,
      barBackgroundColor: darkPalette.backgroundPrimary,
      textTheme: CupertinoTextThemeData(
        primaryColor: darkPalette.primary,
        textStyle: TextStyle(color: darkPalette.textPrimary),
      ),
    );

    // Observer l'état de chargement post-authentification pour l'overlay global
    final authState = ref.watch(authStateProvider);
    final isPostAuthLoading = authState.isPostAuthLoading;

    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: false,
        iosUseZeroPaddingForAppbarPlatformIcon: true,
      ),
      builder: (context) => PlatformTheme(
        themeMode: themeMode,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: cupertinoLightTheme,
        cupertinoDarkTheme: cupertinoDarkTheme,
        builder: (context) => Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              // L'app avec le router
              PlatformApp.router(
                title: 'Bahut',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  DefaultMaterialLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                routerConfig: router,
              ),
              // Overlay global de chargement post-authentification
              // S'affiche AU-DESSUS du router pour masquer la transition noire
              // Utilise des couleurs codées en dur car on est hors du contexte de l'app
              if (isPostAuthLoading)
                Positioned.fill(
                  child: Container(
                    color: themeMode == ThemeMode.dark
                        ? const Color(0xFF1A1A1A)
                        : Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: lightPalette.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              size: 44,
                              color: lightPalette.primary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: lightPalette.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Chargement de vos données...',
                            style: TextStyle(
                              fontSize: 15,
                              color: themeMode == ThemeMode.dark
                                  ? Colors.white70
                                  : Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

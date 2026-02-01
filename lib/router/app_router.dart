import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/qcm_screen.dart';
import '../features/biometric/presentation/screens/biometric_screen.dart';
import '../features/children/presentation/screens/child_selector_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/grades/presentation/screens/grades_screen.dart';
import '../features/averages/presentation/screens/averages_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/schedule/presentation/screens/schedule_screen.dart';
import '../features/homework/presentation/screens/homework_screen.dart';
import '../features/vie_scolaire/presentation/screens/vie_scolaire_screen.dart';
import '../features/statistics/presentation/screens/statistics_screen.dart';
import '../features/simulation/presentation/screens/simulation_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../shared/widgets/main_scaffold.dart';
import '../shared/widgets/loading_screen.dart';

/// Clé de navigation globale
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider pour le router
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/loading',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isProcessing = authState.isProcessing;
      final mfaRequired = authState.mfaRequired;
      final isOnLoading = state.matchedLocation == '/loading';
      final isLoggingIn = state.matchedLocation == '/login';
      final isOnQcm = state.matchedLocation == '/qcm';
      final isOnBiometric = state.matchedLocation == '/biometric';
      final isOnChildSelector = state.matchedLocation == '/children';

      // Si en cours de chargement (init ou login/QCM en cours), rester sur loading
      if (isProcessing && !isLoggingIn && !isOnQcm) {
        return '/loading';
      }

      // Si sur loading et plus en chargement, rediriger
      if (isOnLoading && !isProcessing) {
        if (mfaRequired) {
          return '/qcm';
        }
        if (isLoggedIn) {
          if (authState.biometricEnabled) {
            return '/biometric';
          }
          if (authState.hasMultipleChildren && authState.selectedChildId == null) {
            return '/children';
          }
          return '/dashboard';
        }
        return '/login';
      }

      // Si MFA requis, rediriger vers QCM
      if (mfaRequired && !isOnQcm) {
        return '/qcm';
      }

      // Si connecté (après login ou QCM réussi)
      if (isLoggedIn) {
        // Si sur login, rediriger vers biometric si activé
        if (isLoggingIn) {
          if (authState.biometricEnabled && !isOnBiometric) {
            return '/biometric';
          }
          if (authState.hasMultipleChildren && authState.selectedChildId == null) {
            return '/children';
          }
          return '/dashboard';
        }
        // Si sur QCM (MFA réussi), aller directement au dashboard (pas de biométrie après MFA)
        if (isOnQcm) {
          if (authState.hasMultipleChildren && authState.selectedChildId == null) {
            return '/children';
          }
          return '/dashboard';
        }
        return null;
      }

      // Si sur QCM mais pas de MFA requis et pas connecté, rediriger vers login
      if (isOnQcm && !mfaRequired) {
        return '/login';
      }

      // Si pas connecté et pas sur login/qcm/loading, rediriger vers login
      if (!isLoggingIn && !isOnQcm && !isOnLoading) {
        return '/login';
      }

      return null;
    },
    routes: [
      // Route Loading (écran de chargement)
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(
          message: 'Chargement...',
        ),
      ),

      // Route Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Route QCM (MFA verification)
      GoRoute(
        path: '/qcm',
        builder: (context, state) => const QcmScreen(),
      ),

      // Route Biometric
      GoRoute(
        path: '/biometric',
        builder: (context, state) => const BiometricScreen(),
      ),

      // Route Child Selector
      GoRoute(
        path: '/children',
        builder: (context, state) => const ChildSelectorScreen(),
      ),

      // Shell Route pour la navigation principale
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/grades',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GradesScreen(),
            ),
          ),
          GoRoute(
            path: '/schedule',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScheduleScreen(),
            ),
          ),
          GoRoute(
            path: '/homework',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeworkScreen(),
            ),
          ),
          GoRoute(
            path: '/vie-scolaire',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VieScolaireScreen(),
            ),
          ),
          GoRoute(
            path: '/averages',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AveragesScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: '/simulation',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SimulationScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

/// Routes de l'application
class AppRoutes {
  static const String loading = '/loading';
  static const String login = '/login';
  static const String qcm = '/qcm';
  static const String biometric = '/biometric';
  static const String children = '/children';
  static const String dashboard = '/dashboard';
  static const String grades = '/grades';
  static const String schedule = '/schedule';
  static const String homework = '/homework';
  static const String vieScolaire = '/vie-scolaire';
  static const String averages = '/averages';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String simulation = '/simulation';
}

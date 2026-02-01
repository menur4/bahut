import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_themes.dart';
import '../../core/theme/chanel_theme.dart';
import '../../core/theme/chanel_typography.dart';
import '../../core/theme/theme_provider.dart';
import '../../features/gamification/presentation/widgets/badge_celebration.dart';
import '../../router/app_router.dart';

/// Scaffold principal avec navigation bottom
/// Conforme aux HIG Apple (icônes adaptatives, haptic feedback, accessibilité)
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  DateTime? _lastBackPressTime;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/grades')) return 1;
    if (location.startsWith('/schedule')) return 2;
    if (location.startsWith('/homework')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    // Haptic feedback sur iOS (HIG)
    if (Platform.isIOS) {
      HapticFeedback.selectionClick();
    }

    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.grades);
        break;
      case 2:
        context.go(AppRoutes.schedule);
        break;
      case 3:
        context.go(AppRoutes.homework);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  Future<bool> _onWillPop(AppColorPalette palette) async {
    final now = DateTime.now();

    // Si on est sur le dashboard, demander confirmation pour quitter
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/dashboard')) {
      // Double tap rapide pour quitter (moins de 2 secondes)
      if (_lastBackPressTime != null &&
          now.difference(_lastBackPressTime!) < const Duration(seconds: 2)) {
        return true; // Quitter l'app
      }

      _lastBackPressTime = now;

      // Afficher la popup de confirmation
      final shouldExit = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: palette.backgroundCard,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
        ),
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing4),

                Icon(
                  Icons.exit_to_app,
                  size: 48,
                  color: palette.primary,
                ),
                const SizedBox(height: ChanelTheme.spacing3),

                Text(
                  'Quitter l\'application ?',
                  style: ChanelTypography.titleMedium.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing2),

                Text(
                  'Appuyez à nouveau pour confirmer',
                  style: ChanelTypography.bodySmall.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing6),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: ChanelTheme.spacing3),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Quitter'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      return shouldExit ?? false;
    }

    // Si on n'est pas sur le dashboard, revenir au dashboard
    context.go(AppRoutes.dashboard);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final selectedIndex = _calculateSelectedIndex(context);
    final isIOS = Platform.isIOS;

    // Taille d'icône conforme HIG (24pt standard pour tab bar)
    const double iconSize = 24.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(palette);
        if (shouldPop && mounted) {
          SystemNavigator.pop();
        }
      },
      child: BadgeCelebrationManager(
        child: PlatformScaffold(
          body: widget.child,
        bottomNavBar: PlatformNavBar(
        currentIndex: selectedIndex,
        itemChanged: (index) => _onItemTapped(context, index),
        material: (_, __) => MaterialNavBarData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: palette.backgroundCard,
          selectedItemColor: palette.primary,
          unselectedItemColor: palette.textTertiary,
          selectedLabelStyle: ChanelTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 11, // Minimum 11pt pour accessibilité
          ),
          unselectedLabelStyle: ChanelTypography.labelSmall.copyWith(
            fontSize: 11, // Minimum 11pt pour accessibilité
          ),
          elevation: 8,
        ),
        cupertino: (_, __) => CupertinoTabBarData(
          backgroundColor: palette.backgroundCard,
          activeColor: palette.primary,
          inactiveColor: palette.textTertiary,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.house : Icons.home_outlined,
              size: iconSize,
              semanticLabel: 'Accueil',
            ),
            activeIcon: Icon(
              isIOS ? CupertinoIcons.house_fill : Icons.home,
              size: iconSize,
              semanticLabel: 'Accueil, sélectionné',
            ),
            label: 'Accueil',
            tooltip: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.doc_text : Icons.assignment_outlined,
              size: iconSize,
              semanticLabel: 'Notes',
            ),
            activeIcon: Icon(
              isIOS ? CupertinoIcons.doc_text_fill : Icons.assignment,
              size: iconSize,
              semanticLabel: 'Notes, sélectionné',
            ),
            label: 'Notes',
            tooltip: 'Voir les notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.calendar : Icons.calendar_today_outlined,
              size: iconSize,
              semanticLabel: 'Planning',
            ),
            activeIcon: Icon(
              isIOS ? CupertinoIcons.calendar : Icons.calendar_today,
              size: iconSize,
              semanticLabel: 'Planning, sélectionné',
            ),
            label: 'Planning',
            tooltip: 'Emploi du temps',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.book : Icons.menu_book_outlined,
              size: iconSize,
              semanticLabel: 'Devoirs',
            ),
            activeIcon: Icon(
              isIOS ? CupertinoIcons.book_fill : Icons.menu_book,
              size: iconSize,
              semanticLabel: 'Devoirs, sélectionné',
            ),
            label: 'Devoirs',
            tooltip: 'Cahier de texte',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.person : Icons.person_outline,
              size: iconSize,
              semanticLabel: 'Profil',
            ),
            activeIcon: Icon(
              isIOS ? CupertinoIcons.person_fill : Icons.person,
              size: iconSize,
              semanticLabel: 'Profil, sélectionné',
            ),
            label: 'Profil',
            tooltip: 'Mon profil',
          ),
        ],
      ),
        ),
      ),
    );
  }
}

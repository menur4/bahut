import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/chanel_typography.dart';
import '../../core/theme/theme_provider.dart';
import '../../router/app_router.dart';

/// Scaffold principal avec navigation bottom
/// Conforme aux HIG Apple (icônes adaptatives, haptic feedback, accessibilité)
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final selectedIndex = _calculateSelectedIndex(context);
    final isIOS = Platform.isIOS;

    // Taille d'icône conforme HIG (24pt standard pour tab bar)
    const double iconSize = 24.0;

    return PlatformScaffold(
      body: child,
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
    );
  }
}

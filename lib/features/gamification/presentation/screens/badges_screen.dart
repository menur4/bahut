import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/badges_provider.dart';
import '../widgets/badges_grid.dart';

/// Écran complet des badges
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final badgesState = ref.watch(badgesProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'BADGES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
          ),
        ),
        trailingActions: [
          if (badgesState.unseenCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined,
                      color: palette.textSecondary),
                  onPressed: () {
                    ref.read(badgesProvider.notifier).markAllAsSeen();
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: palette.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${badgesState.unseenCount}',
                      style: ChanelTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: const BadgesGrid(),
    );
  }
}

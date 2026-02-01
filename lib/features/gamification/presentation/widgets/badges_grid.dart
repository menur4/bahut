import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/badge_model.dart';
import '../providers/badges_provider.dart';

/// Grille des badges avec catégories
class BadgesGrid extends ConsumerWidget {
  const BadgesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final badgesByCategory = ref.watch(badgesByCategoryProvider);
    final badgesState = ref.watch(badgesProvider);

    if (badgesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec compteur
          _BadgesHeader(
            unlockedCount: badgesState.unlockedCount,
            totalCount: badgesState.totalBadges,
            palette: palette,
          ),
          const SizedBox(height: ChanelTheme.spacing6),

          // Badges par catégorie
          ...BadgeCategory.values.map((category) {
            final badges = badgesByCategory[category] ?? [];
            if (badges.isEmpty) return const SizedBox.shrink();

            return _CategorySection(
              category: category,
              badges: badges,
              palette: palette,
              onBadgeTap: (badge, unlocked) {
                _showBadgeDetail(context, ref, badge, unlocked);
              },
            );
          }),
        ],
      ),
    );
  }

  void _showBadgeDetail(
    BuildContext context,
    WidgetRef ref,
    BadgeModel badge,
    bool unlocked,
  ) {
    final palette = ref.read(currentPaletteProvider);

    // Marquer comme vu si débloqué
    if (unlocked) {
      ref.read(badgesProvider.notifier).markAsSeen(badge.id);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ChanelTheme.radiusXl),
        ),
      ),
      builder: (context) => _BadgeDetailSheet(
        badge: badge,
        unlocked: unlocked,
        palette: palette,
        unlockedBadge: unlocked
            ? ref.read(badgesProvider).getUnlocked(badge.id)
            : null,
      ),
    );
  }
}

/// Header avec progression globale
class _BadgesHeader extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final AppColorPalette palette;

  const _BadgesHeader({
    required this.unlockedCount,
    required this.totalCount,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 32)),
              const SizedBox(width: ChanelTheme.spacing3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COLLECTION',
                    style: ChanelTypography.labelMedium.copyWith(
                      letterSpacing: ChanelTypography.letterSpacingWider,
                      color: palette.textTertiary,
                    ),
                  ),
                  Text(
                    '$unlockedCount / $totalCount badges',
                    style: ChanelTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: ChanelTheme.spacing3),
          ClipRRect(
            borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: palette.backgroundTertiary,
              valueColor: AlwaysStoppedAnimation(palette.primary),
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% complété',
            style: ChanelTypography.labelSmall.copyWith(
              color: palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section d'une catégorie de badges
class _CategorySection extends StatelessWidget {
  final BadgeCategory category;
  final List<({BadgeModel badge, bool unlocked})> badges;
  final AppColorPalette palette;
  final void Function(BadgeModel badge, bool unlocked) onBadgeTap;

  const _CategorySection({
    required this.category,
    required this.badges,
    required this.palette,
    required this.onBadgeTap,
  });

  String get _categoryIcon {
    switch (category) {
      case BadgeCategory.performance:
        return '📈';
      case BadgeCategory.progression:
        return '🚀';
      case BadgeCategory.regularite:
        return '🔥';
      case BadgeCategory.decouverte:
        return '🎯';
      case BadgeCategory.excellence:
        return '👑';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlockedInCategory = badges.where((b) => b.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header catégorie
        Row(
          children: [
            Text(_categoryIcon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: ChanelTheme.spacing2),
            Text(
              category.label.toUpperCase(),
              style: ChanelTypography.labelMedium.copyWith(
                letterSpacing: ChanelTypography.letterSpacingWider,
                color: palette.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '$unlockedInCategory/${badges.length}',
              style: ChanelTypography.labelSmall.copyWith(
                color: palette.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: ChanelTheme.spacing3),

        // Grille de badges
        Wrap(
          spacing: ChanelTheme.spacing3,
          runSpacing: ChanelTheme.spacing3,
          children: badges.map((item) {
            return _BadgeItem(
              badge: item.badge,
              unlocked: item.unlocked,
              palette: palette,
              onTap: () => onBadgeTap(item.badge, item.unlocked),
            );
          }).toList(),
        ),

        const SizedBox(height: ChanelTheme.spacing6),
      ],
    );
  }
}

/// Item de badge individuel
class _BadgeItem extends StatelessWidget {
  final BadgeModel badge;
  final bool unlocked;
  final AppColorPalette palette;
  final VoidCallback onTap;

  const _BadgeItem({
    required this.badge,
    required this.unlocked,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(ChanelTheme.spacing2),
        decoration: BoxDecoration(
          color: unlocked
              ? badge.rarity.color.withOpacity(0.1)
              : palette.backgroundTertiary,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          border: Border.all(
            color: unlocked ? badge.rarity.color : palette.borderLight,
            width: unlocked ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Icône
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: unlocked
                    ? badge.rarity.color.withOpacity(0.2)
                    : palette.backgroundSecondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  unlocked ? badge.icon : '🔒',
                  style: TextStyle(
                    fontSize: unlocked ? 24 : 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing1),

            // Nom
            Text(
              unlocked ? badge.name : '???',
              style: ChanelTypography.labelSmall.copyWith(
                color: unlocked ? palette.textPrimary : palette.textMuted,
                fontWeight: unlocked ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Rareté
            if (unlocked) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: badge.rarity.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
                ),
                child: Text(
                  badge.rarity.label,
                  style: ChanelTypography.labelSmall.copyWith(
                    fontSize: 8,
                    color: badge.rarity.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sheet de détail d'un badge
class _BadgeDetailSheet extends StatelessWidget {
  final BadgeModel badge;
  final bool unlocked;
  final AppColorPalette palette;
  final UnlockedBadge? unlockedBadge;

  const _BadgeDetailSheet({
    required this.badge,
    required this.unlocked,
    required this.palette,
    this.unlockedBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ChanelTheme.spacing6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barre de poignée
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: palette.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing6),

          // Grande icône
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: unlocked
                  ? badge.rarity.color.withOpacity(0.15)
                  : palette.backgroundTertiary,
              shape: BoxShape.circle,
              border: Border.all(
                color: unlocked ? badge.rarity.color : palette.borderLight,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                unlocked ? badge.icon : '🔒',
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing4),

          // Nom
          Text(
            unlocked ? badge.name : 'Badge mystère',
            style: ChanelTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing1),

          // Rareté
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: badge.rarity.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
            ),
            child: Text(
              badge.rarity.label,
              style: ChanelTypography.labelMedium.copyWith(
                color: badge.rarity.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing4),

          // Description
          Text(
            badge.description,
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // Date de déblocage
          if (unlocked && unlockedBadge != null) ...[
            const SizedBox(height: ChanelTheme.spacing4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: palette.success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Débloqué le ${_formatDate(unlockedBadge!.unlockedAt)}',
                  style: ChanelTypography.labelMedium.copyWith(
                    color: palette.success,
                  ),
                ),
              ],
            ),
          ],

          // Indice si verrouillé
          if (!unlocked && badge.progressDescription != null) ...[
            const SizedBox(height: ChanelTheme.spacing4),
            Container(
              padding: const EdgeInsets.all(ChanelTheme.spacing3),
              decoration: BoxDecoration(
                color: palette.backgroundTertiary,
                borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: palette.warning,
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                  Expanded(
                    child: Text(
                      badge.progressDescription!,
                      style: ChanelTypography.bodySmall.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: ChanelTheme.spacing4),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

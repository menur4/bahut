import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_themes.dart';
import '../../core/theme/chanel_theme.dart';
import '../../core/theme/theme_provider.dart';

/// Widget Skeleton de base avec animation de shimmer
class Skeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCircle;
  final AppColorPalette? palette;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.isCircle = false,
    this.palette,
  });

  /// Crée un skeleton rectangulaire
  const Skeleton.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.palette,
  }) : isCircle = false;

  /// Crée un skeleton circulaire
  const Skeleton.circular({
    super.key,
    required double size,
    this.palette,
  })  : width = size,
        height = size,
        borderRadius = 0,
        isCircle = true;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette ?? AppThemes.classique;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                p.backgroundTertiary,
                p.backgroundSecondary,
                p.backgroundTertiary,
              ],
              stops: [
                0.0,
                0.5 + _animation.value * 0.3,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton Consumer qui utilise automatiquement la palette du thème
class SkeletonWithTheme extends ConsumerWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCircle;

  const SkeletonWithTheme({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    return Skeleton(
      width: width,
      height: height,
      borderRadius: borderRadius,
      isCircle: isCircle,
      palette: palette,
    );
  }
}

/// Skeleton pour une ligne de texte
class SkeletonText extends StatelessWidget {
  final double width;
  final double height;
  final AppColorPalette? palette;

  const SkeletonText({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: 4,
      palette: palette,
    );
  }
}

/// Skeleton pour un avatar
class SkeletonAvatar extends StatelessWidget {
  final double size;
  final AppColorPalette? palette;

  const SkeletonAvatar({
    super.key,
    this.size = 48,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton.circular(
      size: size,
      palette: palette,
    );
  }
}

/// Skeleton pour une carte de note
class SkeletonGradeCard extends StatelessWidget {
  final AppColorPalette? palette;

  const SkeletonGradeCard({super.key, this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: p.borderLight),
      ),
      child: Row(
        children: [
          // Note skeleton
          Skeleton(
            width: 52,
            height: 52,
            borderRadius: ChanelTheme.radiusMd,
            palette: p,
          ),
          const SizedBox(width: ChanelTheme.spacing3),
          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 120, height: 18, palette: p),
                const SizedBox(height: 8),
                SkeletonText(width: 180, height: 14, palette: p),
                const SizedBox(height: 4),
                SkeletonText(width: 80, height: 12, palette: p),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton pour une carte de statistique
class SkeletonStatCard extends StatelessWidget {
  final AppColorPalette? palette;

  const SkeletonStatCard({super.key, this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Container(
      constraints: const BoxConstraints(minHeight: 100, minWidth: 100),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: p.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icône
          Skeleton(
            width: 44,
            height: 44,
            borderRadius: ChanelTheme.radiusMd,
            palette: p,
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          // Valeur
          SkeletonText(width: 60, height: 32, palette: p),
          // Label
          SkeletonText(width: 80, height: 14, palette: p),
        ],
      ),
    );
  }
}

/// Skeleton pour un élément de liste
class SkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final bool hasSubtitle;
  final AppColorPalette? palette;

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.hasSubtitle = true,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChanelTheme.spacing4,
        vertical: ChanelTheme.spacing3,
      ),
      child: Row(
        children: [
          if (hasLeading) ...[
            Skeleton(
              width: 44,
              height: 44,
              borderRadius: ChanelTheme.radiusSm,
              palette: p,
            ),
            const SizedBox(width: ChanelTheme.spacing3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 140, height: 16, palette: p),
                if (hasSubtitle) ...[
                  const SizedBox(height: 6),
                  SkeletonText(width: 200, height: 14, palette: p),
                ],
              ],
            ),
          ),
          if (hasTrailing)
            Skeleton(
              width: 24,
              height: 24,
              borderRadius: 4,
              palette: p,
            ),
        ],
      ),
    );
  }
}

/// Skeleton pour une carte de devoir
class SkeletonHomeworkCard extends StatelessWidget {
  final AppColorPalette? palette;

  const SkeletonHomeworkCard({super.key, this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: p.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Skeleton(
                width: 36,
                height: 36,
                borderRadius: ChanelTheme.radiusSm,
                palette: p,
              ),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 100, height: 16, palette: p),
                    const SizedBox(height: 4),
                    SkeletonText(width: 60, height: 12, palette: p),
                  ],
                ),
              ),
              Skeleton(
                width: 24,
                height: 24,
                borderRadius: 12,
                palette: p,
              ),
            ],
          ),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonText(height: 14, palette: p),
          const SizedBox(height: 4),
          SkeletonText(width: 200, height: 14, palette: p),
        ],
      ),
    );
  }
}

/// Skeleton pour une section du tableau de bord
class SkeletonDashboardSection extends StatelessWidget {
  final String title;
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final AppColorPalette? palette;

  const SkeletonDashboardSection({
    super.key,
    required this.title,
    this.itemCount = 3,
    required this.itemBuilder,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing4),
          child: SkeletonText(width: 120, height: 20, palette: p),
        ),
        const SizedBox(height: ChanelTheme.spacing3),
        // Items
        ...List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
            child: itemBuilder(index),
          ),
        ),
      ],
    );
  }
}

/// Liste de skeletons pour un écran de chargement complet
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry padding;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(ChanelTheme.spacing4),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: ChanelTheme.spacing3),
      itemBuilder: itemBuilder,
    );
  }
}

/// Skeleton pour l'écran des notes
class SkeletonGradesScreen extends ConsumerWidget {
  const SkeletonGradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              Expanded(child: SkeletonStatCard(palette: palette)),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(child: SkeletonStatCard(palette: palette)),
            ],
          ),
          const SizedBox(height: ChanelTheme.spacing6),

          // Section header
          SkeletonText(width: 140, height: 20, palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),

          // Grade cards
          SkeletonGradeCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonGradeCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonGradeCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonGradeCard(palette: palette),
        ],
      ),
    );
  }
}

/// Skeleton pour l'écran des devoirs
class SkeletonHomeworkScreen extends ConsumerWidget {
  const SkeletonHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          SkeletonText(width: 100, height: 24, palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),

          // Homework cards
          SkeletonHomeworkCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonHomeworkCard(palette: palette),

          const SizedBox(height: ChanelTheme.spacing6),

          // Another date
          SkeletonText(width: 120, height: 24, palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),

          SkeletonHomeworkCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonHomeworkCard(palette: palette),
          const SizedBox(height: ChanelTheme.spacing3),
          SkeletonHomeworkCard(palette: palette),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/models/badge_model.dart';
import '../providers/badges_provider.dart';

/// Overlay de célébration pour un nouveau badge
class BadgeCelebrationOverlay extends ConsumerStatefulWidget {
  final BadgeModel badge;
  final VoidCallback onDismiss;

  const BadgeCelebrationOverlay({
    super.key,
    required this.badge,
    required this.onDismiss,
  });

  @override
  ConsumerState<BadgeCelebrationOverlay> createState() =>
      _BadgeCelebrationOverlayState();
}

class _BadgeCelebrationOverlayState
    extends ConsumerState<BadgeCelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particlesController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation d'apparition du badge
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeIn,
    );

    // Animation des particules
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Démarrer les animations
    _scaleController.forward();
    _particlesController.repeat();

    // Marquer le badge comme vu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(badgesProvider.notifier).markAsSeen(widget.badge.id);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Material(
        color: Colors.black54,
        child: Stack(
          children: [
            // Particules animées
            AnimatedBuilder(
              animation: _particlesController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlesPainter(
                    progress: _particlesController.value,
                    color: widget.badge.rarity.color,
                  ),
                  size: MediaQuery.of(context).size,
                );
              },
            ),

            // Contenu central
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _BadgeCard(
                    badge: widget.badge,
                    palette: palette,
                  ),
                ),
              ),
            ),

            // Texte "Touchez pour continuer"
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Touchez pour continuer',
                  style: ChanelTypography.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte du badge débloqué
class _BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final AppColorPalette palette;

  const _BadgeCard({
    required this.badge,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ChanelTheme.spacing6),
      padding: const EdgeInsets.all(ChanelTheme.spacing6),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: badge.rarity.color.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre
          Text(
            '🎉 NOUVEAU BADGE !',
            style: ChanelTypography.labelMedium.copyWith(
              letterSpacing: ChanelTypography.letterSpacingWider,
              color: badge.rarity.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing6),

          // Grande icône avec glow
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: badge.rarity.color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.rarity.color,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: badge.rarity.color.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                badge.icon,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing4),

          // Nom du badge
          Text(
            badge.name,
            style: ChanelTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChanelTheme.spacing2),

          // Rareté
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: badge.rarity.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
              border: Border.all(
                color: badge.rarity.color.withOpacity(0.3),
              ),
            ),
            child: Text(
              badge.rarity.label.toUpperCase(),
              style: ChanelTypography.labelMedium.copyWith(
                color: badge.rarity.color,
                fontWeight: FontWeight.w600,
                letterSpacing: ChanelTypography.letterSpacingWider,
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
        ],
      ),
    );
  }
}

/// Painter pour les particules de célébration
class _ParticlesPainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_Particle> particles;

  _ParticlesPainter({
    required this.progress,
    required this.color,
  }) : particles = List.generate(30, (index) => _Particle(index));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final adjustedProgress = (progress + particle.delay) % 1.0;
      final opacity = (1 - adjustedProgress).clamp(0.0, 1.0);

      if (opacity <= 0) continue;

      final distance = adjustedProgress * 200;
      final x = center.dx + cos(particle.angle) * distance;
      final y = center.dy + sin(particle.angle) * distance - adjustedProgress * 100;

      final paint = Paint()
        ..color = color.withOpacity(opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - adjustedProgress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Particule individuelle
class _Particle {
  final double angle;
  final double delay;
  final double size;

  _Particle(int index)
      : angle = (index * 12.0) * pi / 180,
        delay = (index * 0.033) % 1.0,
        size = 3.0 + (index % 4);
}

/// Widget pour afficher les célébrations de badges
class BadgeCelebrationManager extends ConsumerStatefulWidget {
  final Widget child;

  const BadgeCelebrationManager({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<BadgeCelebrationManager> createState() =>
      _BadgeCelebrationManagerState();
}

class _BadgeCelebrationManagerState
    extends ConsumerState<BadgeCelebrationManager> {
  BadgeModel? _currentBadge;

  @override
  Widget build(BuildContext context) {
    // Écouter les nouveaux badges
    ref.listen(newlyUnlockedBadgesProvider, (previous, next) {
      if (next.isNotEmpty && _currentBadge == null) {
        setState(() {
          _currentBadge = next.first;
        });
      }
    });

    return Stack(
      children: [
        widget.child,
        if (_currentBadge != null)
          BadgeCelebrationOverlay(
            badge: _currentBadge!,
            onDismiss: () {
              setState(() {
                _currentBadge = null;
              });
              // Effacer les badges nouvellement débloqués
              ref.read(badgesProvider.notifier).clearNewlyUnlocked();
            },
          ),
      ],
    );
  }
}

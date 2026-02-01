import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/theme/app_themes.dart';
import '../../core/theme/chanel_theme.dart';

/// Widget flip card avec animation 3D
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Duration duration;
  final VoidCallback? onFlip;
  final bool flipOnTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 400),
    this.onFlip,
    this.flipOnTap = true,
  });

  @override
  State<FlipCard> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Retourne la carte
  void flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
    widget.onFlip?.call();
  }

  /// Affiche le côté avant
  void showFront() {
    if (!_showFront) {
      _controller.reverse();
      setState(() {
        _showFront = true;
      });
    }
  }

  /// Affiche le côté arrière
  void showBack() {
    if (_showFront) {
      _controller.forward();
      setState(() {
        _showFront = false;
      });
    }
  }

  bool get isFrontVisible => _showFront;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flipOnTap ? flip : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            child: isFront
                ? widget.front
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}

/// Carte de statistique pour le dashboard
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? accentColor;
  final VoidCallback? onTap;
  final AppColorPalette? palette;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor,
    this.onTap,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: p.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          border: Border.all(color: p.borderLight),
          boxShadow: [
            BoxShadow(
              color: p.textPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (accentColor ?? p.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor ?? p.primary,
                    size: 18,
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: p.textMuted,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: p.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing1),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: p.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: ChanelTheme.spacing1),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: p.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Carte d'action rapide pour le dashboard
class DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final AppColorPalette? palette;

  const DashboardActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
    this.trailing,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: p.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          border: Border.all(color: p.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (iconColor ?? p.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: iconColor ?? p.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: ChanelTheme.spacing3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: p.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: p.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: p.textMuted,
                ),
          ],
        ),
      ),
    );
  }
}

/// Carte flip pour afficher un résumé avec détails au dos
class FlipSummaryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String mainValue;
  final String? subtitle;
  final Color? accentColor;
  final Widget backContent;
  final String? backTitle;
  final String? flipHint;
  final AppColorPalette? palette;

  const FlipSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.mainValue,
    this.subtitle,
    this.accentColor,
    required this.backContent,
    this.backTitle,
    this.flipHint,
    this.palette,
  });

  @override
  State<FlipSummaryCard> createState() => _FlipSummaryCardState();
}

class _FlipSummaryCardState extends State<FlipSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  AppColorPalette get _palette => widget.palette ?? AppThemes.classique;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront ? _buildFront() : _buildBack(angle),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    final color = widget.accentColor ?? _palette.primary;
    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: _palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: _palette.borderLight),
        boxShadow: [
          BoxShadow(
            color: _palette.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
                child: Icon(widget.icon, color: color, size: 20),
              ),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(
                child: Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _palette.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Icon(
                Icons.touch_app,
                size: 16,
                color: _palette.textMuted,
              ),
            ],
          ),
          const Spacer(),
          Text(
            widget.mainValue,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: _palette.textPrimary,
              letterSpacing: -1,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: ChanelTheme.spacing1),
            Text(
              widget.subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: _palette.textTertiary,
              ),
            ),
          ],
          if (widget.flipHint != null) ...[
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              widget.flipHint!,
              style: TextStyle(
                fontSize: 11,
                color: _palette.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBack(double angle) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Container(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: _palette.backgroundSecondary,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          border: Border.all(color: _palette.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  (widget.backTitle ?? widget.title).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _palette.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.close,
                  size: 18,
                  color: _palette.textMuted,
                ),
              ],
            ),
            const SizedBox(height: ChanelTheme.spacing3),
            Expanded(child: widget.backContent),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_themes.dart';
import '../../core/theme/chanel_theme.dart';
import '../../core/theme/chanel_typography.dart';

/// Carte de statistique accessible conforme aux HIG Apple
/// - Zone de toucher minimum 44pt
/// - Labels sémantiques pour VoiceOver
/// - Haptic feedback sur iOS
/// - Icônes adaptatives (Cupertino sur iOS)
class AccessibleStatCard extends StatelessWidget {
  final IconData icon;
  final IconData? cupertinoIcon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? accentColor;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final AppColorPalette? palette;

  const AccessibleStatCard({
    super.key,
    required this.icon,
    this.cupertinoIcon,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor,
    this.onTap,
    this.semanticLabel,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    final isIOS = Platform.isIOS;
    final effectiveIcon = isIOS ? (cupertinoIcon ?? icon) : icon;
    final color = accentColor ?? p.primary;

    // Construction du label sémantique pour VoiceOver
    final effectiveSemanticLabel = semanticLabel ??
        '$label: $value${subtitle != null ? ', $subtitle' : ''}';

    Widget card = Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: 100,
      ),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
        border: Border.all(color: p.borderLight),
        boxShadow: [
          BoxShadow(
            color: p.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icône avec zone minimum 44pt
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
            ),
            child: Icon(
              effectiveIcon,
              color: color,
              size: 22,
              semanticLabel: null, // Exclu car couvert par le Semantics parent
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          // Valeur principale
          Text(
            value,
            style: ChanelTypography.headlineLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Label
          Text(
            label,
            style: ChanelTypography.bodySmall.copyWith(
              color: p.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Sous-titre optionnel
          if (subtitle != null)
            Text(
              subtitle!,
              style: ChanelTypography.labelSmall.copyWith(
                color: p.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isIOS) {
              HapticFeedback.lightImpact();
            }
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
          child: card,
        ),
      );
    }

    // Wrapper Semantics pour VoiceOver
    return Semantics(
      button: onTap != null,
      label: effectiveSemanticLabel,
      hint: onTap != null ? 'Double-tap pour voir les détails' : null,
      enabled: onTap != null,
      child: card,
    );
  }
}

/// Carte d'action accessible pour le dashboard
class AccessibleActionCard extends StatelessWidget {
  final IconData icon;
  final IconData? cupertinoIcon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final AppColorPalette? palette;

  const AccessibleActionCard({
    super.key,
    required this.icon,
    this.cupertinoIcon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
    this.semanticLabel,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    final isIOS = Platform.isIOS;
    final effectiveIcon = isIOS ? (cupertinoIcon ?? icon) : icon;
    final color = iconColor ?? p.primary;

    final effectiveSemanticLabel = semanticLabel ?? '$title, $subtitle';

    return Semantics(
      button: onTap != null,
      label: effectiveSemanticLabel,
      hint: onTap != null ? 'Double-tap pour ouvrir' : null,
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  if (isIOS) {
                    HapticFeedback.lightImpact();
                  }
                  onTap?.call();
                }
              : null,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 64, // Au moins 64pt pour touch target confortable
            ),
            padding: const EdgeInsets.all(ChanelTheme.spacing4),
            decoration: BoxDecoration(
              color: p.backgroundCard,
              borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
              border: Border.all(color: p.borderLight),
            ),
            child: Row(
              children: [
                // Icône avec zone minimum 44pt
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Icon(
                    effectiveIcon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: ChanelTheme.spacing3),
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: ChanelTypography.titleSmall.copyWith(
                          color: p.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: ChanelTypography.bodySmall.copyWith(
                          color: p.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  isIOS ? CupertinoIcons.chevron_right : Icons.chevron_right,
                  color: p.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Liste accessible avec section extensible
class AccessibleExpandableSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget child;
  final String? semanticLabel;
  final AppColorPalette? palette;

  const AccessibleExpandableSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.child,
    this.semanticLabel,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    final isIOS = Platform.isIOS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête cliquable
        Semantics(
          button: true,
          label: semanticLabel ?? title,
          hint: isExpanded
              ? 'Section développée, double-tap pour réduire'
              : 'Section réduite, double-tap pour développer',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isIOS) {
                  HapticFeedback.selectionClick();
                }
                onToggle();
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: ChanelTheme.spacing4,
                  vertical: ChanelTheme.spacing3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: ChanelTypography.titleMedium.copyWith(
                          color: p.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isIOS
                            ? CupertinoIcons.chevron_down
                            : Icons.keyboard_arrow_down,
                        color: p.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Contenu animé
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: child,
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

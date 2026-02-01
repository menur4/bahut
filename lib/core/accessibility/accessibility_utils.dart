import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utilitaires pour l'accessibilité et la conformité HIG d'Apple
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Taille minimum de zone de toucher selon les HIG (44pt)
  static const double minTouchTarget = 44.0;

  /// Retourne l'icône appropriée selon la plateforme (SF Symbols sur iOS)
  static IconData adaptiveIcon({
    required IconData materialIcon,
    required IconData cupertinoIcon,
  }) {
    return Platform.isIOS ? cupertinoIcon : materialIcon;
  }

  /// Déclenche un feedback haptique léger
  static void lightHaptic() {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
  }

  /// Déclenche un feedback haptique moyen
  static void mediumHaptic() {
    if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Déclenche un feedback haptique fort
  static void heavyHaptic() {
    if (Platform.isIOS) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Déclenche un feedback de sélection
  static void selectionHaptic() {
    if (Platform.isIOS) {
      HapticFeedback.selectionClick();
    }
  }
}

/// Extension pour appliquer le scaling Dynamic Type aux TextStyles
extension DynamicTypeTextStyle on TextStyle {
  /// Applique le facteur d'échelle du texte système (Dynamic Type)
  TextStyle withDynamicType(BuildContext context) {
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    // Limite le scaling pour éviter les layouts cassés
    final limitedScale = textScaleFactor.clamp(0.8, 1.5);

    return copyWith(
      fontSize: (fontSize ?? 14) * limitedScale,
    );
  }
}

/// Widget wrapper pour garantir une zone de toucher minimum de 44pt
class MinimumTouchTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? tooltip;
  final bool excludeFromSemantics;

  const MinimumTouchTarget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.tooltip,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = SizedBox(
      width: AccessibilityUtils.minTouchTarget,
      height: AccessibilityUtils.minTouchTarget,
      child: Center(child: child),
    );

    if (onTap != null) {
      result = GestureDetector(
        onTap: () {
          AccessibilityUtils.lightHaptic();
          onTap?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    if (!excludeFromSemantics && (semanticLabel != null || onTap != null)) {
      result = Semantics(
        button: onTap != null,
        label: semanticLabel,
        enabled: onTap != null,
        onTap: onTap,
        child: result,
      );
    }

    if (tooltip != null) {
      result = Tooltip(
        message: tooltip!,
        child: result,
      );
    }

    return result;
  }
}

/// Widget bouton accessible avec haptic feedback et semantics
class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final bool useLightHaptic;

  const AccessibleButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.semanticLabel,
    this.tooltip,
    this.padding,
    this.useLightHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onPressed != null,
      onTap: onPressed,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed != null
                ? () {
                    if (useLightHaptic) {
                      AccessibilityUtils.lightHaptic();
                    }
                    onPressed?.call();
                  }
                : null,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: AccessibilityUtils.minTouchTarget,
                minHeight: AccessibilityUtils.minTouchTarget,
              ),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(8),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget pour les éléments expandables avec semantics appropriées
class AccessibleExpandable extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String label;
  final String? expandedHint;
  final String? collapsedHint;

  const AccessibleExpandable({
    super.key,
    required this.child,
    required this.isExpanded,
    required this.onToggle,
    required this.label,
    this.expandedHint,
    this.collapsedHint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: isExpanded
          ? (expandedHint ?? 'Double-tap pour réduire')
          : (collapsedHint ?? 'Double-tap pour développer'),
      onTap: () {
        AccessibilityUtils.selectionHaptic();
        onToggle();
      },
      child: MergeSemantics(
        child: child,
      ),
    );
  }
}

/// Extension pour créer des icônes adaptatives facilement
extension AdaptiveIcons on IconData {
  /// Retourne une icône adaptative (Material sur Android, Cupertino sur iOS)
  static IconData adaptive({
    required IconData material,
    required IconData cupertino,
  }) {
    return AccessibilityUtils.adaptiveIcon(
      materialIcon: material,
      cupertinoIcon: cupertino,
    );
  }
}

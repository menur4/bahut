import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/haptic_service.dart';
import '../../core/theme/app_themes.dart';

/// Switch avec retour haptique automatique
class HapticSwitch extends ConsumerWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final AppColorPalette? palette;

  const HapticSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.palette,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = palette ?? AppThemes.classique;

    return PlatformSwitch(
      value: value,
      onChanged: onChanged != null
          ? (newValue) {
              ref.read(hapticServiceProvider).selectionClick();
              onChanged!(newValue);
            }
          : null,
      material: (_, __) => MaterialSwitchData(
        activeColor: activeColor ?? p.primary,
      ),
    );
  }
}

/// Bouton avec retour haptique automatique
class HapticButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final HapticType hapticType;
  final ButtonStyle? style;

  const HapticButton({
    super.key,
    this.onPressed,
    required this.child,
    this.hapticType = HapticType.lightImpact,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: onPressed != null
          ? () {
              ref.read(hapticServiceProvider).feedback(hapticType);
              onPressed!();
            }
          : null,
      style: style,
      child: child,
    );
  }
}

/// TextButton avec retour haptique automatique
class HapticTextButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final HapticType hapticType;
  final ButtonStyle? style;

  const HapticTextButton({
    super.key,
    this.onPressed,
    required this.child,
    this.hapticType = HapticType.lightImpact,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: onPressed != null
          ? () {
              ref.read(hapticServiceProvider).feedback(hapticType);
              onPressed!();
            }
          : null,
      style: style,
      child: child,
    );
  }
}

/// IconButton avec retour haptique automatique
class HapticIconButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final HapticType hapticType;
  final double? iconSize;
  final Color? color;
  final String? tooltip;

  const HapticIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.hapticType = HapticType.lightImpact,
    this.iconSize,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: onPressed != null
          ? () {
              ref.read(hapticServiceProvider).feedback(hapticType);
              onPressed!();
            }
          : null,
      icon: icon,
      iconSize: iconSize,
      color: color,
      tooltip: tooltip,
    );
  }
}

/// InkWell avec retour haptique automatique
class HapticInkWell extends ConsumerWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final HapticType tapHaptic;
  final HapticType longPressHaptic;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  const HapticInkWell({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.tapHaptic = HapticType.lightImpact,
    this.longPressHaptic = HapticType.mediumImpact,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap != null
          ? () {
              ref.read(hapticServiceProvider).feedback(tapHaptic);
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              ref.read(hapticServiceProvider).feedback(longPressHaptic);
              onLongPress!();
            }
          : null,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

/// GestureDetector avec retour haptique automatique
class HapticGestureDetector extends ConsumerWidget {
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final HapticType tapHaptic;
  final HapticType longPressHaptic;
  final HitTestBehavior behavior;

  const HapticGestureDetector({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.tapHaptic = HapticType.lightImpact,
    this.longPressHaptic = HapticType.mediumImpact,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap != null
          ? () {
              ref.read(hapticServiceProvider).feedback(tapHaptic);
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              ref.read(hapticServiceProvider).feedback(longPressHaptic);
              onLongPress!();
            }
          : null,
      child: child,
    );
  }
}

/// ListTile avec retour haptique automatique
class HapticListTile extends ConsumerWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HapticType tapHaptic;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;

  const HapticListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.tapHaptic = HapticType.lightImpact,
    this.enabled = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      enabled: enabled,
      contentPadding: contentPadding,
      onTap: onTap != null
          ? () {
              ref.read(hapticServiceProvider).feedback(tapHaptic);
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              ref.read(hapticServiceProvider).feedback(HapticType.mediumImpact);
              onLongPress!();
            }
          : null,
    );
  }
}

/// Slider avec retour haptique sur les changements de valeur
class HapticSlider extends ConsumerStatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final String? label;

  const HapticSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.label,
  });

  @override
  ConsumerState<HapticSlider> createState() => _HapticSliderState();
}

class _HapticSliderState extends ConsumerState<HapticSlider> {
  double? _lastHapticValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.value,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      label: widget.label,
      onChanged: widget.onChanged != null
          ? (newValue) {
              // Haptic feedback quand on passe une division
              if (widget.divisions != null) {
                final step = (widget.max - widget.min) / widget.divisions!;
                final currentStep = ((newValue - widget.min) / step).round();
                final lastStep = _lastHapticValue != null
                    ? ((_lastHapticValue! - widget.min) / step).round()
                    : null;

                if (lastStep == null || currentStep != lastStep) {
                  ref.read(hapticServiceProvider).selectionClick();
                  _lastHapticValue = newValue;
                }
              }
              widget.onChanged!(newValue);
            }
          : null,
      onChangeEnd: widget.onChangeEnd,
    );
  }
}

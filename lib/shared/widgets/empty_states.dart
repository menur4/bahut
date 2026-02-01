import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_themes.dart';
import '../../core/theme/chanel_theme.dart';
import '../../core/theme/chanel_typography.dart';
import '../../core/theme/theme_provider.dart';

/// Types d'états vides prédéfinis
enum EmptyStateType {
  noGrades,
  noHomework,
  noSchedule,
  noMessages,
  noResults,
  offline,
  error,
  success,
  allDone,
}

/// Configuration pour chaque type d'état vide
class _EmptyStateConfig {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color Function(AppColorPalette) iconColor;

  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });
}

/// Widget d'état vide réutilisable avec animations
class EmptyStateWidget extends ConsumerStatefulWidget {
  final EmptyStateType? type;
  final IconData? customIcon;
  final String? customTitle;
  final String? customSubtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final bool animate;

  const EmptyStateWidget({
    super.key,
    this.type,
    this.customIcon,
    this.customTitle,
    this.customSubtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.animate = true,
  });

  /// Constructeur pour état "Aucune note"
  const EmptyStateWidget.noGrades({
    super.key,
    this.actionLabel,
    this.onAction,
  })  : type = EmptyStateType.noGrades,
        customIcon = null,
        customTitle = null,
        customSubtitle = null,
        iconColor = null,
        animate = true;

  /// Constructeur pour état "Aucun devoir"
  const EmptyStateWidget.noHomework({
    super.key,
    this.actionLabel,
    this.onAction,
  })  : type = EmptyStateType.noHomework,
        customIcon = null,
        customTitle = null,
        customSubtitle = null,
        iconColor = null,
        animate = true;

  /// Constructeur pour état "Tout est fait"
  const EmptyStateWidget.allDone({
    super.key,
    this.actionLabel,
    this.onAction,
  })  : type = EmptyStateType.allDone,
        customIcon = null,
        customTitle = null,
        customSubtitle = null,
        iconColor = null,
        animate = true;

  /// Constructeur pour état hors-ligne
  const EmptyStateWidget.offline({
    super.key,
    this.actionLabel,
    this.onAction,
  })  : type = EmptyStateType.offline,
        customIcon = null,
        customTitle = null,
        customSubtitle = null,
        iconColor = null,
        animate = true;

  /// Constructeur pour état d'erreur
  const EmptyStateWidget.error({
    super.key,
    this.customSubtitle,
    this.actionLabel,
    this.onAction,
  })  : type = EmptyStateType.error,
        customIcon = null,
        customTitle = null,
        iconColor = null,
        animate = true;

  @override
  ConsumerState<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends ConsumerState<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static final Map<EmptyStateType, _EmptyStateConfig> _configs = {
    EmptyStateType.noGrades: _EmptyStateConfig(
      icon: Icons.school_outlined,
      title: 'Aucune note',
      subtitle: 'Les notes apparaîtront ici une fois disponibles',
      iconColor: (p) => p.info,
    ),
    EmptyStateType.noHomework: _EmptyStateConfig(
      icon: Icons.assignment_outlined,
      title: 'Aucun devoir',
      subtitle: 'Vous n\'avez pas de devoirs pour le moment',
      iconColor: (p) => p.primary,
    ),
    EmptyStateType.noSchedule: _EmptyStateConfig(
      icon: Icons.calendar_today_outlined,
      title: 'Pas de cours',
      subtitle: 'Aucun cours prévu pour cette journée',
      iconColor: (p) => p.secondary,
    ),
    EmptyStateType.noMessages: _EmptyStateConfig(
      icon: Icons.mail_outline,
      title: 'Aucun message',
      subtitle: 'Votre boîte de réception est vide',
      iconColor: (p) => p.info,
    ),
    EmptyStateType.noResults: _EmptyStateConfig(
      icon: Icons.search_off,
      title: 'Aucun résultat',
      subtitle: 'Essayez avec d\'autres termes de recherche',
      iconColor: (p) => p.textMuted,
    ),
    EmptyStateType.offline: _EmptyStateConfig(
      icon: Icons.cloud_off_outlined,
      title: 'Hors connexion',
      subtitle: 'Vérifiez votre connexion internet',
      iconColor: (p) => p.warning,
    ),
    EmptyStateType.error: _EmptyStateConfig(
      icon: Icons.error_outline,
      title: 'Une erreur est survenue',
      subtitle: 'Impossible de charger les données',
      iconColor: (p) => p.error,
    ),
    EmptyStateType.success: _EmptyStateConfig(
      icon: Icons.check_circle_outline,
      title: 'Succès',
      subtitle: 'L\'opération s\'est terminée avec succès',
      iconColor: (p) => p.success,
    ),
    EmptyStateType.allDone: _EmptyStateConfig(
      icon: Icons.celebration_outlined,
      title: 'Tout est fait !',
      subtitle: 'Bravo, vous avez terminé tous vos devoirs',
      iconColor: (p) => p.success,
    ),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final config = widget.type != null ? _configs[widget.type] : null;

    final icon = widget.customIcon ?? config?.icon ?? Icons.info_outline;
    final title = widget.customTitle ?? config?.title ?? 'Information';
    final subtitle = widget.customSubtitle ?? config?.subtitle ?? '';
    final color = widget.iconColor ?? config?.iconColor(palette) ?? palette.textMuted;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône avec cercle décoratif
              _AnimatedIcon(
                icon: icon,
                color: color,
                palette: palette,
              ),
              const SizedBox(height: ChanelTheme.spacing6),

              // Titre
              Text(
                title,
                style: ChanelTypography.titleLarge.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ChanelTheme.spacing2),

              // Sous-titre
              Text(
                subtitle,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              // Bouton d'action optionnel
              if (widget.actionLabel != null && widget.onAction != null) ...[
                const SizedBox(height: ChanelTheme.spacing6),
                _ActionButton(
                  label: widget.actionLabel!,
                  onPressed: widget.onAction!,
                  palette: palette,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Icône animée avec cercle décoratif
class _AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final AppColorPalette palette;

  const _AnimatedIcon({
    required this.icon,
    required this.color,
    required this.palette,
  });

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: child,
      ),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.1),
          border: Border.all(
            color: widget.color.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.15),
            ),
            child: Icon(
              widget.icon,
              size: 40,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bouton d'action stylisé
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppColorPalette palette;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.textInverse,
        padding: const EdgeInsets.symmetric(
          horizontal: ChanelTheme.spacing6,
          vertical: ChanelTheme.spacing3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        ),
      ),
      child: Text(
        label,
        style: ChanelTypography.labelLarge.copyWith(
          color: palette.textInverse,
          letterSpacing: ChanelTypography.letterSpacingWider,
        ),
      ),
    );
  }
}

/// Widget d'erreur avec retry automatique
class ErrorStateWidget extends ConsumerStatefulWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool autoRetry;
  final Duration autoRetryDelay;
  final int maxAutoRetries;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.onRetry,
    this.autoRetry = false,
    this.autoRetryDelay = const Duration(seconds: 5),
    this.maxAutoRetries = 3,
  });

  @override
  ConsumerState<ErrorStateWidget> createState() => _ErrorStateWidgetState();
}

class _ErrorStateWidgetState extends ConsumerState<ErrorStateWidget> {
  int _retryCount = 0;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoRetry && widget.onRetry != null) {
      _scheduleAutoRetry();
    }
  }

  void _scheduleAutoRetry() {
    if (_retryCount >= widget.maxAutoRetries) return;

    Future.delayed(widget.autoRetryDelay, () {
      if (mounted && widget.autoRetry && _retryCount < widget.maxAutoRetries) {
        _performRetry();
      }
    });
  }

  void _performRetry() {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
      _retryCount++;
    });

    widget.onRetry?.call();

    // Réinitialiser après un délai
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
        if (widget.autoRetry) {
          _scheduleAutoRetry();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ChanelTheme.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône d'erreur
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.error.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: palette.error,
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing4),

            // Message
            Text(
              widget.message ?? 'Une erreur est survenue',
              style: ChanelTypography.titleMedium.copyWith(
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ChanelTheme.spacing2),

            Text(
              'Vérifiez votre connexion et réessayez',
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Compteur de retry si auto-retry actif
            if (widget.autoRetry && _retryCount > 0) ...[
              const SizedBox(height: ChanelTheme.spacing2),
              Text(
                'Tentative $_retryCount/${widget.maxAutoRetries}',
                style: ChanelTypography.labelSmall.copyWith(
                  color: palette.textMuted,
                ),
              ),
            ],

            const SizedBox(height: ChanelTheme.spacing4),

            // Bouton retry
            if (widget.onRetry != null)
              ElevatedButton.icon(
                onPressed: _isRetrying ? null : _performRetry,
                icon: _isRetrying
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.textInverse,
                        ),
                      )
                    : const Icon(Icons.refresh, size: 18),
                label: Text(_isRetrying ? 'Chargement...' : 'Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: palette.textInverse,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing4,
                    vertical: ChanelTheme.spacing3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Indicateur de connexion hors-ligne (bannière)
class OfflineBanner extends ConsumerWidget {
  final bool isOffline;
  final VoidCallback? onRetry;

  const OfflineBanner({
    super.key,
    required this.isOffline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOffline ? 48 : 0,
      color: palette.warning,
      child: isOffline
          ? SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 16,
                    color: palette.textInverse,
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                  Text(
                    'Mode hors-ligne',
                    style: ChanelTypography.labelMedium.copyWith(
                      color: palette.textInverse,
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(width: ChanelTheme.spacing3),
                    GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ChanelTheme.spacing2,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: palette.textInverse.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Réessayer',
                          style: ChanelTypography.labelSmall.copyWith(
                            color: palette.textInverse,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          : null,
    );
  }
}

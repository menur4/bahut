import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_provider.dart';

/// Écran de chargement affiché pendant les transitions d'authentification
class LoadingScreen extends ConsumerWidget {
  final String? message;

  const LoadingScreen({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final isDark = palette.isDark;

    return Scaffold(
      backgroundColor: palette.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ou icône de l'app
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: palette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.school_rounded,
                size: 44,
                color: palette.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Indicateur de chargement
            SizedBox(
              width: 28,
              height: 28,
              child: PlatformCircularProgressIndicator(
                material: (_, __) => MaterialProgressIndicatorData(
                  strokeWidth: 3,
                  color: palette.primary,
                ),
                cupertino: (_, __) => CupertinoProgressIndicatorData(
                  color: palette.primary,
                ),
              ),
            ),

            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 15,
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Version simplifiée pour les overlays
class LoadingOverlay extends ConsumerWidget {
  final String? message;

  const LoadingOverlay({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);

    return Container(
      color: palette.backgroundPrimary.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: PlatformCircularProgressIndicator(
                material: (_, __) => MaterialProgressIndicatorData(
                  strokeWidth: 3,
                  color: palette.primary,
                ),
                cupertino: (_, __) => CupertinoProgressIndicatorData(
                  color: palette.primary,
                ),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 14,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

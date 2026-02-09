import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/widgets/loading_screen.dart';
import '../providers/auth_provider.dart';

/// Écran de vérification QCM pour le MFA
class QcmScreen extends ConsumerStatefulWidget {
  const QcmScreen({super.key});

  @override
  ConsumerState<QcmScreen> createState() => _QcmScreenState();
}

class _QcmScreenState extends ConsumerState<QcmScreen> {
  String? _selectedAnswer;
  bool _isTransitioning = false;

  Future<void> _submitAnswer([String? answer]) async {
    final answerToSubmit = answer ?? _selectedAnswer;
    if (answerToSubmit == null) return;

    await ref.read(authStateProvider.notifier).answerQcm(answerToSubmit);

    if (mounted) {
      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        // Afficher l'écran de chargement AVANT la navigation
        setState(() => _isTransitioning = true);

        // Petit délai pour s'assurer que l'écran de chargement est affiché
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          if (authState.hasMultipleChildren && authState.selectedChildId == null) {
            context.go(AppRoutes.children);
          } else {
            context.go(AppRoutes.dashboard);
          }
        }
      }
    }
  }

  void _cancel() {
    ref.read(authStateProvider.notifier).cancelMfa();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final qcmData = authState.qcmData;
    final palette = ref.watch(currentPaletteProvider);

    // Afficher l'écran de chargement pendant la transition vers le dashboard
    if (_isTransitioning) {
      return const LoadingScreen(
        message: 'Chargement de vos données...',
      );
    }

    if (qcmData == null) {
      // Redirect to login if no QCM data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.login);
      });
      return const SizedBox.shrink();
    }

    return PlatformScaffold(
      backgroundColor: palette.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ChanelTheme.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ChanelTheme.spacing8),

              // Titre
              Text(
                'VÉRIFICATION',
                textAlign: TextAlign.center,
                style: ChanelTypography.displaySmall.copyWith(
                  letterSpacing: ChanelTypography.letterSpacingLuxury,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing2),
              Text(
                'Veuillez répondre à cette question de sécurité',
                textAlign: TextAlign.center,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textTertiary,
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing8),

              // Question
              Container(
                padding: const EdgeInsets.all(ChanelTheme.spacing4),
                decoration: BoxDecoration(
                  color: palette.backgroundSecondary,
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                  border: Border.all(color: palette.borderLight),
                ),
                child: Text(
                  qcmData.question,
                  textAlign: TextAlign.center,
                  style: ChanelTypography.headlineSmall.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing6),

              // Propositions
              ...qcmData.propositions.map((proposition) {
                final isSelected = _selectedAnswer == proposition;
                return Padding(
                  padding: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
                  child: InkWell(
                    onTap: authState.isLoading
                        ? null
                        : () {
                            setState(() => _selectedAnswer = proposition);
                            // Valider automatiquement après sélection
                            _submitAnswer(proposition);
                          },
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.all(ChanelTheme.spacing4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? palette.primary.withValues(alpha: 0.05)
                            : palette.backgroundCard,
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                        border: Border.all(
                          color: isSelected
                              ? palette.primary
                              : palette.borderLight,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? palette.primary
                                    : palette.borderDark,
                                width: 2,
                              ),
                              color: isSelected
                                  ? palette.primary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: palette.textInverse,
                                  )
                                : null,
                          ),
                          const SizedBox(width: ChanelTheme.spacing3),
                          Expanded(
                            child: Text(
                              proposition,
                              style: ChanelTypography.bodyMedium.copyWith(
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: palette.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: ChanelTheme.spacing4),

              // Message d'erreur
              if (authState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(ChanelTheme.spacing3),
                  decoration: BoxDecoration(
                    color: palette.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: palette.error,
                        size: 20,
                      ),
                      const SizedBox(width: ChanelTheme.spacing2),
                      Expanded(
                        child: Text(
                          authState.errorMessage!,
                          style: ChanelTypography.bodySmall.copyWith(
                            color: palette.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing4),
              ],

              // Bouton Valider
              SizedBox(
                height: 52,
                child: PlatformElevatedButton(
                  onPressed: authState.isLoading || _selectedAnswer == null
                      ? null
                      : _submitAnswer,
                  material: (_, __) => MaterialElevatedButtonData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.textInverse,
                      disabledBackgroundColor: palette.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusBase),
                      ),
                    ),
                  ),
                  child: authState.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: palette.textInverse,
                          ),
                        )
                      : Text(
                          'VALIDER',
                          style: ChanelTypography.labelLarge.copyWith(
                            color: palette.textInverse,
                            letterSpacing: ChanelTypography.letterSpacingWider,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing4),

              // Bouton Annuler
              TextButton(
                onPressed: authState.isLoading ? null : _cancel,
                child: Text(
                  'Annuler',
                  style: ChanelTypography.bodyMedium.copyWith(
                    color: palette.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

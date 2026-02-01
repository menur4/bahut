import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Écran de déverrouillage biométrique
class BiometricScreen extends ConsumerStatefulWidget {
  const BiometricScreen({super.key});

  @override
  ConsumerState<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends ConsumerState<BiometricScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Déclencher l'authentification biométrique au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    final authState = ref.read(authStateProvider);

    // Si pas connecté, aller vers login
    if (!authState.isAuthenticated) {
      context.go(AppRoutes.login);
      return;
    }

    // Si biométrie pas activée, aller directement au dashboard
    if (!authState.biometricEnabled) {
      _navigateToNext();
      return;
    }

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      // Vérifier si la biométrie est disponible
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        // Biométrie non disponible, désactiver et continuer
        await ref.read(authStateProvider.notifier).setBiometricEnabled(false);
        _navigateToNext();
        return;
      }

      // Authentifier
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Déverrouillez pour accéder à vos notes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        _navigateToNext();
      } else {
        setState(() {
          _errorMessage = 'Authentification annulée';
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur d\'authentification';
        _isAuthenticating = false;
      });
    }
  }

  void _navigateToNext() {
    final authState = ref.read(authStateProvider);
    if (authState.hasMultipleChildren && authState.selectedChildId == null) {
      context.go(AppRoutes.children);
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  void _usePassword() {
    // Déconnecter et aller vers login
    ref.read(authStateProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              Text(
                'BAHUT',
                textAlign: TextAlign.center,
                style: ChanelTypography.displaySmall.copyWith(
                  letterSpacing: ChanelTypography.letterSpacingLuxury,
                  color: palette.textPrimary,
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing12),

              // Icône biométrie
              GestureDetector(
                onTap: _isAuthenticating ? null : _authenticate,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: palette.backgroundSecondary,
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
                    border: Border.all(
                      color: palette.borderLight,
                      width: 1,
                    ),
                  ),
                  child: _isAuthenticating
                      ? Center(
                          child: CircularProgressIndicator(
                            color: palette.primary,
                          ),
                        )
                      : Icon(
                          Icons.fingerprint,
                          size: 56,
                          color: palette.primary,
                        ),
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing6),

              // Message
              Text(
                _isAuthenticating
                    ? 'Authentification en cours...'
                    : 'Touchez pour déverrouiller',
                textAlign: TextAlign.center,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),

              // Message d'erreur
              if (_errorMessage != null) ...[
                const SizedBox(height: ChanelTheme.spacing4),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: ChanelTypography.bodySmall.copyWith(
                    color: palette.error,
                  ),
                ),
              ],

              const Spacer(),

              // Bouton utiliser mot de passe
              PlatformTextButton(
                onPressed: _usePassword,
                child: Text(
                  'Utiliser mot de passe',
                  style: ChanelTypography.labelMedium.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing4),
            ],
          ),
        ),
      ),
    );
  }
}

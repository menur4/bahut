import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/auth_provider.dart';

/// Écran de connexion École Directe
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authStateProvider.notifier).login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    // La navigation est gérée automatiquement par le router
    // qui redirige vers biometric, children ou dashboard selon l'état
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final authState = ref.watch(authStateProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ChanelTheme.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: ChanelTheme.spacing8),

                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: palette.textPrimary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusXl),
                      child: Image.asset(
                        'assets/icone.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: ChanelTheme.spacing5),

                // Titre
                Text(
                  'BAHUT',
                  textAlign: TextAlign.center,
                  style: ChanelTypography.displayLarge.copyWith(
                    letterSpacing: ChanelTypography.letterSpacingLuxury,
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: ChanelTheme.spacing1),
                Text(
                  'Votre compagnon pour École Directe',
                  textAlign: TextAlign.center,
                  style: ChanelTypography.bodyMedium.copyWith(
                    color: palette.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Note explicative
                Container(
                  padding: const EdgeInsets.all(ChanelTheme.spacing4),
                  decoration: BoxDecoration(
                    color: palette.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                    border: Border.all(
                      color: palette.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: palette.primary,
                        size: 20,
                      ),
                      const SizedBox(width: ChanelTheme.spacing3),
                      Expanded(
                        child: Text(
                          'Connectez-vous avec vos identifiants École Directe',
                          style: ChanelTypography.bodySmall.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Champ Identifiant
                PlatformTextFormField(
                  controller: _usernameController,
                  hintText: 'Identifiant',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  material: (_, __) => MaterialTextFormFieldData(
                    decoration: const InputDecoration(
                      labelText: 'Identifiant',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFormFieldData(
                    placeholder: 'Identifiant',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.person_outline, size: 20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre identifiant';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: ChanelTheme.spacing4),

                // Champ Mot de passe
                PlatformTextFormField(
                  controller: _passwordController,
                  hintText: 'Mot de passe',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  material: (_, __) => MaterialTextFormFieldData(
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFormFieldData(
                    placeholder: 'Mot de passe',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.lock_outline, size: 20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: ChanelTheme.spacing4),

                // Se souvenir de moi
                Row(
                  children: [
                    PlatformSwitch(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value),
                    ),
                    const SizedBox(width: ChanelTheme.spacing2),
                    Text(
                      'Se souvenir de moi',
                      style: ChanelTypography.bodyMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Message d'erreur
                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(ChanelTheme.spacing3),
                    decoration: BoxDecoration(
                      color: palette.errorLight,
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

                // Bouton de connexion
                SizedBox(
                  height: 52,
                  child: PlatformElevatedButton(
                    onPressed: authState.isLoading ? null : _login,
                    material: (_, __) => MaterialElevatedButtonData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.primary,
                        foregroundColor: palette.textInverse,
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
                            'SE CONNECTER',
                            style: ChanelTypography.labelLarge.copyWith(
                              color: palette.textInverse,
                              letterSpacing: ChanelTypography.letterSpacingWider,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: ChanelTheme.spacing8),

                // Info
                Text(
                  'Utilisez vos identifiants École Directe',
                  textAlign: TextAlign.center,
                  style: ChanelTypography.bodySmall.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

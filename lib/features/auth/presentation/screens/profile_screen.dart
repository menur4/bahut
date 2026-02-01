import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../router/app_router.dart';
import '../providers/auth_provider.dart';
import '../../../grades/presentation/providers/grades_provider.dart';

/// Écran du profil
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? _photoBytes;
  bool _photoLoading = false;
  String? _lastPhotoUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPhoto();

      // Écouter les changements de l'enfant sélectionné
      ref.listenManual(
        authStateProvider.select((s) => s.selectedChild?.id),
        (previous, next) {
          if (next != null && next != previous) {
            _photoBytes = null;
            _lastPhotoUrl = null;
            _loadPhoto();
          }
        },
      );
    });
  }

  Future<void> _loadPhoto() async {
    final authState = ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild?.photo == null || selectedChild!.photo!.isEmpty) {
      return;
    }

    var photoUrl = selectedChild.photo!;
    if (photoUrl.startsWith('//')) {
      photoUrl = 'https:$photoUrl';
    }

    if (photoUrl == _lastPhotoUrl && _photoBytes != null) {
      return;
    }

    setState(() {
      _photoLoading = true;
      _lastPhotoUrl = photoUrl;
    });

    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        photoUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'User-Agent': ApiConstants.userAgent,
            'Referer': 'https://www.ecoledirecte.com/',
            'Accept': 'image/*',
            'Origin': 'https://www.ecoledirecte.com',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _photoBytes = Uint8List.fromList(response.data!);
          _photoLoading = false;
        });
      } else {
        setState(() {
          _photoLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[PROFILE] Erreur chargement photo: $e');
      setState(() {
        _photoLoading = false;
      });
    }
  }

  Future<void> _logout(AppColorPalette palette) async {
    final confirmed = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            material: (_, __) => MaterialDialogActionData(
              child: Text(
                'Déconnexion',
                style: TextStyle(color: palette.error),
              ),
            ),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: true,
              child: const Text('Déconnexion'),
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authStateProvider.notifier).logout();
      await ref.read(gradesStateProvider.notifier).clearCache();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final selectedChild = authState.selectedChild;
    final palette = ref.watch(currentPaletteProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'PROFIL',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte profil enfant
            if (selectedChild != null)
              Container(
                padding: const EdgeInsets.all(ChanelTheme.spacing6),
                decoration: BoxDecoration(
                  color: palette.backgroundCard,
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusLg),
                  border: Border.all(color: palette.borderLight),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: palette.backgroundTertiary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.borderLight,
                          width: 2,
                        ),
                      ),
                      child: _photoLoading
                          ? Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: palette.textMuted,
                                ),
                              ),
                            )
                          : _photoBytes != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _photoBytes!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _buildInitials(selectedChild, palette),
                    ),

                    const SizedBox(height: ChanelTheme.spacing4),

                    // Nom
                    Text(
                      selectedChild.fullName,
                      style: ChanelTypography.headlineMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Classe
                    if (selectedChild.classe != null) ...[
                      const SizedBox(height: ChanelTheme.spacing1),
                      Text(
                        selectedChild.classe!,
                        style: ChanelTypography.bodyMedium.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            const SizedBox(height: ChanelTheme.spacing6),

            // Changer d'enfant
            if (authState.hasMultipleChildren) ...[
              Text(
                'COMPTE',
                style: ChanelTypography.labelMedium.copyWith(
                  letterSpacing: ChanelTypography.letterSpacingWider,
                  color: palette.textTertiary,
                ),
              ),
              const SizedBox(height: ChanelTheme.spacing3),
              _SettingsCard(
                icon: Icons.switch_account,
                title: 'Changer d\'enfant',
                subtitle: 'Basculer vers un autre profil',
                onTap: () => context.go(AppRoutes.children),
                palette: palette,
              ),
              const SizedBox(height: ChanelTheme.spacing6),
            ],

            // Déconnexion
            _SettingsCard(
              icon: Icons.logout,
              title: 'Déconnexion',
              subtitle: 'Se déconnecter d\'École Directe',
              iconColor: palette.error,
              onTap: () => _logout(palette),
              palette: palette,
            ),

            const SizedBox(height: ChanelTheme.spacing8),

            // Version
            Text(
              'Bahut v1.0.0',
              textAlign: TextAlign.center,
              style: ChanelTypography.labelSmall.copyWith(
                color: palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitials(child, AppColorPalette palette) {
    final initials = '${child.prenom.isNotEmpty ? child.prenom[0] : ''}${child.nom.isNotEmpty ? child.nom[0] : ''}'.toUpperCase();
    return Center(
      child: Text(
        initials,
        style: ChanelTypography.headlineMedium.copyWith(
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final AppColorPalette? palette;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;

    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing2),
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: p.borderLight),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? p.textSecondary,
        ),
        title: Text(
          title,
          style: ChanelTypography.bodyLarge.copyWith(
            color: p.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: ChanelTypography.bodySmall.copyWith(
            color: p.textTertiary,
          ),
        ),
        trailing: trailing ?? (onTap != null
            ? Icon(
                Icons.chevron_right,
                color: p.textMuted,
              )
            : null),
      ),
    );
  }
}

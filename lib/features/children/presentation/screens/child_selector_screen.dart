import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/user_model.dart';

/// Écran de sélection de l'enfant
class ChildSelectorScreen extends ConsumerWidget {
  const ChildSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(currentPaletteProvider);
    final authState = ref.watch(authStateProvider);
    final children = authState.children;

    return PlatformScaffold(
      backgroundColor: palette.backgroundPrimary,
      appBar: PlatformAppBar(
        title: Text(
          'SÉLECTIONNER UN ENFANT',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ChanelTheme.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ChanelTheme.spacing4),

              Text(
                'Choisissez le profil à afficher',
                textAlign: TextAlign.center,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),

              const SizedBox(height: ChanelTheme.spacing6),

              // Liste des enfants
              Expanded(
                child: ListView.separated(
                  itemCount: children.length,
                  separatorBuilder: (_, __) => const SizedBox(height: ChanelTheme.spacing3),
                  itemBuilder: (context, index) {
                    final child = children[index];
                    final isSelected = authState.selectedChildId == child.id;

                    return _ChildCard(
                      child: child,
                      isSelected: isSelected,
                      palette: palette,
                      onTap: () async {
                        await ref.read(authStateProvider.notifier).selectChild(child.id);
                        if (context.mounted) {
                          context.go(AppRoutes.dashboard);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final ChildModel child;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorPalette palette;

  const _ChildCard({
    required this.child,
    required this.isSelected,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: isSelected ? palette.primaryLight.withOpacity(0.1) : palette.backgroundCard,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
          border: Border.all(
            color: isSelected ? palette.primary : palette.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: palette.backgroundTertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: palette.borderLight,
                  width: 1,
                ),
              ),
              child: child.photo != null
                  ? ClipOval(
                      child: Image.network(
                        child.photo!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildInitials(),
                      ),
                    )
                  : _buildInitials(),
            ),

            const SizedBox(width: ChanelTheme.spacing4),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.fullName,
                    style: ChanelTypography.titleMedium.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  if (child.classe != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      child.classe!,
                      style: ChanelTypography.bodySmall.copyWith(
                        color: palette.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: isSelected ? palette.primary : palette.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitials() {
    final initials = '${child.prenom.isNotEmpty ? child.prenom[0] : ''}${child.nom.isNotEmpty ? child.nom[0] : ''}'.toUpperCase();
    return Center(
      child: Text(
        initials,
        style: ChanelTypography.titleMedium.copyWith(
          color: palette.textSecondary,
        ),
      ),
    );
  }
}

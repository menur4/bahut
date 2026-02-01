import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/models/vie_scolaire_model.dart';
import '../providers/vie_scolaire_provider.dart';

/// Écran de la vie scolaire (absences, retards, sanctions)
class VieScolaireScreen extends ConsumerStatefulWidget {
  const VieScolaireScreen({super.key});

  @override
  ConsumerState<VieScolaireScreen> createState() => _VieScolaireScreenState();
}

class _VieScolaireScreenState extends ConsumerState<VieScolaireScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vieScolaireStateProvider.notifier).fetchVieScolaire();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref
        .read(vieScolaireStateProvider.notifier)
        .fetchVieScolaire(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vieScolaireStateProvider);
    final palette = ref.watch(currentPaletteProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'VIE SCOLAIRE',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
          bottom: TabBar(
            controller: _tabController,
            labelColor: palette.textPrimary,
            unselectedLabelColor: palette.textMuted,
            indicatorColor: palette.primary,
            labelStyle: ChanelTypography.labelSmall,
            tabs: [
              Tab(
                text: 'Absences',
                icon: Badge(
                  isLabelVisible: state.totalAbsences > 0,
                  label: Text('${state.totalAbsences}'),
                  child: const Icon(Icons.event_busy, size: 20),
                ),
              ),
              Tab(
                text: 'Retards',
                icon: Badge(
                  isLabelVisible: state.totalRetards > 0,
                  label: Text('${state.totalRetards}'),
                  child: const Icon(Icons.schedule, size: 20),
                ),
              ),
              Tab(
                text: 'Sanctions',
                icon: Badge(
                  isLabelVisible: state.totalSanctions > 0,
                  label: Text('${state.totalSanctions}'),
                  backgroundColor: palette.error,
                  child: const Icon(Icons.warning_amber, size: 20),
                ),
              ),
              Tab(
                text: 'Bonus',
                icon: Badge(
                  isLabelVisible: state.totalEncouragements > 0,
                  label: Text('${state.totalEncouragements}'),
                  backgroundColor: palette.success,
                  child: const Icon(Icons.star, size: 20),
                ),
              ),
            ],
          ),
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
        ),
      ),
      body: _buildBody(state, palette),
    );
  }

  Widget _buildBody(VieScolaireState state, AppColorPalette palette) {
    if (state.isLoading && state.data == null) {
      return Center(
        child: CircularProgressIndicator(color: palette.primary),
      );
    }

    if (state.errorMessage != null && state.data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: palette.textMuted,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              state.errorMessage!,
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            PlatformTextButton(
              onPressed: _refresh,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final data = state.data;
    if (data == null) {
      return const Center(
        child: Text('Aucune donnée'),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildAbsencesList(data.absences, palette),
        _buildRetardsList(data.retards, palette),
        _buildSanctionsList(data.sanctions, palette),
        _buildEncouragementsList(data.encouragements, palette),
      ],
    );
  }

  Widget _buildAbsencesList(List<AbsenceRetardModel> absences, AppColorPalette palette) {
    if (absences.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Aucune absence',
        subtitle: 'Excellent ! Continuez ainsi.',
        palette: palette,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: absences.length,
        itemBuilder: (context, index) {
          final absence = absences[index];
          return _AbsenceRetardCard(
            item: absence,
            icon: Icons.event_busy,
            color: absence.justifie ? palette.success : palette.warning,
            palette: palette,
          );
        },
      ),
    );
  }

  Widget _buildRetardsList(List<AbsenceRetardModel> retards, AppColorPalette palette) {
    if (retards.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Aucun retard',
        subtitle: 'Ponctualité parfaite !',
        palette: palette,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: retards.length,
        itemBuilder: (context, index) {
          final retard = retards[index];
          return _AbsenceRetardCard(
            item: retard,
            icon: Icons.schedule,
            color: retard.justifie ? palette.success : palette.warning,
            palette: palette,
          );
        },
      ),
    );
  }

  Widget _buildSanctionsList(List<SanctionEncouragementModel> sanctions, AppColorPalette palette) {
    if (sanctions.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Aucune sanction',
        subtitle: 'Bravo pour le bon comportement !',
        palette: palette,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: sanctions.length,
        itemBuilder: (context, index) {
          return _SanctionCard(item: sanctions[index], palette: palette);
        },
      ),
    );
  }

  Widget _buildEncouragementsList(
      List<SanctionEncouragementModel> encouragements, AppColorPalette palette) {
    if (encouragements.isEmpty) {
      return _buildEmptyState(
        icon: Icons.star_border,
        title: 'Aucun encouragement',
        subtitle: 'Les encouragements apparaîtront ici.',
        palette: palette,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: encouragements.length,
        itemBuilder: (context, index) {
          return _EncouragementCard(item: encouragements[index], palette: palette);
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required AppColorPalette palette,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: palette.success,
          ),
          const SizedBox(height: ChanelTheme.spacing4),
          Text(
            title,
            style: ChanelTypography.titleLarge.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing2),
          Text(
            subtitle,
            style: ChanelTypography.bodyMedium.copyWith(
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbsenceRetardCard extends StatelessWidget {
  final AbsenceRetardModel item;
  final IconData icon;
  final Color color;
  final AppColorPalette palette;

  const _AbsenceRetardCard({
    required this.item,
    required this.icon,
    required this.color,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: ChanelTheme.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.libelle ?? item.typeElement,
                  style: ChanelTypography.bodyLarge.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                if (item.displayDate != null) ...[
                  const SizedBox(height: ChanelTheme.spacing1),
                  Text(
                    item.displayDate!,
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
                if (item.motif != null && item.motif!.isNotEmpty) ...[
                  const SizedBox(height: ChanelTheme.spacing1),
                  Text(
                    item.motif!,
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing2,
              vertical: ChanelTheme.spacing1,
            ),
            decoration: BoxDecoration(
              color: item.justifie
                  ? palette.success.withValues(alpha: 0.1)
                  : palette.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Text(
              item.justifie ? 'Justifié' : 'Non justifié',
              style: ChanelTypography.labelSmall.copyWith(
                color: item.justifie ? palette.success : palette.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SanctionCard extends StatelessWidget {
  final SanctionEncouragementModel item;
  final AppColorPalette palette;

  const _SanctionCard({required this.item, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: palette.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
                child: Icon(
                  Icons.warning_amber,
                  color: palette.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.libelle ?? item.typeElement,
                      style: ChanelTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (item.displayDate != null)
                      Text(
                        item.displayDate!,
                        style: ChanelTypography.bodySmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (item.motif != null && item.motif!.isNotEmpty) ...[
            const SizedBox(height: ChanelTheme.spacing3),
            Text(
              'Motif: ${item.motif}',
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ],
          if (item.par != null && item.par!.isNotEmpty) ...[
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              'Par: ${item.par}',
              style: ChanelTypography.bodySmall.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
          if (item.dateDeroulement != null) ...[
            const SizedBox(height: ChanelTheme.spacing2),
            Container(
              padding: const EdgeInsets.all(ChanelTheme.spacing2),
              decoration: BoxDecoration(
                color: palette.backgroundTertiary,
                borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: palette.textSecondary,
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                  Text(
                    'Date: ${item.dateDeroulement}',
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EncouragementCard extends StatelessWidget {
  final SanctionEncouragementModel item;
  final AppColorPalette palette;

  const _EncouragementCard({required this.item, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
            ),
            child: Icon(
              Icons.star,
              color: palette.success,
              size: 20,
            ),
          ),
          const SizedBox(width: ChanelTheme.spacing3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.libelle ?? 'Encouragement',
                  style: ChanelTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                  ),
                ),
                if (item.displayDate != null)
                  Text(
                    item.displayDate!,
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                if (item.motif != null && item.motif!.isNotEmpty) ...[
                  const SizedBox(height: ChanelTheme.spacing1),
                  Text(
                    item.motif!,
                    style: ChanelTypography.bodySmall.copyWith(
                      color: palette.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

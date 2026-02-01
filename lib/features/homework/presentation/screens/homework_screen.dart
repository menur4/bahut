import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/skeleton_widgets.dart';
import '../../data/models/homework_model.dart';
import '../providers/homework_provider.dart';

/// Écran des devoirs / cahier de texte
class HomeworkScreen extends ConsumerStatefulWidget {
  const HomeworkScreen({super.key});

  @override
  ConsumerState<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends ConsumerState<HomeworkScreen> {
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeworkStateProvider.notifier).fetchHomework();
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(homeworkStateProvider.notifier)
        .fetchHomework(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final state = ref.watch(homeworkStateProvider);

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        title: Text(
          'DEVOIRS',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(
              _showCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: _showCompleted ? palette.success : palette.textMuted,
            ),
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
              });
            },
          ),
        ],
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
      body: _buildBody(state, palette),
    );
  }

  Widget _buildBody(HomeworkState state, AppColorPalette palette) {
    if (state.isLoading && state.data == null) {
      return const SkeletonHomeworkScreen();
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
    if (data == null || data.homeworks.isEmpty) {
      return _buildEmptyState(palette);
    }

    // Filtrer selon l'état _showCompleted
    final sortedDates = data.sortedByDate;
    final filteredDates = <String, List<HomeworkModel>>{};

    for (final entry in sortedDates.entries) {
      final filtered = entry.value.where((h) {
        if (_showCompleted) return true;
        return !h.effectue;
      }).toList();
      if (filtered.isNotEmpty) {
        filteredDates[entry.key] = filtered;
      }
    }

    if (filteredDates.isEmpty) {
      return _buildEmptyState(
        palette,
        icon: Icons.check_circle,
        title: 'Tout est fait !',
        subtitle: 'Activez le filtre pour voir les devoirs effectués.',
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: filteredDates.length,
        itemBuilder: (context, index) {
          final dateStr = filteredDates.keys.elementAt(index);
          final homeworks = filteredDates[dateStr]!;
          return _DateSection(
            dateStr: dateStr,
            homeworks: homeworks,
            palette: palette,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    AppColorPalette palette, {
    IconData icon = Icons.assignment_outlined,
    String title = 'Aucun devoir',
    String subtitle = 'Vous n\'avez pas de devoirs pour le moment.',
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: palette.textMuted,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DateSection extends StatelessWidget {
  final String dateStr;
  final List<HomeworkModel> homeworks;
  final AppColorPalette palette;

  const _DateSection({
    required this.dateStr,
    required this.homeworks,
    required this.palette,
  });

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));

      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return 'Aujourd\'hui';
      }
      if (date.day == tomorrow.day &&
          date.month == tomorrow.month &&
          date.year == tomorrow.year) {
        return 'Demain';
      }

      final format = DateFormat('EEEE d MMMM', 'fr_FR');
      return format.format(date);
    } catch (_) {
      return dateStr;
    }
  }

  bool _isOverdue(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      return date.isBefore(DateTime(now.year, now.month, now.day));
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = _isOverdue(dateStr);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: ChanelTheme.spacing2,
            top: ChanelTheme.spacing2,
          ),
          child: Row(
            children: [
              Text(
                _formatDate(dateStr).toUpperCase(),
                style: ChanelTypography.labelMedium.copyWith(
                  letterSpacing: ChanelTypography.letterSpacingWider,
                  color: isOverdue ? palette.error : palette.textTertiary,
                ),
              ),
              if (isOverdue) ...[
                const SizedBox(width: ChanelTheme.spacing2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Text(
                    'En retard',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: palette.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        ...homeworks.map((homework) => _HomeworkCard(
          homework: homework,
          palette: palette,
        )),
        const SizedBox(height: ChanelTheme.spacing3),
      ],
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final HomeworkModel homework;
  final AppColorPalette palette;

  const _HomeworkCard({
    required this.homework,
    required this.palette,
  });

  Color _getMatiereColor(String? matiere) {
    if (matiere == null) return palette.textSecondary;

    final m = matiere.toLowerCase();
    if (m.contains('math')) return const Color(0xFF4CAF50);
    if (m.contains('français') || m.contains('francais')) {
      return const Color(0xFF2196F3);
    }
    if (m.contains('anglais')) return const Color(0xFFE91E63);
    if (m.contains('histoire') || m.contains('géo')) {
      return const Color(0xFFFF9800);
    }
    if (m.contains('physique') || m.contains('chimie')) {
      return const Color(0xFF9C27B0);
    }
    if (m.contains('svt') || m.contains('bio')) return const Color(0xFF4CAF50);
    if (m.contains('sport') || m.contains('eps')) return const Color(0xFFFF5722);

    return palette.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getMatiereColor(homework.matiere);

    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing2),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(
          color: homework.effectue
              ? palette.success.withValues(alpha: 0.3)
              : palette.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(ChanelTheme.spacing3),
            decoration: BoxDecoration(
              color: homework.effectue
                  ? palette.success.withValues(alpha: 0.05)
                  : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ChanelTheme.radiusMd),
                topRight: Radius.circular(ChanelTheme.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: ChanelTheme.spacing3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homework.matiere ?? 'Matière',
                        style: ChanelTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: homework.effectue
                              ? TextDecoration.lineThrough
                              : null,
                          color: homework.effectue
                              ? palette.textMuted
                              : palette.textPrimary,
                        ),
                      ),
                      if (homework.isInterrogation)
                        Container(
                          margin: const EdgeInsets.only(top: ChanelTheme.spacing1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: ChanelTheme.spacing2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: palette.warning.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(ChanelTheme.radiusSm),
                          ),
                          child: Text(
                            'Évaluation',
                            style: ChanelTypography.labelSmall.copyWith(
                              color: palette.warning,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (homework.effectue)
                  Icon(
                    Icons.check_circle,
                    color: palette.success,
                    size: 24,
                  ),
              ],
            ),
          ),

          // Contenu
          if (homework.contenu.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ChanelTheme.spacing4,
                0,
                ChanelTheme.spacing4,
                ChanelTheme.spacing3,
              ),
              child: Text(
                homework.contenu,
                style: ChanelTypography.bodyMedium.copyWith(
                  color: homework.effectue
                      ? palette.textMuted
                      : palette.textSecondary,
                ),
              ),
            ),

          // Footer avec indicateur de pièces jointes
          if (homework.rendpieces)
            Container(
              padding: const EdgeInsets.all(ChanelTheme.spacing3),
              decoration: BoxDecoration(
                color: palette.backgroundTertiary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(ChanelTheme.radiusMd),
                  bottomRight: Radius.circular(ChanelTheme.radiusMd),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 16,
                    color: palette.textSecondary,
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                  Text(
                    'Travail à rendre',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

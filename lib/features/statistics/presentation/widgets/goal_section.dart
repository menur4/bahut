import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../domain/models/goal_model.dart';
import '../providers/goals_provider.dart';

/// Section d'affichage et de gestion de l'objectif de moyenne
class GoalSection extends ConsumerWidget {
  final AppColorPalette palette;

  const GoalSection({super.key, required this.palette});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(goalsProvider);
    final prediction = ref.watch(generalGoalPredictionProvider);

    if (goalsState.generalGoal == null) {
      return _NoGoalCard(
        palette: palette,
        onSetGoal: () => _showSetGoalDialog(context, ref),
      );
    }

    return _GoalProgressCard(
      goal: goalsState.generalGoal!,
      prediction: prediction,
      palette: palette,
      onEdit: () => _showSetGoalDialog(context, ref),
      onDelete: () => _showDeleteConfirmation(context, ref),
    );
  }

  void _showSetGoalDialog(BuildContext context, WidgetRef ref) {
    final goalsState = ref.read(goalsProvider);
    final currentGoal = goalsState.generalGoal?.targetAverage ?? 14.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: palette.backgroundCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      builder: (context) => _SetGoalSheet(
        palette: palette,
        initialValue: currentGoal,
        onSave: (value) {
          ref.read(goalsProvider.notifier).setGeneralGoal(value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.backgroundCard,
        title: Text(
          'Supprimer l\'objectif ?',
          style: ChanelTypography.titleMedium.copyWith(
            color: palette.textPrimary,
          ),
        ),
        content: Text(
          'Tu pourras en définir un nouveau à tout moment.',
          style: ChanelTypography.bodyMedium.copyWith(
            color: palette.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(goalsProvider.notifier).removeGeneralGoal();
              Navigator.pop(context);
            },
            child: Text(
              'Supprimer',
              style: TextStyle(color: palette.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte lorsqu'aucun objectif n'est défini
class _NoGoalCard extends StatelessWidget {
  final AppColorPalette palette;
  final VoidCallback onSetGoal;

  const _NoGoalCard({required this.palette, required this.onSetGoal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            Icons.flag_outlined,
            size: 48,
            color: palette.textMuted,
          ),
          const SizedBox(height: ChanelTheme.spacing3),
          Text(
            'Définis ton objectif',
            style: ChanelTypography.titleSmall.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: ChanelTheme.spacing1),
          Text(
            'Fixe-toi une moyenne à atteindre\net suis ta progression',
            style: ChanelTypography.bodySmall.copyWith(
              color: palette.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ChanelTheme.spacing4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSetGoal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Définir un objectif'),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte de progression vers l'objectif
class _GoalProgressCard extends StatelessWidget {
  final GoalModel goal;
  final GoalPrediction? prediction;
  final AppColorPalette palette;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GoalProgressCard({
    required this.goal,
    required this.prediction,
    required this.palette,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isAchieved = prediction?.isAchieved ?? false;
    final progress = (prediction?.progressPercentage ?? 0) / 100;

    return Container(
      padding: const EdgeInsets.all(ChanelTheme.spacing4),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(
          color: isAchieved ? palette.success : palette.borderLight,
          width: isAchieved ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isAchieved
                      ? palette.success.withValues(alpha: 0.1)
                      : palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                ),
                child: Icon(
                  isAchieved ? Icons.emoji_events : Icons.flag,
                  color: isAchieved ? palette.success : palette.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: ChanelTheme.spacing3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAchieved ? 'Objectif atteint !' : 'Mon objectif',
                      style: ChanelTypography.titleSmall.copyWith(
                        color: isAchieved ? palette.success : palette.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Moyenne générale de ${goal.targetAverage.toStringAsFixed(1)}/20',
                      style: ChanelTypography.bodySmall.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: palette.textSecondary),
                color: palette.backgroundCard,
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: palette.textSecondary),
                        const SizedBox(width: 8),
                        Text('Modifier', style: TextStyle(color: palette.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: palette.error),
                        const SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: palette.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (prediction != null) ...[
            const SizedBox(height: ChanelTheme.spacing4),

            // Barre de progression
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progression',
                      style: ChanelTypography.labelSmall.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                    Text(
                      '${prediction!.progressPercentage.toStringAsFixed(0)}%',
                      style: ChanelTypography.labelMedium.copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ChanelTheme.spacing2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ChanelTheme.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: palette.backgroundTertiary,
                    valueColor: AlwaysStoppedAnimation(
                      isAchieved ? palette.success : palette.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: ChanelTheme.spacing3),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Actuel',
                    value: prediction!.currentAverage.toStringAsFixed(2),
                    palette: palette,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: palette.borderLight,
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'Objectif',
                    value: prediction!.targetAverage.toStringAsFixed(1),
                    palette: palette,
                    highlight: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: palette.borderLight,
                ),
                Expanded(
                  child: _MiniStat(
                    label: 'Écart',
                    value: isAchieved
                        ? '+${(prediction!.currentAverage - prediction!.targetAverage).toStringAsFixed(1)}'
                        : '-${prediction!.gap.toStringAsFixed(1)}',
                    palette: palette,
                    color: isAchieved ? palette.success : palette.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: ChanelTheme.spacing3),

            // Conseil
            Container(
              padding: const EdgeInsets.all(ChanelTheme.spacing3),
              decoration: BoxDecoration(
                color: palette.backgroundSecondary,
                borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: palette.warning,
                  ),
                  const SizedBox(width: ChanelTheme.spacing2),
                  Expanded(
                    child: Text(
                      prediction!.advice,
                      style: ChanelTypography.bodySmall.copyWith(
                        color: palette.textSecondary,
                      ),
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

/// Mini statistique
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final AppColorPalette palette;
  final bool highlight;
  final Color? color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.palette,
    this.highlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: ChanelTypography.titleMedium.copyWith(
            color: color ?? (highlight ? palette.primary : palette.textPrimary),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: ChanelTypography.labelSmall.copyWith(
            color: palette.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet pour définir un objectif
class _SetGoalSheet extends StatefulWidget {
  final AppColorPalette palette;
  final double initialValue;
  final void Function(double) onSave;

  const _SetGoalSheet({
    required this.palette,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<_SetGoalSheet> createState() => _SetGoalSheetState();
}

class _SetGoalSheetState extends State<_SetGoalSheet> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: ChanelTheme.spacing4,
          right: ChanelTheme.spacing4,
          top: ChanelTheme.spacing4,
          bottom: MediaQuery.of(context).viewInsets.bottom + ChanelTheme.spacing4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: widget.palette.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing4),

            Text(
              'Définir mon objectif',
              style: ChanelTypography.titleLarge.copyWith(
                color: widget.palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ChanelTheme.spacing2),
            Text(
              'Quelle moyenne générale vises-tu ?',
              style: ChanelTypography.bodyMedium.copyWith(
                color: widget.palette.textSecondary,
              ),
            ),

            const SizedBox(height: ChanelTheme.spacing6),

            // Affichage de la valeur
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.palette.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: widget.palette.primary,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _value.toStringAsFixed(1),
                    style: ChanelTypography.displaySmall.copyWith(
                      color: widget.palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '/20',
                    style: ChanelTypography.labelMedium.copyWith(
                      color: widget.palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ChanelTheme.spacing4),

            // Slider
            Slider(
              value: _value,
              min: 8,
              max: 20,
              divisions: 24,
              activeColor: widget.palette.primary,
              inactiveColor: widget.palette.borderLight,
              label: _value.toStringAsFixed(1),
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() => _value = value);
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '8',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: widget.palette.textMuted,
                  ),
                ),
                Text(
                  '20',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: widget.palette.textMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: ChanelTheme.spacing4),

            // Suggestions rapides
            Wrap(
              spacing: ChanelTheme.spacing2,
              children: [10.0, 12.0, 14.0, 16.0, 18.0].map((target) {
                final isSelected = (_value - target).abs() < 0.1;
                return ChoiceChip(
                  label: Text('${target.toInt()}/20'),
                  selected: isSelected,
                  selectedColor: widget.palette.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : widget.palette.textSecondary,
                  ),
                  backgroundColor: widget.palette.backgroundSecondary,
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    setState(() => _value = target);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: ChanelTheme.spacing6),

            // Bouton de validation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onSave(_value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                  ),
                ),
                child: const Text(
                  'Définir cet objectif',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

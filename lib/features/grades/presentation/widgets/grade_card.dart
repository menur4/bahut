import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/share_service.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/chanel_theme.dart';
import '../../../../core/theme/chanel_typography.dart';
import '../../data/models/grade_model.dart';

/// Carte affichant une note individuelle
class GradeCard extends StatelessWidget {
  final GradeModel grade;
  final bool isNew;
  final AppColorPalette? palette;

  const GradeCard({
    super.key,
    required this.grade,
    this.isNew = false,
    this.palette,
  });

  void _showGradeDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GradeDetailSheet(grade: grade, palette: palette),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppThemes.classique;
    final valeur = grade.valeurDouble;
    final valeurSur20 = grade.valeurSur20;

    return InkWell(
      onTap: () => _showGradeDetail(context),
      child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ChanelTheme.spacing4,
        vertical: ChanelTheme.spacing3,
      ),
      decoration: BoxDecoration(
        color: isNew ? p.primary.withOpacity(0.03) : null,
        border: Border(
          bottom: BorderSide(color: p.borderLight, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Note
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: valeurSur20 != null
                  ? p.gradeColor(valeurSur20).withOpacity(0.1)
                  : p.backgroundTertiary,
              borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  valeur != null ? valeur.toStringAsFixed(valeur.truncateToDouble() == valeur ? 0 : 1) : grade.valeur,
                  style: ChanelTypography.headlineMedium.copyWith(
                    color: valeurSur20 != null
                        ? p.gradeColor(valeurSur20)
                        : p.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '/${grade.noteSur}',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: p.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: ChanelTheme.spacing3),

          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre du devoir avec badge "Nouveau"
                Row(
                  children: [
                    if (isNew) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ChanelTheme.spacing2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: p.primary,
                          borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                        ),
                        child: Text(
                          'NOUVEAU',
                          style: ChanelTypography.labelSmall.copyWith(
                            color: p.textInverse,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: ChanelTheme.spacing2),
                    ],
                    Expanded(
                      child: Text(
                        grade.devoir,
                        style: ChanelTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: p.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing1),

                // Métadonnées
                Wrap(
                  spacing: ChanelTheme.spacing2,
                  runSpacing: ChanelTheme.spacing1,
                  children: [
                    // Date
                    if (grade.dateTime != null)
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        text: DateFormat('dd/MM/yyyy').format(grade.dateTime!),
                        palette: p,
                      ),

                    // Coefficient
                    if (grade.coefDouble != 1.0)
                      _MetaChip(
                        icon: Icons.scale_outlined,
                        text: 'Coef ${grade.coef}',
                        palette: p,
                      ),

                    // Moyenne classe
                    if (grade.moyenneClasseDouble != null)
                      _MetaChip(
                        icon: Icons.groups_outlined,
                        text: 'Classe: ${grade.moyenneClasse}',
                        palette: p,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

/// Bottom sheet affichant les détails d'une note
class _GradeDetailSheet extends ConsumerWidget {
  final GradeModel grade;
  final AppColorPalette? palette;

  const _GradeDetailSheet({required this.grade, this.palette});

  Future<void> _shareGrade(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;
    final shareService = ref.read(shareServiceProvider);
    await shareService.shareGrade(
      grade,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = palette ?? AppThemes.classique;
    final valeur = grade.valeurDouble;
    final valeurSur20 = grade.valeurSur20;

    return Container(
      decoration: BoxDecoration(
        color: p.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(ChanelTheme.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle et bouton partage
          Padding(
            padding: const EdgeInsets.only(
              top: ChanelTheme.spacing2,
              right: ChanelTheme.spacing2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Spacer pour centrer le handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                IconButton(
                  onPressed: () => _shareGrade(context, ref),
                  icon: Icon(
                    Icons.share_outlined,
                    color: p.textSecondary,
                    size: 20,
                  ),
                  tooltip: 'Partager',
                ),
              ],
            ),
          ),

          // Contenu
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ChanelTheme.spacing6,
              0,
              ChanelTheme.spacing6,
              ChanelTheme.spacing6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec note
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: valeurSur20 != null
                            ? p.gradeColor(valeurSur20).withOpacity(0.1)
                            : p.backgroundTertiary,
                        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            valeur != null
                                ? valeur.toStringAsFixed(valeur.truncateToDouble() == valeur ? 0 : 1)
                                : grade.valeur,
                            style: ChanelTypography.headlineLarge.copyWith(
                              color: valeurSur20 != null
                                  ? p.gradeColor(valeurSur20)
                                  : p.textTertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/${grade.noteSur}',
                            style: ChanelTypography.labelMedium.copyWith(
                              color: p.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: ChanelTheme.spacing4),

                    // Titre et matière
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grade.devoir,
                            style: ChanelTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: p.textPrimary,
                            ),
                          ),
                          const SizedBox(height: ChanelTheme.spacing1),
                          Text(
                            grade.libelleMatiere,
                            style: ChanelTypography.bodyMedium.copyWith(
                              color: p.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ChanelTheme.spacing6),

                // Informations détaillées
                _buildDetailSection(p, [
                  if (grade.dateTime != null)
                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(grade.dateTime!),
                      palette: p,
                    ),
                  _DetailRow(
                    icon: Icons.scale_outlined,
                    label: 'Coefficient',
                    value: grade.coef,
                    palette: p,
                  ),
                  if (grade.typeDevoir != null && grade.typeDevoir!.isNotEmpty)
                    _DetailRow(
                      icon: Icons.assignment_outlined,
                      label: 'Type',
                      value: grade.typeDevoir!,
                      palette: p,
                    ),
                  if (valeurSur20 != null)
                    _DetailRow(
                      icon: Icons.percent_outlined,
                      label: 'Ramené sur 20',
                      value: valeurSur20.toStringAsFixed(2),
                      palette: p,
                    ),
                ]),

                // Statistiques de la classe
                if (grade.moyenneClasseDouble != null ||
                    grade.minClasse != null ||
                    grade.maxClasse != null) ...[
                  const SizedBox(height: ChanelTheme.spacing4),
                  Text(
                    'STATISTIQUES DE LA CLASSE',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: p.textMuted,
                      letterSpacing: ChanelTypography.letterSpacingWider,
                    ),
                  ),
                  const SizedBox(height: ChanelTheme.spacing3),
                  _buildDetailSection(p, [
                    if (grade.moyenneClasseDouble != null)
                      _DetailRow(
                        icon: Icons.groups_outlined,
                        label: 'Moyenne',
                        value: grade.moyenneClasse!,
                        palette: p,
                      ),
                    if (grade.minClasse != null)
                      _DetailRow(
                        icon: Icons.arrow_downward_outlined,
                        label: 'Minimum',
                        value: grade.minClasse!,
                        palette: p,
                      ),
                    if (grade.maxClasse != null)
                      _DetailRow(
                        icon: Icons.arrow_upward_outlined,
                        label: 'Maximum',
                        value: grade.maxClasse!,
                        palette: p,
                      ),
                  ]),
                ],

                // Commentaire
                if (grade.commentaire != null && grade.commentaire!.isNotEmpty) ...[
                  const SizedBox(height: ChanelTheme.spacing4),
                  Text(
                    'COMMENTAIRE',
                    style: ChanelTypography.labelSmall.copyWith(
                      color: p.textMuted,
                      letterSpacing: ChanelTypography.letterSpacingWider,
                    ),
                  ),
                  const SizedBox(height: ChanelTheme.spacing2),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ChanelTheme.spacing3),
                    decoration: BoxDecoration(
                      color: p.backgroundSecondary,
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                    ),
                    child: Text(
                      grade.commentaire!,
                      style: ChanelTypography.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        color: p.textPrimary,
                      ),
                    ),
                  ),
                ],

                // Note non significative
                if (grade.nonSignificatif) ...[
                  const SizedBox(height: ChanelTheme.spacing4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(ChanelTheme.spacing3),
                    decoration: BoxDecoration(
                      color: p.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                      border: Border.all(color: p.warning.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: p.warning,
                        ),
                        const SizedBox(width: ChanelTheme.spacing2),
                        Expanded(
                          child: Text(
                            'Cette note n\'est pas prise en compte dans le calcul de la moyenne',
                            style: ChanelTypography.bodySmall.copyWith(
                              color: p.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Espace en bas pour le safe area
                SizedBox(height: MediaQuery.of(context).padding.bottom + ChanelTheme.spacing4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(AppColorPalette p, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: p.backgroundSecondary,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final AppColorPalette palette;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChanelTheme.spacing4,
        vertical: ChanelTheme.spacing3,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: palette.textMuted,
          ),
          const SizedBox(width: ChanelTheme.spacing3),
          Expanded(
            child: Text(
              label,
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: ChanelTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final AppColorPalette palette;

  const _MetaChip({
    required this.icon,
    required this.text,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: palette.textMuted,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: ChanelTypography.labelSmall.copyWith(
            color: palette.textTertiary,
          ),
        ),
      ],
    );
  }
}

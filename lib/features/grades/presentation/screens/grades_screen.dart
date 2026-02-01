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
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/grade_model.dart';
import '../../../../shared/widgets/skeleton_widgets.dart';
import '../providers/grades_provider.dart';
import '../widgets/grade_card.dart';
import '../widgets/period_selector.dart';

/// Écran de liste des notes
class GradesScreen extends ConsumerStatefulWidget {
  const GradesScreen({super.key});

  @override
  ConsumerState<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends ConsumerState<GradesScreen> {
  final Map<String, bool> _expandedSubjects = {};
  Uint8List? _photoBytes;
  bool _photoLoading = false;
  String? _lastPhotoUrl;

  @override
  void initState() {
    super.initState();
    // Charger les notes au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradesStateProvider.notifier).fetchGrades();
      _loadPhoto();

      // Écouter les changements de l'enfant sélectionné pour recharger la photo
      ref.listenManual(
        authStateProvider.select((s) => s.selectedChild?.id),
        (previous, next) {
          debugPrint('[GRADES] selectedChild changé: $previous -> $next');
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

    debugPrint('[GRADES] _loadPhoto appelé');
    debugPrint('[GRADES] selectedChild: ${selectedChild?.prenom} ${selectedChild?.nom}');
    debugPrint('[GRADES] photo field: "${selectedChild?.photo}"');

    if (selectedChild?.photo == null || selectedChild!.photo!.isEmpty) {
      debugPrint('[GRADES] Pas de photo URL disponible');
      return;
    }

    var photoUrl = selectedChild.photo!;
    debugPrint('[GRADES] URL originale: $photoUrl');

    if (photoUrl.startsWith('//')) {
      photoUrl = 'https:$photoUrl';
      debugPrint('[GRADES] URL corrigée: $photoUrl');
    }

    // Ne pas recharger si c'est la même URL
    if (photoUrl == _lastPhotoUrl && _photoBytes != null) {
      debugPrint('[GRADES] Photo déjà chargée, skip');
      return;
    }

    setState(() {
      _photoLoading = true;
      _lastPhotoUrl = photoUrl;
    });

    try {
      debugPrint('[GRADES] Téléchargement de la photo...');
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

      debugPrint('[GRADES] Réponse: status=${response.statusCode}, data=${response.data?.length} bytes');

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _photoBytes = Uint8List.fromList(response.data!);
          _photoLoading = false;
        });
        debugPrint('[GRADES] Photo chargée avec succès: ${_photoBytes!.length} bytes');
      } else {
        debugPrint('[GRADES] Réponse invalide');
        setState(() {
          _photoLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[GRADES] Erreur chargement photo via Dio: $e');
      setState(() {
        _photoLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await ref.read(gradesStateProvider.notifier).fetchGrades(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(currentPaletteProvider);
    final gradesState = ref.watch(gradesStateProvider);
    final authState = ref.watch(authStateProvider);
    final selectedChild = authState.selectedChild;

    // Utiliser les bytes de la photo chargée via Dio
    ImageProvider? childPhoto;
    if (_photoBytes != null) {
      childPhoto = MemoryImage(_photoBytes!);
    }

    return PlatformScaffold(
      backgroundColor: palette.backgroundSecondary,
      appBar: PlatformAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _photoLoading
              ? CircleAvatar(
                  backgroundColor: palette.backgroundTertiary,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: palette.textMuted,
                    ),
                  ),
                )
              : childPhoto != null
                  ? ClipOval(
                      child: Image(
                        image: childPhoto,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: palette.backgroundTertiary,
                      child: Text(
                        selectedChild?.prenom.isNotEmpty == true
                            ? selectedChild!.prenom[0].toUpperCase()
                            : '?',
                        style: ChanelTypography.titleMedium.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
        ),
        title: Text(
          selectedChild?.prenom.toUpperCase() ?? 'MES NOTES',
          style: ChanelTypography.titleMedium.copyWith(
            letterSpacing: ChanelTypography.letterSpacingWider,
            color: palette.textPrimary,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: palette.backgroundPrimary,
          actions: [
            IconButton(
              icon: Icon(Icons.analytics_outlined, color: palette.textPrimary),
              tooltip: 'Statistiques',
              onPressed: () => context.push('/statistics'),
            ),
          ],
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          border: null,
          backgroundColor: palette.backgroundPrimary,
          trailing: GestureDetector(
            onTap: () => context.push('/statistics'),
            child: Icon(Icons.analytics_outlined, color: palette.textPrimary),
          ),
        ),
      ),
      body: Column(
        children: [
          // Sélecteur de période
          if (gradesState.periods.isNotEmpty)
            Container(
              color: palette.backgroundPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: ChanelTheme.spacing4,
                vertical: ChanelTheme.spacing2,
              ),
              child: PeriodSelector(
                periods: gradesState.periods,
                selectedPeriod: gradesState.selectedPeriod,
                onPeriodChanged: (period) {
                  ref.read(gradesStateProvider.notifier).selectPeriod(period);
                },
                palette: palette,
              ),
            ),

          // Contenu principal
          Expanded(
            child: _buildContent(gradesState, palette),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(GradesState state, AppColorPalette palette) {
    if (state.isLoading && state.grades.isEmpty) {
      return const SkeletonGradesScreen();
    }

    if (state.errorMessage != null && state.grades.isEmpty) {
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

    if (state.filteredGrades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: palette.textMuted,
            ),
            const SizedBox(height: ChanelTheme.spacing4),
            Text(
              'Aucune note pour cette période',
              style: ChanelTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final gradesBySubject = state.gradesBySubject;
    final generalAverage = state.generalAverage;
    final classGeneralAverage = state.classGeneralAverage;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: palette.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        itemCount: gradesBySubject.length + (generalAverage != null ? 1 : 0),
        itemBuilder: (context, index) {
          // Premier élément : moyenne générale
          if (generalAverage != null && index == 0) {
            return _GeneralAverageCard(
              average: generalAverage,
              classAverage: classGeneralAverage,
              palette: palette,
            );
          }

          // Ajuster l'index si la moyenne générale est affichée
          final adjustedIndex = generalAverage != null ? index - 1 : index;
          final entry = gradesBySubject.entries.elementAt(adjustedIndex);
          final subjectName = entry.key;
          final grades = entry.value;
          final isExpanded = _expandedSubjects[subjectName] ?? false;

          // Récupérer les infos de la matière (professeur, moyenne classe)
          final codeMatiere = grades.isNotEmpty ? grades.first.codeMatiere : '';
          final subjectInfo = state.getSubjectInfo(codeMatiere);

          return _SubjectSection(
            subjectName: subjectName,
            grades: grades,
            isExpanded: isExpanded,
            newGradeIds: state.newGradeIds,
            subjectInfo: subjectInfo,
            palette: palette,
            onToggle: () {
              setState(() {
                _expandedSubjects[subjectName] = !isExpanded;
              });
            },
          );
        },
      ),
    );
  }
}

class _SubjectSection extends StatelessWidget {
  final String subjectName;
  final List<GradeModel> grades;
  final bool isExpanded;
  final Set<int> newGradeIds;
  final SubjectInfo? subjectInfo;
  final VoidCallback onToggle;
  final AppColorPalette palette;

  const _SubjectSection({
    required this.subjectName,
    required this.grades,
    required this.isExpanded,
    required this.newGradeIds,
    this.subjectInfo,
    required this.onToggle,
    required this.palette,
  });

  /// Grouper les notes par sous-matière
  Map<String?, List<GradeModel>> get _gradesBySubSubject {
    final map = <String?, List<GradeModel>>{};
    for (final grade in grades) {
      final subSubject = grade.subSubjectName;
      map.putIfAbsent(subSubject, () => []).add(grade);
    }
    return map;
  }

  /// Vérifie si cette matière a des sous-matières
  bool get _hasSubSubjects {
    return grades.any((g) => g.subSubjectName != null);
  }

  /// Construit la liste des notes, groupées par sous-matière si nécessaire
  List<Widget> _buildGradesList() {
    if (!_hasSubSubjects) {
      // Pas de sous-matières, afficher toutes les notes directement
      return grades.map((grade) => GradeCard(
        grade: grade,
        isNew: newGradeIds.contains(grade.id),
        palette: palette,
      )).toList();
    }

    // Avec sous-matières, grouper les notes
    final widgets = <Widget>[];
    final bySubSubject = _gradesBySubSubject;

    // Trier les sous-matières (null en premier pour les notes sans sous-matière)
    final sortedKeys = bySubSubject.keys.toList()
      ..sort((a, b) {
        if (a == null) return -1;
        if (b == null) return 1;
        return a.compareTo(b);
      });

    for (final subSubject in sortedKeys) {
      final subGrades = bySubSubject[subSubject]!;

      // Header de la sous-matière
      if (subSubject != null) {
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChanelTheme.spacing4,
              vertical: ChanelTheme.spacing2,
            ),
            color: palette.backgroundTertiary,
            child: Row(
              children: [
                Text(
                  subSubject,
                  style: ChanelTypography.labelMedium.copyWith(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Notes de cette sous-matière
      widgets.addAll(subGrades.map((grade) => GradeCard(
        grade: grade,
        isNew: newGradeIds.contains(grade.id),
        palette: palette,
      )));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    // Calculer la moyenne de la matière
    double? subjectAverage;
    double sumWeighted = 0;
    double sumCoef = 0;
    for (final grade in grades) {
      final val = grade.valeurSur20;
      if (val != null && grade.isValidForCalculation) {
        sumWeighted += val * grade.coefDouble;
        sumCoef += grade.coefDouble;
      }
    }
    if (sumCoef > 0) {
      subjectAverage = sumWeighted / sumCoef;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: ChanelTheme.spacing3),
      decoration: BoxDecoration(
        color: palette.backgroundCard,
        borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        border: Border.all(color: palette.borderLight),
      ),
      child: Column(
        children: [
          // Header de la matière
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(ChanelTheme.spacing4),
              child: Row(
                children: [
                  // Nom de la matière et professeur
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          style: ChanelTypography.titleMedium.copyWith(
                            color: palette.textPrimary,
                          ),
                        ),
                        if (subjectInfo?.teacher != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subjectInfo!.teacher!,
                            style: ChanelTypography.bodySmall.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Moyennes (élève et classe)
                  if (subjectAverage != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ChanelTheme.spacing3,
                            vertical: ChanelTheme.spacing1,
                          ),
                          decoration: BoxDecoration(
                            color: palette.gradeColor(subjectAverage).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                          ),
                          child: Text(
                            subjectAverage.toStringAsFixed(1),
                            style: ChanelTypography.labelLarge.copyWith(
                              color: palette.gradeColor(subjectAverage),
                            ),
                          ),
                        ),
                        if (subjectInfo?.classAverage != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Classe: ${subjectInfo!.classAverage!.toStringAsFixed(1)}',
                            style: ChanelTypography.labelSmall.copyWith(
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: ChanelTheme.spacing2),
                  ],

                  // Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Liste des notes (groupées par sous-matière si applicable)
          if (isExpanded) ...[
            Divider(height: 1, color: palette.borderLight),
            ..._buildGradesList(),
          ],
        ],
      ),
    );
  }
}

/// Carte affichant la moyenne générale
class _GeneralAverageCard extends StatelessWidget {
  final double average;
  final double? classAverage;
  final AppColorPalette palette;

  const _GeneralAverageCard({
    required this.average,
    this.classAverage,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/statistics'),
      child: Container(
        margin: const EdgeInsets.only(bottom: ChanelTheme.spacing4),
        padding: const EdgeInsets.all(ChanelTheme.spacing4),
        decoration: BoxDecoration(
          color: palette.primary,
          borderRadius: BorderRadius.circular(ChanelTheme.radiusMd),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOYENNE GÉNÉRALE',
                      style: ChanelTypography.labelLarge.copyWith(
                        color: palette.textInverse,
                        letterSpacing: ChanelTypography.letterSpacingWider,
                      ),
                    ),
                    if (classAverage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Classe: ${classAverage!.toStringAsFixed(2)}',
                        style: ChanelTypography.bodySmall.copyWith(
                          color: palette.textInverse.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ChanelTheme.spacing4,
                    vertical: ChanelTheme.spacing2,
                  ),
                  decoration: BoxDecoration(
                    color: palette.backgroundCard,
                    borderRadius: BorderRadius.circular(ChanelTheme.radiusSm),
                  ),
                  child: Text(
                    average.toStringAsFixed(2),
                    style: ChanelTypography.headlineMedium.copyWith(
                      color: palette.gradeColor(average),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ChanelTheme.spacing2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 16,
                  color: palette.textInverse.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Voir les statistiques',
                  style: ChanelTypography.labelSmall.copyWith(
                    color: palette.textInverse.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: palette.textInverse.withOpacity(0.7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

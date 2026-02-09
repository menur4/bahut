import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/demo/demo_data.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/grade_model.dart';

/// Informations sur une matière (nom, professeur, moyenne classe)
class SubjectInfo {
  final String name;
  final String? teacher;
  final double? classAverage;

  const SubjectInfo({
    required this.name,
    this.teacher,
    this.classAverage,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'teacher': teacher,
    'classAverage': classAverage,
  };

  factory SubjectInfo.fromJson(Map<String, dynamic> json) => SubjectInfo(
    name: json['name'] as String,
    teacher: json['teacher'] as String?,
    classAverage: (json['classAverage'] as num?)?.toDouble(),
  );
}

/// État des notes
class GradesState {
  final bool isLoading;
  final List<GradeModel> grades;
  final List<PeriodModel> periods;
  final String? selectedPeriod;
  final String? errorMessage;
  final DateTime? lastSync;
  final Set<int> newGradeIds;
  /// Correspondance codeMatiere -> infos de discipline (depuis periodes.disciplines)
  final Map<String, SubjectInfo> subjectInfos;

  const GradesState({
    this.isLoading = false,
    this.grades = const [],
    this.periods = const [],
    this.selectedPeriod,
    this.errorMessage,
    this.lastSync,
    this.newGradeIds = const {},
    this.subjectInfos = const {},
  });

  /// Getter pour compatibilité - retourne juste les noms
  Map<String, String> get subjectNames =>
      subjectInfos.map((k, v) => MapEntry(k, v.name));

  /// Vérifie si une note est nouvelle
  bool isNewGrade(int gradeId) => newGradeIds.contains(gradeId);

  /// Nom de la période sélectionnée (ex: "Trimestre 1" au lieu de "A001")
  String? get selectedPeriodName {
    if (selectedPeriod == null) return null;
    final period = periods.where((p) => p.codePeriode == selectedPeriod).firstOrNull;
    return period?.periode;
  }

  /// Notes filtrées par période
  List<GradeModel> get filteredGrades {
    if (selectedPeriod == null) return grades;
    return grades.where((g) => g.codePeriode == selectedPeriod).toList();
  }

  /// Notes groupées par matière principale (codeMatiere)
  /// La clé est le codeMatiere, la valeur contient toutes les notes
  /// (y compris celles des sous-matières)
  Map<String, List<GradeModel>> get gradesBySubjectCode {
    final filtered = filteredGrades;
    final mapByCode = <String, List<GradeModel>>{};
    for (final grade in filtered) {
      mapByCode.putIfAbsent(grade.codeMatiere, () => []).add(grade);
    }
    return mapByCode;
  }

  /// Notes groupées par matière principale (codeMatiere)
  /// La clé est le nom de la matière principale, la valeur contient toutes les notes
  /// (y compris celles des sous-matières)
  Map<String, List<GradeModel>> get gradesBySubject {
    final mapByCode = gradesBySubjectCode;

    // Convertir en map avec le nom de la matière principale comme clé
    final map = <String, List<GradeModel>>{};
    for (final entry in mapByCode.entries) {
      final codeMatiere = entry.key;
      final grades = entry.value;
      // Utiliser le nom de discipline depuis subjectInfos (API) ou fallback sur mainSubjectName
      final subjectName = subjectInfos[codeMatiere]?.name ?? grades.first.mainSubjectName;
      map[subjectName] = grades;
    }

    // Trier par nom de matière
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sorted;
  }

  /// Récupère les infos d'une matière par son code
  SubjectInfo? getSubjectInfo(String codeMatiere) => subjectInfos[codeMatiere];

  /// Calcule la moyenne générale pour la période sélectionnée
  double? get generalAverage {
    final gradesBySub = gradesBySubject;
    if (gradesBySub.isEmpty) return null;

    double sumAverages = 0;
    int countSubjects = 0;

    for (final entry in gradesBySub.entries) {
      final grades = entry.value;
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
        sumAverages += sumWeighted / sumCoef;
        countSubjects++;
      }
    }

    if (countSubjects == 0) return null;
    return sumAverages / countSubjects;
  }

  /// Calcule la moyenne générale de la classe pour la période sélectionnée
  double? get classGeneralAverage {
    final mapByCode = gradesBySubjectCode;
    if (mapByCode.isEmpty) return null;

    double sumAverages = 0;
    int countSubjects = 0;

    for (final codeMatiere in mapByCode.keys) {
      final info = subjectInfos[codeMatiere];
      if (info?.classAverage != null) {
        sumAverages += info!.classAverage!;
        countSubjects++;
      }
    }

    if (countSubjects == 0) return null;
    return sumAverages / countSubjects;
  }

  GradesState copyWith({
    bool? isLoading,
    List<GradeModel>? grades,
    List<PeriodModel>? periods,
    String? selectedPeriod,
    String? errorMessage,
    DateTime? lastSync,
    Set<int>? newGradeIds,
    Map<String, SubjectInfo>? subjectInfos,
  }) {
    return GradesState(
      isLoading: isLoading ?? this.isLoading,
      grades: grades ?? this.grades,
      periods: periods ?? this.periods,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage,
      lastSync: lastSync ?? this.lastSync,
      newGradeIds: newGradeIds ?? this.newGradeIds,
      subjectInfos: subjectInfos ?? this.subjectInfos,
    );
  }
}

/// Provider pour les notes
final gradesStateProvider = StateNotifierProvider<GradesNotifier, GradesState>((ref) {
  return GradesNotifier(ref);
});

/// Notifier pour gérer les notes
class GradesNotifier extends StateNotifier<GradesState> {
  final Ref _ref;

  GradesNotifier(this._ref) : super(const GradesState()) {
    _loadCachedGrades();
  }

  /// Charger les notes depuis le cache
  Future<void> _loadCachedGrades() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(AppConstants.prefGradesCache);
      final lastSyncStr = prefs.getString(AppConstants.prefLastSync);

      if (cacheJson != null) {
        final Map<String, dynamic> cache = jsonDecode(cacheJson);
        final gradesList = (cache['grades'] as List?)
            ?.map((e) => GradeModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
        final periodsList = (cache['periods'] as List?)
            ?.map((e) => PeriodModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];

        // Charger subjectInfos (nouveau format) ou subjectNames (ancien format)
        Map<String, SubjectInfo> subjectInfosMap = {};
        if (cache['subjectInfos'] != null) {
          subjectInfosMap = (cache['subjectInfos'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, SubjectInfo.fromJson(v as Map<String, dynamic>)));
        } else if (cache['subjectNames'] != null) {
          // Migration depuis l'ancien format
          subjectInfosMap = (cache['subjectNames'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, SubjectInfo(name: v as String)));
        }

        DateTime? lastSync;
        if (lastSyncStr != null) {
          lastSync = DateTime.tryParse(lastSyncStr);
        }

        // Sélectionner la période en cours
        final currentPeriod = _findCurrentPeriod(periodsList);

        state = state.copyWith(
          grades: gradesList,
          periods: periodsList,
          selectedPeriod: currentPeriod?.codePeriode ?? (periodsList.isNotEmpty ? periodsList.first.codePeriode : null),
          lastSync: lastSync,
          subjectInfos: subjectInfosMap,
        );
      }
    } catch (e) {
      // Ignorer les erreurs de cache
    }
  }

  /// Récupérer les notes depuis l'API
  Future<void> fetchGrades({bool forceRefresh = false}) async {
    final authState = _ref.read(authStateProvider);
    final selectedChild = authState.selectedChild;

    if (selectedChild == null) {
      state = state.copyWith(errorMessage: 'Aucun élève sélectionné');
      return;
    }

    // Mode démonstration : utiliser les données fictives
    if (authState.isDemoMode) {
      await _loadDemoGrades();
      return;
    }

    // Vérifier si le cache est valide
    if (!forceRefresh && state.lastSync != null) {
      final cacheAge = DateTime.now().difference(state.lastSync!);
      if (cacheAge.inHours < AppConstants.cacheValidityHours && state.grades.isNotEmpty) {
        return;
      }
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.post(
        ApiConstants.gradesEndpoint(selectedChild.id),
        queryParameters: {'verbe': 'get'},
      );

      // Parser les notes
      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ServerException(message: 'Réponse invalide');
      }

      // Extraire les notes
      final notesList = data['notes'] as List? ?? [];
      print('[GRADES] Nombre total de notes reçues: ${notesList.length}');

      // Debug: lister toutes les matières uniques avec leurs détails
      final matieresParCode = <String, Set<String>>{};
      for (final note in notesList) {
        final noteMap = note as Map<String, dynamic>;
        final codeMatiere = noteMap['codeMatiere'] as String? ?? 'UNKNOWN';
        final libelleMatiere = noteMap['libelleMatiere'] as String? ?? '';
        final codeSousMatiere = noteMap['codeSousMatiere'] as String?;
        final sousMatiere = codeSousMatiere != null && codeSousMatiere.isNotEmpty
            ? ' (sous: $codeSousMatiere)'
            : '';
        matieresParCode.putIfAbsent(codeMatiere, () => {}).add('$libelleMatiere$sousMatiere');
      }
      print('[GRADES] Matières par code:');
      for (final entry in matieresParCode.entries) {
        print('  ${entry.key}: ${entry.value}');
      }
      print('[GRADES] Nombre de matières uniques (par codeMatiere): ${matieresParCode.length}');

      final grades = notesList
          .map((e) => GradeModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Extraire les périodes
      final periodesList = data['periodes'] as List? ?? [];

      // Extraire la correspondance codeMatiere -> discipline depuis les périodes
      // On ne garde que les disciplines avec coef > 0 (matières principales, pas les sous-matières)
      final subjectInfos = <String, SubjectInfo>{};
      if (periodesList.isNotEmpty) {
        final firstPeriod = periodesList.first as Map<String, dynamic>;
        if (firstPeriod.containsKey('ensembleMatieres')) {
          final ensembleMatieres = firstPeriod['ensembleMatieres'] as Map<String, dynamic>?;
          if (ensembleMatieres != null && ensembleMatieres.containsKey('disciplines')) {
            final disciplines = ensembleMatieres['disciplines'] as List?;
            if (disciplines != null) {
              print('[GRADES] Disciplines trouvées dans périodes:');
              for (final disc in disciplines) {
                final d = disc as Map<String, dynamic>;
                final codeMatiere = d['codeMatiere'] as String?;
                final disciplineName = d['discipline'] as String?;
                final coef = d['coef'];
                final professeurs = d['professeurs'] as List?;
                final moyenneClasse = d['moyenneClasse'] as String?;

                // Extraire le premier professeur s'il y en a
                String? teacher;
                if (professeurs != null && professeurs.isNotEmpty) {
                  final firstProf = professeurs.first;
                  if (firstProf is Map<String, dynamic>) {
                    teacher = firstProf['nom'] as String?;
                  } else if (firstProf is String) {
                    teacher = firstProf;
                  }
                }

                // Parser la moyenne de classe
                double? classAvg;
                if (moyenneClasse != null && moyenneClasse.isNotEmpty) {
                  classAvg = double.tryParse(moyenneClasse.replaceAll(',', '.'));
                }

                print('  $codeMatiere: $disciplineName (coef: $coef, prof: $teacher, moy: $classAvg)');

                // Ne garder que les matières principales (coef > 0)
                if (codeMatiere != null && disciplineName != null) {
                  final coefValue = coef is num ? coef.toDouble() : double.tryParse(coef?.toString() ?? '0') ?? 0;
                  if (coefValue > 0 && !subjectInfos.containsKey(codeMatiere)) {
                    subjectInfos[codeMatiere] = SubjectInfo(
                      name: disciplineName,
                      teacher: teacher,
                      classAverage: classAvg,
                    );
                  }
                }
              }
              print('[GRADES] Correspondance subjectInfos: $subjectInfos');
            }
          }
        }
      }

      final periods = periodesList
          .map((e) => PeriodModel.fromJson(e as Map<String, dynamic>))
          .where((p) => !p.annuel) // Exclure la période annuelle
          .toList();

      // Identifier les nouvelles notes
      final prefs = await SharedPreferences.getInstance();
      final seenIdsJson = prefs.getString(AppConstants.prefSeenGradeIds);
      final seenIds = seenIdsJson != null
          ? Set<int>.from(jsonDecode(seenIdsJson) as List)
          : <int>{};

      // Trouver les IDs des nouvelles notes
      final currentIds = grades.map((g) => g.id).toSet();
      final newIds = currentIds.difference(seenIds);

      // Sauvegarder tous les IDs comme vus
      await prefs.setString(
        AppConstants.prefSeenGradeIds,
        jsonEncode(currentIds.toList()),
      );

      // Envoyer une notification si de nouvelles notes
      if (newIds.isNotEmpty) {
        final notificationService = _ref.read(notificationServiceProvider);
        // Trouver le nom de la matière de la première nouvelle note
        final newGrade = grades.firstWhere((g) => newIds.contains(g.id));
        await notificationService.showNewGradesNotification(
          count: newIds.length,
          subjectName: newGrade.mainSubjectName,
        );
      }

      // Sauvegarder dans le cache
      await _saveToCache(grades, periods, subjectInfos);

      // Sélectionner la période en cours (basée sur la date actuelle)
      final currentPeriod = _findCurrentPeriod(periods);

      state = state.copyWith(
        isLoading: false,
        grades: grades,
        periods: periods,
        selectedPeriod: currentPeriod?.codePeriode ?? (periods.isNotEmpty ? periods.first.codePeriode : null),
        lastSync: DateTime.now(),
        newGradeIds: newIds,
        subjectInfos: subjectInfos,
      );
    } on AuthException catch (e) {
      if (e.isTokenExpired) {
        // Tenter de rafraîchir le token
        final refreshed = await _ref.read(authStateProvider.notifier).refreshToken();
        if (refreshed) {
          return fetchGrades(forceRefresh: true);
        }
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } on NetworkException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Pas de connexion internet',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la récupération des notes',
      );
    }
  }

  /// Charger les notes de démonstration
  Future<void> _loadDemoGrades() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simuler un léger délai réseau pour plus de réalisme
    await Future.delayed(const Duration(milliseconds: 500));

    final grades = DemoData.demoGrades;
    final periods = DemoData.demoPeriods;

    // Convertir les infos de matières démo en SubjectInfo
    final subjectInfos = DemoData.demoSubjectInfos.map(
      (code, info) => MapEntry(
        code,
        SubjectInfo(
          name: info['name'] as String,
          teacher: info['teacher'] as String?,
          classAverage: (info['classAverage'] as num?)?.toDouble(),
        ),
      ),
    );

    // Sélectionner la période en cours
    final currentPeriod = _findCurrentPeriod(periods);

    state = state.copyWith(
      isLoading: false,
      grades: grades,
      periods: periods,
      selectedPeriod: currentPeriod?.codePeriode ?? periods.first.codePeriode,
      lastSync: DateTime.now(),
      newGradeIds: const {},
      subjectInfos: subjectInfos,
    );
  }

  /// Sauvegarder les notes dans le cache
  Future<void> _saveToCache(List<GradeModel> grades, List<PeriodModel> periods, Map<String, SubjectInfo> subjectInfos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cache = {
        'grades': grades.map((e) => e.toJson()).toList(),
        'periods': periods.map((e) => e.toJson()).toList(),
        'subjectInfos': subjectInfos.map((k, v) => MapEntry(k, v.toJson())),
      };
      await prefs.setString(AppConstants.prefGradesCache, jsonEncode(cache));
      await prefs.setString(AppConstants.prefLastSync, DateTime.now().toIso8601String());
    } catch (e) {
      // Ignorer les erreurs de sauvegarde
    }
  }

  /// Sélectionner une période
  void selectPeriod(String? period) {
    state = state.copyWith(selectedPeriod: period);
  }

  /// Trouve la période en cours basée sur la date actuelle
  PeriodModel? _findCurrentPeriod(List<PeriodModel> periods) {
    if (periods.isEmpty) return null;

    final now = DateTime.now();

    for (final period in periods) {
      if (period.dateDebut != null && period.dateFin != null) {
        try {
          final debut = DateTime.parse(period.dateDebut!);
          final fin = DateTime.parse(period.dateFin!);

          if (now.isAfter(debut) && now.isBefore(fin.add(const Duration(days: 1)))) {
            return period;
          }
        } catch (_) {
          // Ignorer les erreurs de parsing de date
        }
      }
    }

    // Si aucune période ne correspond, retourner la dernière non clôturée
    // ou la dernière période
    for (final period in periods.reversed) {
      if (!period.cloture) {
        return period;
      }
    }

    return periods.isNotEmpty ? periods.last : null;
  }

  /// Vider le cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefGradesCache);
    await prefs.remove(AppConstants.prefLastSync);
    state = const GradesState();
  }
}

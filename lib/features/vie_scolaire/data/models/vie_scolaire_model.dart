import 'package:freezed_annotation/freezed_annotation.dart';

part 'vie_scolaire_model.freezed.dart';
part 'vie_scolaire_model.g.dart';

/// Modèle pour les absences et retards
@freezed
class AbsenceRetardModel with _$AbsenceRetardModel {
  const factory AbsenceRetardModel({
    required int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') required String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    @Default(false) bool justifie,
    @JsonKey(name: 'typeJustification') String? typeJustification,
    String? commentaire,
    String? motif,
  }) = _AbsenceRetardModel;

  factory AbsenceRetardModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenceRetardModelFromJson(json);
}

/// Modèle pour les sanctions et encouragements
@freezed
class SanctionEncouragementModel with _$SanctionEncouragementModel {
  const factory SanctionEncouragementModel({
    required int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') required String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    String? motif,
    @Default(false) bool justifie,
    String? par,
    String? commentaire,
    @JsonKey(name: 'aFaire') String? aFaire,
    @JsonKey(name: 'dateDeroulement') String? dateDeroulement,
  }) = _SanctionEncouragementModel;

  factory SanctionEncouragementModel.fromJson(Map<String, dynamic> json) =>
      _$SanctionEncouragementModelFromJson(json);
}

/// État complet de la vie scolaire
@freezed
class VieScolaireData with _$VieScolaireData {
  const VieScolaireData._();

  const factory VieScolaireData({
    @Default([]) List<AbsenceRetardModel> absencesRetards,
    @Default([]) List<SanctionEncouragementModel> sanctionsEncouragements,
    VieScolaireParametrage? parametrage,
  }) = _VieScolaireData;

  factory VieScolaireData.fromJson(Map<String, dynamic> json) =>
      _$VieScolaireDataFromJson(json);

  /// Filtrer uniquement les absences
  List<AbsenceRetardModel> get absences =>
      absencesRetards.where((e) => e.typeElement == 'Absence').toList();

  /// Filtrer uniquement les retards
  List<AbsenceRetardModel> get retards =>
      absencesRetards.where((e) => e.typeElement == 'Retard').toList();

  /// Filtrer uniquement les sanctions/punitions
  List<SanctionEncouragementModel> get sanctions =>
      sanctionsEncouragements
          .where((e) =>
              e.typeElement == 'Punition' ||
              e.typeElement == 'Sanction' ||
              e.typeElement == 'Retenue')
          .toList();

  /// Filtrer uniquement les encouragements
  List<SanctionEncouragementModel> get encouragements =>
      sanctionsEncouragements
          .where((e) => e.typeElement == 'Encouragement')
          .toList();

  /// Nombre d'absences non justifiées
  int get absencesNonJustifiees =>
      absences.where((a) => !a.justifie).length;

  /// Nombre de retards non justifiés
  int get retardsNonJustifies =>
      retards.where((r) => !r.justifie).length;
}

/// Paramétrage de la vie scolaire
@freezed
class VieScolaireParametrage with _$VieScolaireParametrage {
  const factory VieScolaireParametrage({
    @Default(false) bool justificationEnLigne,
    @Default(false) bool absenceCommentaire,
    @Default(false) bool retardCommentaire,
    @Default(true) bool sanctionsVisible,
    @Default(false) bool sanctionParQui,
    @Default(false) bool sanctionCommentaire,
    @Default(true) bool encouragementsVisible,
  }) = _VieScolaireParametrage;

  factory VieScolaireParametrage.fromJson(Map<String, dynamic> json) =>
      _$VieScolaireParametrageFromJson(json);
}

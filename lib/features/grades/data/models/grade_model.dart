import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade_model.freezed.dart';
part 'grade_model.g.dart';

/// Modèle de note de l'API École Directe
@freezed
class GradeModel with _$GradeModel {
  const factory GradeModel({
    required int id,
    @JsonKey(name: 'devoir') required String devoir,
    @JsonKey(name: 'codePeriode') required String codePeriode,
    @JsonKey(name: 'codeMatiere') required String codeMatiere,
    @JsonKey(name: 'libelleMatiere') required String libelleMatiere,
    @JsonKey(name: 'codeSousMatiere') String? codeSousMatiere,
    @JsonKey(name: 'typeDevoir') String? typeDevoir,
    @JsonKey(name: 'enpirenote') bool? enpirenote,
    @JsonKey(name: 'coef') required String coef,
    @JsonKey(name: 'noteSur') required String noteSur,
    @JsonKey(name: 'valeur') required String valeur,
    @JsonKey(name: 'nonSignificatif') @Default(false) bool nonSignificatif,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'dateSaisie') String? dateSaisie,
    @JsonKey(name: 'moyenneClasse') String? moyenneClasse,
    @JsonKey(name: 'minClasse') String? minClasse,
    @JsonKey(name: 'maxClasse') String? maxClasse,
    String? commentaire,
    @JsonKey(name: 'elements') @Default([]) List<dynamic> elements,
  }) = _GradeModel;

  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeModelFromJson(json);
}

/// Extension pour parser les valeurs numériques
extension GradeModelExtension on GradeModel {
  /// Note en double (gère les virgules et les absences)
  double? get valeurDouble {
    if (valeur.isEmpty || valeur == 'Abs' || valeur == 'Disp' || valeur == 'NE') {
      return null;
    }
    return double.tryParse(valeur.replaceAll(',', '.'));
  }

  /// Note sur en double
  double get noteSurDouble {
    return double.tryParse(noteSur.replaceAll(',', '.')) ?? 20.0;
  }

  /// Coefficient en double
  double get coefDouble {
    return double.tryParse(coef.replaceAll(',', '.')) ?? 1.0;
  }

  /// Note ramenée sur 20
  double? get valeurSur20 {
    final val = valeurDouble;
    if (val == null) return null;
    final sur = noteSurDouble;
    return (val / sur) * 20;
  }

  /// Moyenne de classe en double
  double? get moyenneClasseDouble {
    if (moyenneClasse == null || moyenneClasse!.isEmpty) return null;
    return double.tryParse(moyenneClasse!.replaceAll(',', '.'));
  }

  /// Date de l'examen formatée
  DateTime? get dateTime {
    if (date == null) return null;
    try {
      // Format API: "2024-01-15"
      return DateTime.parse(date!);
    } catch (_) {
      return null;
    }
  }

  /// Date de saisie formatée (quand la note est apparue dans le système)
  DateTime? get dateSaisieTime {
    if (dateSaisie == null) return null;
    try {
      // Format API: "2024-01-15" ou "2024-01-15 14:30:00"
      return DateTime.parse(dateSaisie!);
    } catch (_) {
      return null;
    }
  }

  /// Indique si c'est une note valide pour le calcul
  bool get isValidForCalculation {
    return valeurDouble != null && !nonSignificatif;
  }

  /// Nom de la matière principale (sans la sous-matière)
  String get mainSubjectName {
    // Si pas de sous-matière, retourner le libellé complet
    if (codeSousMatiere == null || codeSousMatiere!.isEmpty) {
      return libelleMatiere;
    }
    // Sinon, extraire la partie avant le séparateur
    final separators = [' - ', ' / ', ' : '];
    for (final sep in separators) {
      if (libelleMatiere.contains(sep)) {
        return libelleMatiere.split(sep).first.trim();
      }
    }
    return libelleMatiere;
  }

  /// Nom de la sous-matière (si elle existe)
  String? get subSubjectName {
    if (codeSousMatiere == null || codeSousMatiere!.isEmpty) {
      return null;
    }
    final separators = [' - ', ' / ', ' : '];
    for (final sep in separators) {
      if (libelleMatiere.contains(sep)) {
        final parts = libelleMatiere.split(sep);
        if (parts.length > 1) {
          return parts.sublist(1).join(sep).trim();
        }
      }
    }
    return null;
  }
}

/// Modèle de période
@freezed
class PeriodModel with _$PeriodModel {
  const factory PeriodModel({
    @JsonKey(name: 'codePeriode') required String codePeriode,
    @JsonKey(name: 'periode') required String periode,
    @JsonKey(name: 'annuel') @Default(false) bool annuel,
    @JsonKey(name: 'dateDebut') String? dateDebut,
    @JsonKey(name: 'dateFin') String? dateFin,
    @JsonKey(name: 'cloture') @Default(false) bool cloture,
  }) = _PeriodModel;

  factory PeriodModel.fromJson(Map<String, dynamic> json) =>
      _$PeriodModelFromJson(json);
}

/// Modèle de matière
@freezed
class SubjectModel with _$SubjectModel {
  const factory SubjectModel({
    @JsonKey(name: 'codeMatiere') required String codeMatiere,
    @JsonKey(name: 'discipline') required String discipline,
    @JsonKey(name: 'coef') @Default(1.0) double coef,
    String? professeur,
    String? moyenne,
    String? moyenneClasse,
    String? moyenneMin,
    String? moyenneMax,
  }) = _SubjectModel;

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);
}

extension SubjectModelExtension on SubjectModel {
  double? get moyenneDouble {
    if (moyenne == null || moyenne!.isEmpty) return null;
    return double.tryParse(moyenne!.replaceAll(',', '.'));
  }
}

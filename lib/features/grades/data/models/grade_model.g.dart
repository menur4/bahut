// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeModelImpl _$$GradeModelImplFromJson(Map<String, dynamic> json) =>
    _$GradeModelImpl(
      id: (json['id'] as num).toInt(),
      devoir: json['devoir'] as String,
      codePeriode: json['codePeriode'] as String,
      codeMatiere: json['codeMatiere'] as String,
      libelleMatiere: json['libelleMatiere'] as String,
      codeSousMatiere: json['codeSousMatiere'] as String?,
      typeDevoir: json['typeDevoir'] as String?,
      enpirenote: json['enpirenote'] as bool?,
      coef: json['coef'] as String,
      noteSur: json['noteSur'] as String,
      valeur: json['valeur'] as String,
      nonSignificatif: json['nonSignificatif'] as bool? ?? false,
      date: json['date'] as String?,
      dateSaisie: json['dateSaisie'] as String?,
      moyenneClasse: json['moyenneClasse'] as String?,
      minClasse: json['minClasse'] as String?,
      maxClasse: json['maxClasse'] as String?,
      commentaire: json['commentaire'] as String?,
      elements: json['elements'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$GradeModelImplToJson(_$GradeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'devoir': instance.devoir,
      'codePeriode': instance.codePeriode,
      'codeMatiere': instance.codeMatiere,
      'libelleMatiere': instance.libelleMatiere,
      'codeSousMatiere': instance.codeSousMatiere,
      'typeDevoir': instance.typeDevoir,
      'enpirenote': instance.enpirenote,
      'coef': instance.coef,
      'noteSur': instance.noteSur,
      'valeur': instance.valeur,
      'nonSignificatif': instance.nonSignificatif,
      'date': instance.date,
      'dateSaisie': instance.dateSaisie,
      'moyenneClasse': instance.moyenneClasse,
      'minClasse': instance.minClasse,
      'maxClasse': instance.maxClasse,
      'commentaire': instance.commentaire,
      'elements': instance.elements,
    };

_$PeriodModelImpl _$$PeriodModelImplFromJson(Map<String, dynamic> json) =>
    _$PeriodModelImpl(
      codePeriode: json['codePeriode'] as String,
      periode: json['periode'] as String,
      annuel: json['annuel'] as bool? ?? false,
      dateDebut: json['dateDebut'] as String?,
      dateFin: json['dateFin'] as String?,
      cloture: json['cloture'] as bool? ?? false,
    );

Map<String, dynamic> _$$PeriodModelImplToJson(_$PeriodModelImpl instance) =>
    <String, dynamic>{
      'codePeriode': instance.codePeriode,
      'periode': instance.periode,
      'annuel': instance.annuel,
      'dateDebut': instance.dateDebut,
      'dateFin': instance.dateFin,
      'cloture': instance.cloture,
    };

_$SubjectModelImpl _$$SubjectModelImplFromJson(Map<String, dynamic> json) =>
    _$SubjectModelImpl(
      codeMatiere: json['codeMatiere'] as String,
      discipline: json['discipline'] as String,
      coef: (json['coef'] as num?)?.toDouble() ?? 1.0,
      professeur: json['professeur'] as String?,
      moyenne: json['moyenne'] as String?,
      moyenneClasse: json['moyenneClasse'] as String?,
      moyenneMin: json['moyenneMin'] as String?,
      moyenneMax: json['moyenneMax'] as String?,
    );

Map<String, dynamic> _$$SubjectModelImplToJson(_$SubjectModelImpl instance) =>
    <String, dynamic>{
      'codeMatiere': instance.codeMatiere,
      'discipline': instance.discipline,
      'coef': instance.coef,
      'professeur': instance.professeur,
      'moyenne': instance.moyenne,
      'moyenneClasse': instance.moyenneClasse,
      'moyenneMin': instance.moyenneMin,
      'moyenneMax': instance.moyenneMax,
    };

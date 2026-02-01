// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vie_scolaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AbsenceRetardModelImpl _$$AbsenceRetardModelImplFromJson(
  Map<String, dynamic> json,
) => _$AbsenceRetardModelImpl(
  id: (json['id'] as num).toInt(),
  idEleve: (json['idEleve'] as num?)?.toInt(),
  typeElement: json['typeElement'] as String,
  date: json['date'] as String?,
  displayDate: json['displayDate'] as String?,
  libelle: json['libelle'] as String?,
  justifie: json['justifie'] as bool? ?? false,
  typeJustification: json['typeJustification'] as String?,
  commentaire: json['commentaire'] as String?,
  motif: json['motif'] as String?,
);

Map<String, dynamic> _$$AbsenceRetardModelImplToJson(
  _$AbsenceRetardModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'idEleve': instance.idEleve,
  'typeElement': instance.typeElement,
  'date': instance.date,
  'displayDate': instance.displayDate,
  'libelle': instance.libelle,
  'justifie': instance.justifie,
  'typeJustification': instance.typeJustification,
  'commentaire': instance.commentaire,
  'motif': instance.motif,
};

_$SanctionEncouragementModelImpl _$$SanctionEncouragementModelImplFromJson(
  Map<String, dynamic> json,
) => _$SanctionEncouragementModelImpl(
  id: (json['id'] as num).toInt(),
  idEleve: (json['idEleve'] as num?)?.toInt(),
  typeElement: json['typeElement'] as String,
  date: json['date'] as String?,
  displayDate: json['displayDate'] as String?,
  libelle: json['libelle'] as String?,
  motif: json['motif'] as String?,
  justifie: json['justifie'] as bool? ?? false,
  par: json['par'] as String?,
  commentaire: json['commentaire'] as String?,
  aFaire: json['aFaire'] as String?,
  dateDeroulement: json['dateDeroulement'] as String?,
);

Map<String, dynamic> _$$SanctionEncouragementModelImplToJson(
  _$SanctionEncouragementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'idEleve': instance.idEleve,
  'typeElement': instance.typeElement,
  'date': instance.date,
  'displayDate': instance.displayDate,
  'libelle': instance.libelle,
  'motif': instance.motif,
  'justifie': instance.justifie,
  'par': instance.par,
  'commentaire': instance.commentaire,
  'aFaire': instance.aFaire,
  'dateDeroulement': instance.dateDeroulement,
};

_$VieScolaireDataImpl _$$VieScolaireDataImplFromJson(
  Map<String, dynamic> json,
) => _$VieScolaireDataImpl(
  absencesRetards:
      (json['absencesRetards'] as List<dynamic>?)
          ?.map((e) => AbsenceRetardModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sanctionsEncouragements:
      (json['sanctionsEncouragements'] as List<dynamic>?)
          ?.map(
            (e) =>
                SanctionEncouragementModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  parametrage: json['parametrage'] == null
      ? null
      : VieScolaireParametrage.fromJson(
          json['parametrage'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$VieScolaireDataImplToJson(
  _$VieScolaireDataImpl instance,
) => <String, dynamic>{
  'absencesRetards': instance.absencesRetards,
  'sanctionsEncouragements': instance.sanctionsEncouragements,
  'parametrage': instance.parametrage,
};

_$VieScolaireParametrageImpl _$$VieScolaireParametrageImplFromJson(
  Map<String, dynamic> json,
) => _$VieScolaireParametrageImpl(
  justificationEnLigne: json['justificationEnLigne'] as bool? ?? false,
  absenceCommentaire: json['absenceCommentaire'] as bool? ?? false,
  retardCommentaire: json['retardCommentaire'] as bool? ?? false,
  sanctionsVisible: json['sanctionsVisible'] as bool? ?? true,
  sanctionParQui: json['sanctionParQui'] as bool? ?? false,
  sanctionCommentaire: json['sanctionCommentaire'] as bool? ?? false,
  encouragementsVisible: json['encouragementsVisible'] as bool? ?? true,
);

Map<String, dynamic> _$$VieScolaireParametrageImplToJson(
  _$VieScolaireParametrageImpl instance,
) => <String, dynamic>{
  'justificationEnLigne': instance.justificationEnLigne,
  'absenceCommentaire': instance.absenceCommentaire,
  'retardCommentaire': instance.retardCommentaire,
  'sanctionsVisible': instance.sanctionsVisible,
  'sanctionParQui': instance.sanctionParQui,
  'sanctionCommentaire': instance.sanctionCommentaire,
  'encouragementsVisible': instance.encouragementsVisible,
};

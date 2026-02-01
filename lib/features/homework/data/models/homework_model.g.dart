// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeworkModelImpl _$$HomeworkModelImplFromJson(Map<String, dynamic> json) =>
    _$HomeworkModelImpl(
      id: (json['id'] as num?)?.toInt(),
      idDevoir: (json['idDevoir'] as num?)?.toInt(),
      matiere: json['matiere'] as String?,
      codeMatiere: json['codeMatiere'] as String?,
      aFaire: json['aFaire'] as bool?,
      idEleve: (json['idEleve'] as num?)?.toInt(),
      documentsAFaire: json['documentsAFaire'] as bool? ?? false,
      donneLe: json['donneLe'] as String?,
      pourLe: json['pourLe'] as String?,
      effectue: json['effectue'] as bool? ?? false,
      interrogation: json['interrogation'] as String?,
      rendpieces: json['rendpieces'] as bool? ?? false,
      contenu: json['contenu'] as String? ?? '',
      contenuDeSeance: json['contenuDeSeance'] as String?,
    );

Map<String, dynamic> _$$HomeworkModelImplToJson(_$HomeworkModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idDevoir': instance.idDevoir,
      'matiere': instance.matiere,
      'codeMatiere': instance.codeMatiere,
      'aFaire': instance.aFaire,
      'idEleve': instance.idEleve,
      'documentsAFaire': instance.documentsAFaire,
      'donneLe': instance.donneLe,
      'pourLe': instance.pourLe,
      'effectue': instance.effectue,
      'interrogation': instance.interrogation,
      'rendpieces': instance.rendpieces,
      'contenu': instance.contenu,
      'contenuDeSeance': instance.contenuDeSeance,
    };

_$CahierDeTexteJourImpl _$$CahierDeTexteJourImplFromJson(
  Map<String, dynamic> json,
) => _$CahierDeTexteJourImpl(
  date: json['date'] as String,
  devoirs:
      (json['devoirs'] as List<dynamic>?)
          ?.map((e) => HomeworkModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CahierDeTexteJourImplToJson(
  _$CahierDeTexteJourImpl instance,
) => <String, dynamic>{'date': instance.date, 'devoirs': instance.devoirs};

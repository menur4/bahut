// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseModelImpl _$$CourseModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseModelImpl(
      id: (json['id'] as num?)?.toInt(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      text: json['text'] as String?,
      matiere: json['matiere'] as String?,
      codeMatiere: json['codeMatiere'] as String?,
      typeCours: json['typeCours'] as String?,
      salle: json['salle'] as String?,
      prof: json['prof'] as String?,
      classe: json['classe'] as String?,
      classeId: (json['classeId'] as num?)?.toInt(),
      classeCode: json['classeCode'] as String?,
      color: json['color'] as String?,
      isFlexible: json['isFlexible'] as bool? ?? false,
      isModifie: json['isModifie'] as bool? ?? false,
      isAnnule: json['isAnnule'] as bool? ?? false,
      contenuDeSeance: json['contenuDeSeance'] as bool? ?? false,
      devoirAFaire: json['devoirAFaire'] as bool? ?? false,
    );

Map<String, dynamic> _$$CourseModelImplToJson(_$CourseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'text': instance.text,
      'matiere': instance.matiere,
      'codeMatiere': instance.codeMatiere,
      'typeCours': instance.typeCours,
      'salle': instance.salle,
      'prof': instance.prof,
      'classe': instance.classe,
      'classeId': instance.classeId,
      'classeCode': instance.classeCode,
      'color': instance.color,
      'isFlexible': instance.isFlexible,
      'isModifie': instance.isModifie,
      'isAnnule': instance.isAnnule,
      'contenuDeSeance': instance.contenuDeSeance,
      'devoirAFaire': instance.devoirAFaire,
    };

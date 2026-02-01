// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      particule: json['particule'] as String?,
      civilite: json['civilite'] as String?,
      typeCompte: _typeCompteFromJson(json['typeCompte']),
      email: json['email'] as String?,
      photo: json['photo'] as String?,
      eleves:
          (json['eleves'] as List<dynamic>?)
              ?.map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'particule': instance.particule,
      'civilite': instance.civilite,
      'typeCompte': instance.typeCompte,
      'email': instance.email,
      'photo': instance.photo,
      'eleves': instance.eleves,
    };

_$ChildModelImpl _$$ChildModelImplFromJson(Map<String, dynamic> json) =>
    _$ChildModelImpl(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      particule: _toStringOrNull(json['particule']),
      photo: _toStringOrNull(json['photo']),
      classe: _toStringOrNull(json['classe']),
      classeId: _toIntOrNull(json['classeId']),
      sexe: _toStringOrNull(json['sexe']),
    );

Map<String, dynamic> _$$ChildModelImplToJson(_$ChildModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'particule': instance.particule,
      'photo': instance.photo,
      'classe': instance.classe,
      'classeId': instance.classeId,
      'sexe': instance.sexe,
    };

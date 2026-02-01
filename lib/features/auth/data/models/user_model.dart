import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modèle utilisateur de l'API École Directe
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    required String nom,
    required String prenom,
    String? particule,
    String? civilite,
    @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson) required String typeCompte,
    String? email,
    String? photo,
    @Default([]) List<ChildModel> eleves,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Nom complet de l'utilisateur
  String get fullName {
    final parts = <String>[];
    if (particule != null && particule!.isNotEmpty) {
      parts.add(particule!);
    }
    parts.add(nom);
    parts.add(prenom);
    return parts.join(' ');
  }
}

/// Convertit typeCompte en String (peut être int ou String)
String _typeCompteFromJson(dynamic value) => value?.toString() ?? '';

/// Convertit un champ en String? de manière robuste (gère String, Map, ou autre)
String? _toStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map<String, dynamic>) {
    // Essayer des clés communes
    return value['libelle']?.toString() ??
           value['label']?.toString() ??
           value['name']?.toString() ??
           value['value']?.toString();
  }
  return value.toString();
}

/// Convertit un champ en int? de manière robuste
int? _toIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  if (value is Map<String, dynamic>) {
    return _toIntOrNull(value['id'] ?? value['value']);
  }
  return null;
}

/// Modèle enfant (élève)
@freezed
class ChildModel with _$ChildModel {
  const ChildModel._();

  const factory ChildModel({
    required int id,
    required String nom,
    required String prenom,
    @JsonKey(fromJson: _toStringOrNull) String? particule,
    @JsonKey(fromJson: _toStringOrNull) String? photo,
    @JsonKey(fromJson: _toStringOrNull) String? classe,
    @JsonKey(name: 'classeId', fromJson: _toIntOrNull) int? classeId,
    @JsonKey(fromJson: _toStringOrNull) String? sexe,
  }) = _ChildModel;

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  /// Nom complet de l'enfant
  String get fullName {
    final parts = <String>[];
    parts.add(prenom);
    if (particule != null && particule!.isNotEmpty) {
      parts.add(particule!);
    }
    parts.add(nom);
    return parts.join(' ');
  }
}

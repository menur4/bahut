import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Réponse de l'API login École Directe
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required int code,
    @Default('') String token,
    String? message,
    AuthDataModel? data,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

/// Données de la réponse d'authentification
@freezed
class AuthDataModel with _$AuthDataModel {
  const factory AuthDataModel({
    @Default([]) List<UserModel> accounts,
  }) = _AuthDataModel;

  factory AuthDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Classes d'erreurs métier de l'application
@freezed
class Failure with _$Failure {
  /// Erreur serveur (API École Directe)
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  /// Erreur réseau (pas de connexion)
  const factory Failure.network({
    @Default('Pas de connexion internet') String message,
  }) = NetworkFailure;

  /// Erreur d'authentification
  const factory Failure.auth({
    required String message,
    @Default(false) bool isTokenExpired,
  }) = AuthFailure;

  /// Erreur de cache
  const factory Failure.cache({
    @Default('Erreur de cache') String message,
  }) = CacheFailure;

  /// Erreur de biométrie
  const factory Failure.biometric({
    required String message,
    @Default(false) bool isNotAvailable,
    @Default(false) bool isNotEnrolled,
  }) = BiometricFailure;

  /// Erreur inconnue
  const factory Failure.unknown({
    @Default('Une erreur inattendue est survenue') String message,
    Object? error,
  }) = UnknownFailure;
}

/// Extension pour obtenir un message utilisateur
extension FailureMessage on Failure {
  String get userMessage {
    return when(
      server: (message, statusCode) =>
          'Erreur serveur: $message${statusCode != null ? ' (Code: $statusCode)' : ''}',
      network: (message) => message,
      auth: (message, isTokenExpired) =>
          isTokenExpired ? 'Votre session a expiré. Veuillez vous reconnecter.' : message,
      cache: (message) => message,
      biometric: (message, isNotAvailable, isNotEnrolled) {
        if (isNotAvailable) return 'La biométrie n\'est pas disponible sur cet appareil';
        if (isNotEnrolled) return 'Aucune empreinte ou Face ID configuré';
        return message;
      },
      unknown: (message, error) => message,
    );
  }
}

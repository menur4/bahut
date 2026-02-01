/// Constantes pour l'API École Directe
class ApiConstants {
  ApiConstants._();

  /// URL de base de l'API École Directe
  static const String baseUrl = 'https://api.ecoledirecte.com';

  /// Version de l'API
  static const String apiVersion = 'v3';

  /// Numéro de version complet (pour le paramètre v= dans les requêtes)
  static const String apiVersionNumber = '4.94.0';

  /// Endpoints
  static const String loginEndpoint = '/$apiVersion/login.awp';
  static String gradesEndpoint(int studentId) =>
      '/$apiVersion/eleves/$studentId/notes.awp';
  static String timelineEndpoint(int studentId) =>
      '/$apiVersion/eleves/$studentId/timeline.awp';
  static String vieScolaireEndpoint(int studentId) =>
      '/$apiVersion/eleves/$studentId/vieScolaire.awp';
  static String emploiDuTempsEndpoint(int studentId) =>
      '/$apiVersion/E/$studentId/emploidutemps.awp';
  static String cahierDeTexteEndpoint(int studentId) =>
      '/$apiVersion/Eleves/$studentId/cahierdetexte.awp';
  static String travailAFaireEndpoint(int studentId) =>
      '/$apiVersion/Eleves/$studentId/cahierdetexte.awp';
  static String messagesEndpoint(int studentId) =>
      '/$apiVersion/eleves/$studentId/messages.awp';

  /// User-Agent constant (obligatoire pour l'API)
  /// Doit ressembler à un navigateur mobile standard
  static const String userAgent =
      'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  /// Content-Type
  static const String contentType = 'application/x-www-form-urlencoded';

  /// Timeout en millisecondes
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}

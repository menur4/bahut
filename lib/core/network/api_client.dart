import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Provider pour le client API
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Client HTTP configuré pour l'API École Directe
/// Gère le flow GTK + MFA/QCM
class ApiClient {
  late final Dio _dio;
  final CookieJar _cookieJar = CookieJar();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _gtkValue;
  String? _xToken;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'User-Agent': ApiConstants.userAgent,
          'Accept': 'application/json, text/plain, */*',
          'Origin': 'https://www.ecoledirecte.com',
          'Referer': 'https://www.ecoledirecte.com/',
        },
      ),
    );

    // Ajouter le gestionnaire de cookies
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Interceptor pour ajouter les headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ajouter X-Token si disponible
          if (_xToken != null && _xToken!.isNotEmpty) {
            options.headers['X-Token'] = _xToken;
          }

          // Ajouter X-Gtk si disponible (pour le login)
          if (_gtkValue != null && options.path.contains('login')) {
            options.headers['X-Gtk'] = _gtkValue;
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Récupérer le X-Token des headers de réponse
          final token = response.headers.value('x-token');
          if (token != null && token.isNotEmpty) {
            _xToken = token;
            _saveToken(token);
          }
          handler.next(response);
        },
      ),
    );
  }

  /// Sauvegarde le token
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.secureStorageToken,
      value: token,
    );
  }

  /// Obtient le cookie GTK nécessaire pour l'authentification
  Future<void> fetchGtk() async {
    print('[API] Fetching GTK cookie...');

    // Effacer l'ancien GTK pour forcer une nouvelle récupération
    _gtkValue = null;

    // Supprimer les anciens cookies GTK
    final baseUri = Uri.parse(ApiConstants.baseUrl);
    await _cookieJar.delete(baseUri, true);

    final response = await _dio.get(
      ApiConstants.loginEndpoint,
      queryParameters: {
        'gtk': '1',
        'v': ApiConstants.apiVersionNumber,
      },
      options: Options(
        // Ne pas envoyer l'ancien X-Gtk
        headers: {'X-Gtk': null},
      ),
    );

    // Essayer plusieurs emplacements pour le cookie GTK
    final loginUri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');

    // Chercher dans les cookies pour différentes URLs
    for (final uri in [loginUri, baseUri]) {
      final cookies = await _cookieJar.loadForRequest(uri);
      for (final cookie in cookies) {
        if (cookie.name == 'GTK') {
          _gtkValue = cookie.value;
          print('[API] GTK obtained from ${uri.path}: ${_gtkValue?.substring(0, 30)}...');
          return;
        }
      }
    }

    // Si pas trouvé dans les cookies, vérifier les headers de réponse
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      for (final cookie in setCookie) {
        if (cookie.startsWith('GTK=')) {
          _gtkValue = cookie.split(';').first.substring(4);
          print('[API] GTK from header: ${_gtkValue?.substring(0, 30)}...');
          return;
        }
      }
    }

    throw const ServerException(message: 'Impossible d\'obtenir le cookie GTK');
  }

  /// Effectue le login et retourne la réponse
  /// Peut retourner code 200 (succès) ou 250 (MFA requis)
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String? cn,
    String? cv,
  }) async {
    // Toujours obtenir un nouveau GTK avant le login
    await fetchGtk();

    // Construire le payload
    final Map<String, dynamic> data = {
      'identifiant': username,
      'motdepasse': password,
      'isReLogin': false,
      'uuid': '',
    };

    // Ajouter cn/cv si disponibles (pour éviter le QCM)
    // Envoyés au niveau racine, pas dans un tableau fa
    if (cn != null && cv != null) {
      data['cn'] = cn;
      data['cv'] = cv;
    }

    print('[API] Login attempt for: $username');

    final response = await post(
      ApiConstants.loginEndpoint,
      data: data,
      queryParameters: {'v': ApiConstants.apiVersionNumber},
    );

    return response;
  }

  /// Obtient le QCM de vérification
  Future<Map<String, dynamic>> getQcm() async {
    print('[API] Getting QCM...');

    final response = await post(
      '/v3/connexion/doubleauth.awp',
      data: {},
      queryParameters: {
        'verbe': 'get',
        'v': ApiConstants.apiVersionNumber,
      },
    );

    return response;
  }

  /// Répond au QCM et retourne cn/cv si succès
  Future<Map<String, dynamic>> answerQcm(String answer) async {
    print('[API] Answering QCM...');

    final response = await post(
      '/v3/connexion/doubleauth.awp',
      data: {'choix': answer},
      queryParameters: {
        'verbe': 'post',
        'v': ApiConstants.apiVersionNumber,
      },
    );

    return response;
  }

  /// Effectue une requête POST avec le format École Directe
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('[API] POST $endpoint');
      final jsonData = jsonEncode(data ?? {});

      final response = await _dio.post(
        endpoint,
        data: 'data=$jsonData',
        queryParameters: queryParameters,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      print('[API] Response status: ${response.statusCode}');
      print('[API] X-Code: ${response.headers.value('x-code')}');
      print('[API] Response data type: ${response.data?.runtimeType}');
      print('[API] Response data: ${response.data}');

      // Handle both Map and String responses
      Map<String, dynamic> responseData;
      if (response.data is Map<String, dynamic>) {
        responseData = response.data as Map<String, dynamic>;
      } else if (response.data is String && (response.data as String).isNotEmpty) {
        try {
          responseData = jsonDecode(response.data as String) as Map<String, dynamic>;
        } catch (e) {
          print('[API] Failed to parse String response: $e');
          throw const ServerException(message: 'Réponse invalide du serveur');
        }
      } else {
        // Si le body est vide mais x-code est 200, c'est ok
        final xCode = response.headers.value('x-code');
        if (xCode == '200' && (response.data == null || response.data.toString().isEmpty)) {
          return {'code': 200, 'token': '', 'message': ''};
        }
        throw const ServerException(message: 'Réponse invalide du serveur');
      }

      // Vérifier le code de réponse pour les erreurs d'authentification
      final code = responseData['code'] as int?;
      if (code != null) {
        // Codes d'erreur École Directe pour session/token expirés
        if (code == 520 || code == 525) {
          print('[API] Token expiré (code: $code)');
          throw AuthException(
            message: responseData['message'] as String? ?? 'Session expirée',
            isTokenExpired: true,
          );
        }
      }

      return responseData;
    } on DioException catch (e) {
      print('[API] DioException: ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.message ?? 'Erreur serveur',
        statusCode: e.response?.statusCode,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      print('[API] Exception: $e');
      rethrow;
    }
  }

  /// Effectue une requête GET authentifiée
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final params = {
        'v': ApiConstants.apiVersionNumber,
        ...?queryParameters,
      };

      final response = await _dio.get(
        endpoint,
        queryParameters: params,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      throw const ServerException(message: 'Réponse invalide du serveur');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      }
      throw ServerException(
        message: e.message ?? 'Erreur serveur',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Définit le token X-Token manuellement
  void setToken(String token) {
    _xToken = token;
  }

  /// Charge le token sauvegardé depuis le stockage sécurisé
  Future<void> loadSavedToken() async {
    final token = await _secureStorage.read(key: AppConstants.secureStorageToken);
    if (token != null && token.isNotEmpty) {
      _xToken = token;
      print('[API] Token restauré depuis le stockage');
    }
  }

  /// Réinitialise la session
  Future<void> clearSession() async {
    _gtkValue = null;
    _xToken = null;
    _cookieJar.deleteAll();
    await _secureStorage.delete(key: AppConstants.secureStorageToken);
  }
}

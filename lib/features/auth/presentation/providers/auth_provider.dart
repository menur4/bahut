import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/demo/demo_data.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/user_model.dart';
import '../../data/models/auth_response_model.dart';

/// État de l'authentification
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isInitializing;
  final UserModel? user;
  final List<ChildModel> children;
  final int? selectedChildId;
  final bool biometricEnabled;
  final String? errorMessage;

  /// Indique si le MFA/QCM est requis
  final bool mfaRequired;

  /// Données du QCM à afficher
  final QcmData? qcmData;

  /// Indique si l'app est en mode démonstration (Play Store)
  final bool isDemoMode;

  /// Indique si on charge les données après authentification
  final bool isPostAuthLoading;

  /// Indique si la biométrie a été vérifiée pour cette session
  final bool biometricVerified;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.isInitializing = true,
    this.user,
    this.children = const [],
    this.selectedChildId,
    this.biometricEnabled = false,
    this.errorMessage,
    this.mfaRequired = false,
    this.qcmData,
    this.isDemoMode = false,
    this.isPostAuthLoading = false,
    this.biometricVerified = false,
  });

  /// Indique si l'app est en cours de chargement (init ou opération)
  /// Note: isPostAuthLoading n'est pas inclus car le dashboard gère son propre loader
  bool get isProcessing => isInitializing || isLoading;

  bool get hasMultipleChildren => children.length > 1;

  ChildModel? get selectedChild {
    if (selectedChildId == null) return children.firstOrNull;
    return children.where((c) => c.id == selectedChildId).firstOrNull;
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isInitializing,
    UserModel? user,
    List<ChildModel>? children,
    int? selectedChildId,
    bool? biometricEnabled,
    String? errorMessage,
    bool? mfaRequired,
    QcmData? qcmData,
    bool? isDemoMode,
    bool? isPostAuthLoading,
    bool? biometricVerified,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isInitializing: isInitializing ?? this.isInitializing,
      user: user ?? this.user,
      children: children ?? this.children,
      selectedChildId: selectedChildId ?? this.selectedChildId,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      errorMessage: errorMessage,
      mfaRequired: mfaRequired ?? this.mfaRequired,
      qcmData: qcmData,
      isDemoMode: isDemoMode ?? this.isDemoMode,
      isPostAuthLoading: isPostAuthLoading ?? this.isPostAuthLoading,
      biometricVerified: biometricVerified ?? this.biometricVerified,
    );
  }
}

/// Données du QCM pour la vérification MFA
class QcmData {
  final String question;
  final List<String> propositions;

  const QcmData({
    required this.question,
    required this.propositions,
  });
}

/// Provider pour l'état d'authentification
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

/// Notifier pour gérer l'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Credentials temporaires pendant le flow MFA
  String? _pendingUsername;
  String? _pendingPassword;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _loadSavedState();
  }

  /// Charger l'état sauvegardé
  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final biometricEnabled = prefs.getBool(AppConstants.prefBiometricEnabled) ?? false;

      final token = await _secureStorage.read(key: AppConstants.secureStorageToken);
      final selectedChildId = await _secureStorage.read(key: AppConstants.secureStorageSelectedChild);
      final childrenJson = prefs.getString(AppConstants.prefChildrenCache);

      List<ChildModel> children = [];
      if (childrenJson != null) {
        final List<dynamic> decoded = jsonDecode(childrenJson);
        children = decoded.map((e) => ChildModel.fromJson(e)).toList();
        print('[AUTH] Chargement depuis cache: ${children.length} enfants');
        for (final child in children) {
          print('[AUTH] Cache - ${child.prenom}: photo=${child.photo != null ? "OUI (${child.photo!.length} chars)" : "NON"}');
        }
      }

      // Restaurer le token dans le client API
      if (token != null && token.isNotEmpty) {
        final apiClient = _ref.read(apiClientProvider);
        await apiClient.loadSavedToken();
        print('[AUTH] Token restauré dans ApiClient');
      }

      final isAuthenticated = token != null && token.isNotEmpty;
      state = state.copyWith(
        isAuthenticated: isAuthenticated,
        biometricEnabled: biometricEnabled,
        selectedChildId: selectedChildId != null ? int.tryParse(selectedChildId) : null,
        children: children,
        isInitializing: false,
        // Si déjà authentifié au démarrage, activer le chargement post-auth
        // pour que le dashboard affiche un loading pendant le chargement des données
        isPostAuthLoading: isAuthenticated,
      );
    } catch (e) {
      // En cas d'erreur, marquer comme initialisé pour permettre la navigation
      print('[AUTH] Erreur chargement état: $e');
      state = state.copyWith(isInitializing: false);
    }
  }

  /// Se connecter avec identifiants
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null, mfaRequired: false, qcmData: null);

    // Vérifier si c'est un login démo (Play Store)
    if (DemoCredentials.isDemo(username, password)) {
      print('[AUTH] Mode démonstration activé');
      await _handleDemoLogin();
      return;
    }

    try {
      final apiClient = _ref.read(apiClientProvider);

      // Récupérer les tokens device sauvegardés
      final cn = await _secureStorage.read(key: AppConstants.secureStorageDeviceCn);
      final cv = await _secureStorage.read(key: AppConstants.secureStorageDeviceCv);

      print('[AUTH] Tentative de connexion pour: $username');
      print('[AUTH] Device tokens présents: cn=${cn != null}, cv=${cv != null}');

      final response = await apiClient.login(
        username: username,
        password: password,
        cn: cn,
        cv: cv,
      );

      print('[AUTH] Réponse code: ${response['code']}');

      final code = response['code'] as int;

      if (code == 250) {
        // MFA requis - stocker les credentials et récupérer le QCM
        print('[AUTH] MFA requis (code 250)');
        _pendingUsername = username;
        _pendingPassword = password;
        await _fetchQcm();
        return;
      }

      if (code != 200) {
        final message = response['message'] as String? ?? 'Erreur de connexion';
        print('[AUTH] Erreur: $message');
        throw AuthException(message: message);
      }

      // Authentification réussie
      await _handleSuccessfulLogin(response, username, password);
    } on AuthException catch (e) {
      print('[AUTH] AuthException: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } on NetworkException catch (e) {
      print('[AUTH] NetworkException: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Pas de connexion internet',
      );
    } catch (e, stackTrace) {
      print('[AUTH] Exception inattendue: $e');
      print('[AUTH] StackTrace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Une erreur est survenue: ${e.toString()}',
      );
    }
  }

  /// Gère la connexion en mode démonstration
  Future<void> _handleDemoLogin() async {
    final user = DemoData.demoUser;
    final child = DemoData.demoChild;
    final children = [child];

    // Sauvegarder le token démo
    await _secureStorage.write(
      key: AppConstants.secureStorageToken,
      value: 'demo_token',
    );
    await _secureStorage.write(
      key: AppConstants.secureStorageCredentials,
      value: jsonEncode({
        'username': DemoCredentials.username,
        'password': DemoCredentials.password,
      }),
    );

    // Sauvegarder les enfants dans le cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefChildrenCache,
      jsonEncode(children.map((e) => e.toJson()).toList()),
    );

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: user,
      children: children,
      selectedChildId: child.id,
      isDemoMode: true,
      mfaRequired: false,
      qcmData: null,
      isPostAuthLoading: true, // Activer le chargement post-auth
    );
  }

  /// Décoder une chaîne base64
  String _decodeBase64(String encoded) {
    try {
      final bytes = base64Decode(encoded);
      return utf8.decode(bytes);
    } catch (e) {
      print('[AUTH] Erreur décodage base64: $e');
      return encoded; // Retourner la chaîne originale en cas d'erreur
    }
  }

  /// Récupère le QCM pour la vérification MFA
  Future<void> _fetchQcm() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.getQcm();

      print('[AUTH] QCM response: $response');

      final code = response['code'] as int?;
      if (code != 200) {
        throw AuthException(message: response['message'] as String? ?? 'Erreur QCM');
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const AuthException(message: 'Données QCM invalides');
      }

      // Les données du QCM sont encodées en base64
      final questionEncoded = data['question'] as String? ?? '';
      final propositionsEncoded = (data['propositions'] as List?)?.cast<String>() ?? [];

      final question = _decodeBase64(questionEncoded);
      final propositions = propositionsEncoded.map(_decodeBase64).toList();

      print('[AUTH] QCM question décodée: $question');
      print('[AUTH] QCM propositions décodées: $propositions');

      state = state.copyWith(
        isLoading: false,
        mfaRequired: true,
        qcmData: QcmData(
          question: question,
          propositions: propositions,
        ),
      );
    } catch (e) {
      print('[AUTH] Erreur QCM: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la récupération du QCM',
      );
    }
  }

  /// Répond au QCM de vérification
  Future<void> answerQcm(String answer) async {
    if (_pendingUsername == null || _pendingPassword == null) {
      state = state.copyWith(
        errorMessage: 'Session expirée, veuillez vous reconnecter',
        mfaRequired: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final apiClient = _ref.read(apiClientProvider);

      // Encoder la réponse en base64
      final encodedAnswer = base64Encode(utf8.encode(answer));
      print('[AUTH] Réponse QCM encodée: $encodedAnswer');

      final response = await apiClient.answerQcm(encodedAnswer);

      print('[AUTH] QCM answer response: $response');

      final code = response['code'] as int?;
      if (code != 200) {
        throw AuthException(message: response['message'] as String? ?? 'Mauvaise réponse');
      }

      // Récupérer cn/cv
      final data = response['data'] as Map<String, dynamic>?;
      final cn = data?['cn'] as String?;
      final cv = data?['cv'] as String?;

      if (cn != null && cv != null) {
        print('[AUTH] Device tokens reçus, sauvegarde...');
        await _secureStorage.write(key: AppConstants.secureStorageDeviceCn, value: cn);
        await _secureStorage.write(key: AppConstants.secureStorageDeviceCv, value: cv);
      }

      // Refaire le login avec les nouveaux tokens
      print('[AUTH] Retentative de login avec device tokens...');
      final loginResponse = await apiClient.login(
        username: _pendingUsername!,
        password: _pendingPassword!,
        cn: cn,
        cv: cv,
      );

      final loginCode = loginResponse['code'] as int;
      if (loginCode != 200) {
        throw AuthException(message: loginResponse['message'] as String? ?? 'Erreur de connexion');
      }

      await _handleSuccessfulLogin(loginResponse, _pendingUsername!, _pendingPassword!);
      _pendingUsername = null;
      _pendingPassword = null;
    } on AuthException catch (e) {
      print('[AUTH] QCM AuthException: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      print('[AUTH] QCM Exception: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la vérification',
      );
    }
  }

  /// Annule le flow MFA
  void cancelMfa() {
    _pendingUsername = null;
    _pendingPassword = null;
    state = state.copyWith(
      mfaRequired: false,
      qcmData: null,
      isLoading: false,
    );
  }

  /// Traite une authentification réussie
  Future<void> _handleSuccessfulLogin(
    Map<String, dynamic> response,
    String username,
    String password,
  ) async {
    print('[AUTH] Token présent: ${response['token']?.toString().isNotEmpty ?? false}');

    // Extraire les comptes depuis la réponse brute
    final data = response['data'] as Map<String, dynamic>?;
    final accountsList = data?['accounts'] as List? ?? [];
    print('[AUTH] Nombre de comptes: ${accountsList.length}');

    if (accountsList.isEmpty) {
      throw const AuthException(message: 'Aucun compte trouvé');
    }

    final accountJson = accountsList.first as Map<String, dynamic>;
    print('[AUTH] User type: ${accountJson['typeCompte']}, id: ${accountJson['id']}');

    // Extraire les enfants - chercher dans eleves et profile.eleves
    List<ChildModel> children = [];

    // Essayer eleves directement
    final elevesJson = accountJson['eleves'] as List?;
    if (elevesJson != null && elevesJson.isNotEmpty) {
      print('[AUTH] Enfants trouvés dans eleves: ${elevesJson.length}');
      children = elevesJson
          .map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Sinon essayer profile.eleves
    if (children.isEmpty) {
      final profile = accountJson['profile'] as Map<String, dynamic>?;
      final profileEleves = profile?['eleves'] as List?;
      if (profileEleves != null && profileEleves.isNotEmpty) {
        print('[AUTH] Enfants trouvés dans profile.eleves: ${profileEleves.length}');
        for (final eleveJson in profileEleves) {
          final eleveMap = eleveJson as Map<String, dynamic>;
          print('[AUTH] Données enfant brutes - clés: ${eleveMap.keys.toList()}');
          final photoValue = eleveMap['photo']?.toString();
          final photoPreview = photoValue != null
              ? '${photoValue.substring(0, photoValue.length > 50 ? 50 : photoValue.length)}...'
              : 'null';
          print('[AUTH] Photo présente: ${photoValue != null}, longueur: ${photoValue?.length ?? 0}, valeur: $photoPreview');
          try {
            final child = ChildModel.fromJson(eleveMap);
            children.add(child);
            print('[AUTH] Enfant parsé: ${child.prenom} ${child.nom}, id: ${child.id}, photo: ${child.photo != null}');
          } catch (e) {
            print('[AUTH] Erreur parsing enfant: $e');
            // Créer un ChildModel minimal manuellement
            final map = eleveJson as Map<String, dynamic>;
            children.add(ChildModel(
              id: map['id'] as int,
              nom: map['nom']?.toString() ?? '',
              prenom: map['prenom']?.toString() ?? '',
              photo: map['photo']?.toString(),
              classe: map['classe']?['libelle']?.toString(),
            ));
            print('[AUTH] Enfant créé manuellement: ${map['prenom']} ${map['nom']}, photo: ${map['photo'] != null}');
          }
        }
      }
    }

    print('[AUTH] Nombre d\'enfants final: ${children.length}');
    for (final child in children) {
      print('[AUTH] Enfant: ${child.prenom} ${child.nom}, id: ${child.id}, photo: ${child.photo != null ? "OUI (${child.photo!.length} chars)" : "NON"}');
    }

    // Parser le user model
    UserModel user;
    try {
      user = UserModel.fromJson(accountJson);
      print('[AUTH] UserModel parsé avec succès');
    } catch (e) {
      print('[AUTH] Erreur parsing UserModel: $e');
      // Créer un UserModel minimal
      user = UserModel(
        id: accountJson['id'] as int,
        nom: accountJson['nom']?.toString() ?? '',
        prenom: accountJson['prenom']?.toString() ?? '',
        typeCompte: accountJson['typeCompte']?.toString() ?? '',
      );
      print('[AUTH] UserModel créé manuellement');
    }
    final token = response['token'] as String? ?? '';
    print('[AUTH] Token: ${token.isNotEmpty ? 'présent' : 'absent'}');

    // Sauvegarder les credentials
    await _secureStorage.write(
      key: AppConstants.secureStorageCredentials,
      value: jsonEncode({'username': username, 'password': password}),
    );
    await _secureStorage.write(
      key: AppConstants.secureStorageToken,
      value: token,
    );
    await _secureStorage.write(
      key: AppConstants.secureStorageUserId,
      value: user.id.toString(),
    );

    // Sauvegarder les enfants dans le cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefChildrenCache,
      jsonEncode(children.map((e) => e.toJson()).toList()),
    );

    // Ne pas auto-sélectionner si plusieurs enfants (pour montrer le sélecteur)
    // Sauf si un enfant était déjà sélectionné
    final existingSelection = await _secureStorage.read(key: AppConstants.secureStorageSelectedChild);
    int? selectedChildId;
    if (existingSelection != null) {
      selectedChildId = int.tryParse(existingSelection);
      // Vérifier que l'enfant sélectionné existe toujours
      if (!children.any((c) => c.id == selectedChildId)) {
        selectedChildId = null;
      }
    }
    // Si un seul enfant, le sélectionner automatiquement
    if (selectedChildId == null && children.length == 1) {
      selectedChildId = children.first.id;
      print('[AUTH] Auto-sélection enfant unique: $selectedChildId');
    }

    print('[AUTH] selectedChildId final: $selectedChildId');

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: user,
      children: children,
      selectedChildId: selectedChildId,
      mfaRequired: false,
      qcmData: null,
      isPostAuthLoading: true, // Activer le chargement post-auth
    );
  }

  /// Sélectionner un enfant
  Future<void> selectChild(int childId) async {
    await _secureStorage.write(
      key: AppConstants.secureStorageSelectedChild,
      value: childId.toString(),
    );
    state = state.copyWith(selectedChildId: childId);
  }

  /// Activer/désactiver la biométrie
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefBiometricEnabled, enabled);
    state = state.copyWith(biometricEnabled: enabled);
  }

  /// Marquer la biométrie comme vérifiée pour cette session
  void completeBiometricVerification() {
    state = state.copyWith(biometricVerified: true);
  }

  /// Marquer le chargement post-authentification comme terminé
  void completePostAuthLoading() {
    if (state.isPostAuthLoading) {
      state = state.copyWith(isPostAuthLoading: false);
    }
  }

  /// Se déconnecter
  Future<void> logout() async {
    // Ne pas appeler l'API en mode démo
    if (!state.isDemoMode) {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.clearSession();
    }

    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefChildrenCache);
    await prefs.remove(AppConstants.prefGradesCache);

    state = const AuthState(isInitializing: false);
  }

  /// Rafraîchir le token avec les credentials sauvegardés
  Future<bool> refreshToken() async {
    try {
      final credentialsJson = await _secureStorage.read(
        key: AppConstants.secureStorageCredentials,
      );

      if (credentialsJson == null) return false;

      final credentials = jsonDecode(credentialsJson) as Map<String, dynamic>;
      await login(credentials['username'], credentials['password']);

      return state.isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}

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

/// Compte sauvegardé pour le changement rapide de compte
class SavedAccount {
  final String username;
  final String password;
  final String displayName;
  final String typeCompte;
  final List<ChildModel> children;
  final int? selectedChildId;
  final DateTime lastUsed;

  const SavedAccount({
    required this.username,
    required this.password,
    required this.displayName,
    required this.typeCompte,
    required this.children,
    this.selectedChildId,
    required this.lastUsed,
  });

  String get initiale => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'displayName': displayName,
    'typeCompte': typeCompte,
    'children': children.map((c) => c.toJson()).toList(),
    'selectedChildId': selectedChildId,
    'lastUsed': lastUsed.toIso8601String(),
  };

  factory SavedAccount.fromJson(Map<String, dynamic> json) => SavedAccount(
    username: json['username'] as String,
    password: json['password'] as String,
    displayName: json['displayName'] as String? ?? '',
    typeCompte: json['typeCompte'] as String? ?? '',
    children: (json['children'] as List?)
        ?.map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    selectedChildId: json['selectedChildId'] as int?,
    lastUsed: DateTime.tryParse(json['lastUsed'] as String? ?? '') ?? DateTime.now(),
  );
}

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

  /// Comptes sauvegardés pour le changement rapide
  final List<SavedAccount> savedAccounts;

  /// Username du compte actif
  final String? currentUsername;

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
    this.savedAccounts = const [],
    this.currentUsername,
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
    List<SavedAccount>? savedAccounts,
    String? currentUsername,
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
      savedAccounts: savedAccounts ?? this.savedAccounts,
      currentUsername: currentUsername ?? this.currentUsername,
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

      // Charger les comptes sauvegardés
      final savedAccountsJson = await _secureStorage.read(key: AppConstants.secureStorageSavedAccounts);
      List<SavedAccount> savedAccounts = [];
      if (savedAccountsJson != null) {
        final list = jsonDecode(savedAccountsJson) as List;
        savedAccounts = list.map((e) => SavedAccount.fromJson(e as Map<String, dynamic>)).toList();
      }

      final currentUsername = await _secureStorage.read(key: AppConstants.secureStorageCurrentUsername);

      final isAuthenticated = token != null && token.isNotEmpty;
      state = state.copyWith(
        isAuthenticated: isAuthenticated,
        biometricEnabled: biometricEnabled,
        selectedChildId: selectedChildId != null ? int.tryParse(selectedChildId) : null,
        children: children,
        isInitializing: false,
        isPostAuthLoading: isAuthenticated,
        savedAccounts: savedAccounts,
        currentUsername: currentUsername,
      );
    } catch (e) {
      // En cas d'erreur, marquer comme initialisé pour permettre la navigation
      print('[AUTH] Erreur chargement état: $e');
      state = state.copyWith(isInitializing: false);
    }
  }

  /// Se connecter avec identifiants
  /// [silent] = true lors d'un switch de compte : n'active pas isLoading pour éviter les redirects du routeur
  Future<void> login(String username, String password, {bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true, errorMessage: null, mfaRequired: false, qcmData: null);
    }

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
        isLoading: silent ? state.isLoading : false,
        errorMessage: e.message,
      );
    } on NetworkException catch (e) {
      print('[AUTH] NetworkException: $e');
      state = state.copyWith(
        isLoading: silent ? state.isLoading : false,
        errorMessage: 'Pas de connexion internet',
      );
    } catch (e, stackTrace) {
      print('[AUTH] Exception inattendue: $e');
      print('[AUTH] StackTrace: $stackTrace');
      state = state.copyWith(
        isLoading: silent ? state.isLoading : false,
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

    // Si toujours aucun enfant : c'est un compte élève direct (l'utilisateur est lui-même l'élève)
    if (children.isEmpty) {
      print('[AUTH] Aucun enfant trouvé - compte élève direct, création depuis données utilisateur');
      final profile = accountJson['profile'] as Map<String, dynamic>?;

      // La classe peut être dans profile ou directement dans accountJson
      final classeRaw = profile?['classe'] ?? accountJson['classe'];
      String? classe;
      if (classeRaw is String && classeRaw.isNotEmpty) {
        classe = classeRaw;
      } else if (classeRaw is Map<String, dynamic>) {
        classe = classeRaw['libelle']?.toString();
      }

      // La photo peut être dans profile ou directement
      final photoRaw = profile?['photo'] ?? accountJson['photo'];
      final photo = photoRaw?.toString().isNotEmpty == true ? photoRaw.toString() : null;

      children = [
        ChildModel(
          id: accountJson['id'] as int,
          nom: accountJson['nom']?.toString() ?? '',
          prenom: accountJson['prenom']?.toString() ?? '',
          photo: photo,
          classe: classe,
        ),
      ];
      print('[AUTH] Élève créé: ${children.first.prenom} ${children.first.nom}, classe: $classe, photo: ${photo != null}');
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

    // Enregistrer le username courant
    await _secureStorage.write(
      key: AppConstants.secureStorageCurrentUsername,
      value: username,
    );

    // Sauvegarder ce compte dans la liste des comptes sauvegardés
    await _saveAccountToList(
      username: username,
      password: password,
      user: user,
      children: children,
      selectedChildId: selectedChildId,
    );

    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: user,
      children: children,
      selectedChildId: selectedChildId,
      mfaRequired: false,
      qcmData: null,
      isPostAuthLoading: true,
      currentUsername: username,
      savedAccounts: await _loadSavedAccountsList(),
    );
  }

  /// Charge la liste des comptes sauvegardés depuis le stockage
  Future<List<SavedAccount>> _loadSavedAccountsList() async {
    final json = await _secureStorage.read(key: AppConstants.secureStorageSavedAccounts);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => SavedAccount.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Enregistre ou met à jour un compte dans la liste des comptes sauvegardés
  Future<void> _saveAccountToList({
    required String username,
    required String password,
    required UserModel user,
    required List<ChildModel> children,
    int? selectedChildId,
  }) async {
    final accounts = await _loadSavedAccountsList();
    final displayName = user.fullName.isNotEmpty ? user.fullName : username;
    final newAccount = SavedAccount(
      username: username,
      password: password,
      displayName: displayName,
      typeCompte: user.typeCompte,
      children: children,
      selectedChildId: selectedChildId,
      lastUsed: DateTime.now(),
    );
    // Remplacer si existe déjà, sinon ajouter
    final idx = accounts.indexWhere((a) => a.username == username);
    if (idx >= 0) {
      accounts[idx] = newAccount;
    } else {
      accounts.add(newAccount);
    }
    // Trier par dernière utilisation
    accounts.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    await _secureStorage.write(
      key: AppConstants.secureStorageSavedAccounts,
      value: jsonEncode(accounts.map((a) => a.toJson()).toList()),
    );
  }

  /// Changer de compte (reconnexion avec les credentials sauvegardés)
  Future<void> switchAccount(SavedAccount account) async {
    // Sauvegarder le selectedChildId courant pour le compte actif
    if (state.currentUsername != null) {
      final accounts = await _loadSavedAccountsList();
      final idx = accounts.indexWhere((a) => a.username == state.currentUsername);
      if (idx >= 0 && state.selectedChildId != null) {
        final current = accounts[idx];
        accounts[idx] = SavedAccount(
          username: current.username,
          password: current.password,
          displayName: current.displayName,
          typeCompte: current.typeCompte,
          children: current.children,
          selectedChildId: state.selectedChildId,
          lastUsed: current.lastUsed,
        );
        await _secureStorage.write(
          key: AppConstants.secureStorageSavedAccounts,
          value: jsonEncode(accounts.map((a) => a.toJson()).toList()),
        );
      }
    }
    // Se connecter avec le nouveau compte sans déclencher isLoading (évite les redirects du routeur)
    await login(account.username, account.password, silent: true);
  }

  /// Supprimer un compte sauvegardé
  Future<void> removeSavedAccount(String username) async {
    final accounts = await _loadSavedAccountsList();
    accounts.removeWhere((a) => a.username == username);
    await _secureStorage.write(
      key: AppConstants.secureStorageSavedAccounts,
      value: jsonEncode(accounts.map((a) => a.toJson()).toList()),
    );
    state = state.copyWith(savedAccounts: accounts);
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

    // Préserver les comptes sauvegardés avant de tout effacer
    final savedAccountsJson = await _secureStorage.read(key: AppConstants.secureStorageSavedAccounts);

    await _secureStorage.deleteAll();

    // Restaurer les comptes sauvegardés
    if (savedAccountsJson != null) {
      await _secureStorage.write(
        key: AppConstants.secureStorageSavedAccounts,
        value: savedAccountsJson,
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefChildrenCache);
    await prefs.remove(AppConstants.prefGradesCache);

    final savedAccounts = await _loadSavedAccountsList();
    state = AuthState(isInitializing: false, savedAccounts: savedAccounts);
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

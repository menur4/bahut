// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get prenom => throw _privateConstructorUsedError;
  String? get particule => throw _privateConstructorUsedError;
  String? get civilite => throw _privateConstructorUsedError;
  @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
  String get typeCompte => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  List<ChildModel> get eleves => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    int id,
    String nom,
    String prenom,
    String? particule,
    String? civilite,
    @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
    String typeCompte,
    String? email,
    String? photo,
    List<ChildModel> eleves,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? particule = freezed,
    Object? civilite = freezed,
    Object? typeCompte = null,
    Object? email = freezed,
    Object? photo = freezed,
    Object? eleves = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            prenom: null == prenom
                ? _value.prenom
                : prenom // ignore: cast_nullable_to_non_nullable
                      as String,
            particule: freezed == particule
                ? _value.particule
                : particule // ignore: cast_nullable_to_non_nullable
                      as String?,
            civilite: freezed == civilite
                ? _value.civilite
                : civilite // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeCompte: null == typeCompte
                ? _value.typeCompte
                : typeCompte // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as String?,
            eleves: null == eleves
                ? _value.eleves
                : eleves // ignore: cast_nullable_to_non_nullable
                      as List<ChildModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nom,
    String prenom,
    String? particule,
    String? civilite,
    @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
    String typeCompte,
    String? email,
    String? photo,
    List<ChildModel> eleves,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? particule = freezed,
    Object? civilite = freezed,
    Object? typeCompte = null,
    Object? email = freezed,
    Object? photo = freezed,
    Object? eleves = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        particule: freezed == particule
            ? _value.particule
            : particule // ignore: cast_nullable_to_non_nullable
                  as String?,
        civilite: freezed == civilite
            ? _value.civilite
            : civilite // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeCompte: null == typeCompte
            ? _value.typeCompte
            : typeCompte // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as String?,
        eleves: null == eleves
            ? _value._eleves
            : eleves // ignore: cast_nullable_to_non_nullable
                  as List<ChildModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.nom,
    required this.prenom,
    this.particule,
    this.civilite,
    @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
    required this.typeCompte,
    this.email,
    this.photo,
    final List<ChildModel> eleves = const [],
  }) : _eleves = eleves,
       super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String? particule;
  @override
  final String? civilite;
  @override
  @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
  final String typeCompte;
  @override
  final String? email;
  @override
  final String? photo;
  final List<ChildModel> _eleves;
  @override
  @JsonKey()
  List<ChildModel> get eleves {
    if (_eleves is EqualUnmodifiableListView) return _eleves;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eleves);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nom: $nom, prenom: $prenom, particule: $particule, civilite: $civilite, typeCompte: $typeCompte, email: $email, photo: $photo, eleves: $eleves)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.particule, particule) ||
                other.particule == particule) &&
            (identical(other.civilite, civilite) ||
                other.civilite == civilite) &&
            (identical(other.typeCompte, typeCompte) ||
                other.typeCompte == typeCompte) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            const DeepCollectionEquality().equals(other._eleves, _eleves));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nom,
    prenom,
    particule,
    civilite,
    typeCompte,
    email,
    photo,
    const DeepCollectionEquality().hash(_eleves),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final int id,
    required final String nom,
    required final String prenom,
    final String? particule,
    final String? civilite,
    @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
    required final String typeCompte,
    final String? email,
    final String? photo,
    final List<ChildModel> eleves,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nom;
  @override
  String get prenom;
  @override
  String? get particule;
  @override
  String? get civilite;
  @override
  @JsonKey(name: 'typeCompte', fromJson: _typeCompteFromJson)
  String get typeCompte;
  @override
  String? get email;
  @override
  String? get photo;
  @override
  List<ChildModel> get eleves;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChildModel _$ChildModelFromJson(Map<String, dynamic> json) {
  return _ChildModel.fromJson(json);
}

/// @nodoc
mixin _$ChildModel {
  int get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get prenom => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toStringOrNull)
  String? get particule => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toStringOrNull)
  String? get photo => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toStringOrNull)
  String? get classe => throw _privateConstructorUsedError;
  @JsonKey(name: 'classeId', fromJson: _toIntOrNull)
  int? get classeId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toStringOrNull)
  String? get sexe => throw _privateConstructorUsedError;

  /// Serializes this ChildModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildModelCopyWith<ChildModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildModelCopyWith<$Res> {
  factory $ChildModelCopyWith(
    ChildModel value,
    $Res Function(ChildModel) then,
  ) = _$ChildModelCopyWithImpl<$Res, ChildModel>;
  @useResult
  $Res call({
    int id,
    String nom,
    String prenom,
    @JsonKey(fromJson: _toStringOrNull) String? particule,
    @JsonKey(fromJson: _toStringOrNull) String? photo,
    @JsonKey(fromJson: _toStringOrNull) String? classe,
    @JsonKey(name: 'classeId', fromJson: _toIntOrNull) int? classeId,
    @JsonKey(fromJson: _toStringOrNull) String? sexe,
  });
}

/// @nodoc
class _$ChildModelCopyWithImpl<$Res, $Val extends ChildModel>
    implements $ChildModelCopyWith<$Res> {
  _$ChildModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? particule = freezed,
    Object? photo = freezed,
    Object? classe = freezed,
    Object? classeId = freezed,
    Object? sexe = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            prenom: null == prenom
                ? _value.prenom
                : prenom // ignore: cast_nullable_to_non_nullable
                      as String,
            particule: freezed == particule
                ? _value.particule
                : particule // ignore: cast_nullable_to_non_nullable
                      as String?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as String?,
            classe: freezed == classe
                ? _value.classe
                : classe // ignore: cast_nullable_to_non_nullable
                      as String?,
            classeId: freezed == classeId
                ? _value.classeId
                : classeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            sexe: freezed == sexe
                ? _value.sexe
                : sexe // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChildModelImplCopyWith<$Res>
    implements $ChildModelCopyWith<$Res> {
  factory _$$ChildModelImplCopyWith(
    _$ChildModelImpl value,
    $Res Function(_$ChildModelImpl) then,
  ) = __$$ChildModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nom,
    String prenom,
    @JsonKey(fromJson: _toStringOrNull) String? particule,
    @JsonKey(fromJson: _toStringOrNull) String? photo,
    @JsonKey(fromJson: _toStringOrNull) String? classe,
    @JsonKey(name: 'classeId', fromJson: _toIntOrNull) int? classeId,
    @JsonKey(fromJson: _toStringOrNull) String? sexe,
  });
}

/// @nodoc
class __$$ChildModelImplCopyWithImpl<$Res>
    extends _$ChildModelCopyWithImpl<$Res, _$ChildModelImpl>
    implements _$$ChildModelImplCopyWith<$Res> {
  __$$ChildModelImplCopyWithImpl(
    _$ChildModelImpl _value,
    $Res Function(_$ChildModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? prenom = null,
    Object? particule = freezed,
    Object? photo = freezed,
    Object? classe = freezed,
    Object? classeId = freezed,
    Object? sexe = freezed,
  }) {
    return _then(
      _$ChildModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        particule: freezed == particule
            ? _value.particule
            : particule // ignore: cast_nullable_to_non_nullable
                  as String?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as String?,
        classe: freezed == classe
            ? _value.classe
            : classe // ignore: cast_nullable_to_non_nullable
                  as String?,
        classeId: freezed == classeId
            ? _value.classeId
            : classeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        sexe: freezed == sexe
            ? _value.sexe
            : sexe // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildModelImpl extends _ChildModel {
  const _$ChildModelImpl({
    required this.id,
    required this.nom,
    required this.prenom,
    @JsonKey(fromJson: _toStringOrNull) this.particule,
    @JsonKey(fromJson: _toStringOrNull) this.photo,
    @JsonKey(fromJson: _toStringOrNull) this.classe,
    @JsonKey(name: 'classeId', fromJson: _toIntOrNull) this.classeId,
    @JsonKey(fromJson: _toStringOrNull) this.sexe,
  }) : super._();

  factory _$ChildModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildModelImplFromJson(json);

  @override
  final int id;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  final String? particule;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  final String? photo;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  final String? classe;
  @override
  @JsonKey(name: 'classeId', fromJson: _toIntOrNull)
  final int? classeId;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  final String? sexe;

  @override
  String toString() {
    return 'ChildModel(id: $id, nom: $nom, prenom: $prenom, particule: $particule, photo: $photo, classe: $classe, classeId: $classeId, sexe: $sexe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.particule, particule) ||
                other.particule == particule) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.classe, classe) || other.classe == classe) &&
            (identical(other.classeId, classeId) ||
                other.classeId == classeId) &&
            (identical(other.sexe, sexe) || other.sexe == sexe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nom,
    prenom,
    particule,
    photo,
    classe,
    classeId,
    sexe,
  );

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      __$$ChildModelImplCopyWithImpl<_$ChildModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildModelImplToJson(this);
  }
}

abstract class _ChildModel extends ChildModel {
  const factory _ChildModel({
    required final int id,
    required final String nom,
    required final String prenom,
    @JsonKey(fromJson: _toStringOrNull) final String? particule,
    @JsonKey(fromJson: _toStringOrNull) final String? photo,
    @JsonKey(fromJson: _toStringOrNull) final String? classe,
    @JsonKey(name: 'classeId', fromJson: _toIntOrNull) final int? classeId,
    @JsonKey(fromJson: _toStringOrNull) final String? sexe,
  }) = _$ChildModelImpl;
  const _ChildModel._() : super._();

  factory _ChildModel.fromJson(Map<String, dynamic> json) =
      _$ChildModelImpl.fromJson;

  @override
  int get id;
  @override
  String get nom;
  @override
  String get prenom;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  String? get particule;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  String? get photo;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  String? get classe;
  @override
  @JsonKey(name: 'classeId', fromJson: _toIntOrNull)
  int? get classeId;
  @override
  @JsonKey(fromJson: _toStringOrNull)
  String? get sexe;

  /// Create a copy of ChildModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

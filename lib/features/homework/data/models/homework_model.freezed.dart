// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'homework_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HomeworkModel _$HomeworkModelFromJson(Map<String, dynamic> json) {
  return _HomeworkModel.fromJson(json);
}

/// @nodoc
mixin _$HomeworkModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'idDevoir')
  int? get idDevoir => throw _privateConstructorUsedError;
  String? get matiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'codeMatiere')
  String? get codeMatiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'aFaire')
  bool? get aFaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'idEleve')
  int? get idEleve => throw _privateConstructorUsedError;
  @JsonKey(name: 'documentsAFaire')
  bool get documentsAFaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'donneLe')
  String? get donneLe => throw _privateConstructorUsedError;
  @JsonKey(name: 'pourLe')
  String? get pourLe => throw _privateConstructorUsedError;
  @JsonKey(name: 'effectue')
  bool get effectue => throw _privateConstructorUsedError;
  String? get interrogation => throw _privateConstructorUsedError;
  @JsonKey(name: 'rendpieces')
  bool get rendpieces => throw _privateConstructorUsedError;
  String get contenu => throw _privateConstructorUsedError;
  @JsonKey(name: 'contenuDeSeance')
  String? get contenuDeSeance => throw _privateConstructorUsedError;

  /// Serializes this HomeworkModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeworkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeworkModelCopyWith<HomeworkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeworkModelCopyWith<$Res> {
  factory $HomeworkModelCopyWith(
    HomeworkModel value,
    $Res Function(HomeworkModel) then,
  ) = _$HomeworkModelCopyWithImpl<$Res, HomeworkModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'idDevoir') int? idDevoir,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    @JsonKey(name: 'aFaire') bool? aFaire,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'documentsAFaire') bool documentsAFaire,
    @JsonKey(name: 'donneLe') String? donneLe,
    @JsonKey(name: 'pourLe') String? pourLe,
    @JsonKey(name: 'effectue') bool effectue,
    String? interrogation,
    @JsonKey(name: 'rendpieces') bool rendpieces,
    String contenu,
    @JsonKey(name: 'contenuDeSeance') String? contenuDeSeance,
  });
}

/// @nodoc
class _$HomeworkModelCopyWithImpl<$Res, $Val extends HomeworkModel>
    implements $HomeworkModelCopyWith<$Res> {
  _$HomeworkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeworkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? idDevoir = freezed,
    Object? matiere = freezed,
    Object? codeMatiere = freezed,
    Object? aFaire = freezed,
    Object? idEleve = freezed,
    Object? documentsAFaire = null,
    Object? donneLe = freezed,
    Object? pourLe = freezed,
    Object? effectue = null,
    Object? interrogation = freezed,
    Object? rendpieces = null,
    Object? contenu = null,
    Object? contenuDeSeance = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            idDevoir: freezed == idDevoir
                ? _value.idDevoir
                : idDevoir // ignore: cast_nullable_to_non_nullable
                      as int?,
            matiere: freezed == matiere
                ? _value.matiere
                : matiere // ignore: cast_nullable_to_non_nullable
                      as String?,
            codeMatiere: freezed == codeMatiere
                ? _value.codeMatiere
                : codeMatiere // ignore: cast_nullable_to_non_nullable
                      as String?,
            aFaire: freezed == aFaire
                ? _value.aFaire
                : aFaire // ignore: cast_nullable_to_non_nullable
                      as bool?,
            idEleve: freezed == idEleve
                ? _value.idEleve
                : idEleve // ignore: cast_nullable_to_non_nullable
                      as int?,
            documentsAFaire: null == documentsAFaire
                ? _value.documentsAFaire
                : documentsAFaire // ignore: cast_nullable_to_non_nullable
                      as bool,
            donneLe: freezed == donneLe
                ? _value.donneLe
                : donneLe // ignore: cast_nullable_to_non_nullable
                      as String?,
            pourLe: freezed == pourLe
                ? _value.pourLe
                : pourLe // ignore: cast_nullable_to_non_nullable
                      as String?,
            effectue: null == effectue
                ? _value.effectue
                : effectue // ignore: cast_nullable_to_non_nullable
                      as bool,
            interrogation: freezed == interrogation
                ? _value.interrogation
                : interrogation // ignore: cast_nullable_to_non_nullable
                      as String?,
            rendpieces: null == rendpieces
                ? _value.rendpieces
                : rendpieces // ignore: cast_nullable_to_non_nullable
                      as bool,
            contenu: null == contenu
                ? _value.contenu
                : contenu // ignore: cast_nullable_to_non_nullable
                      as String,
            contenuDeSeance: freezed == contenuDeSeance
                ? _value.contenuDeSeance
                : contenuDeSeance // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeworkModelImplCopyWith<$Res>
    implements $HomeworkModelCopyWith<$Res> {
  factory _$$HomeworkModelImplCopyWith(
    _$HomeworkModelImpl value,
    $Res Function(_$HomeworkModelImpl) then,
  ) = __$$HomeworkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'idDevoir') int? idDevoir,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    @JsonKey(name: 'aFaire') bool? aFaire,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'documentsAFaire') bool documentsAFaire,
    @JsonKey(name: 'donneLe') String? donneLe,
    @JsonKey(name: 'pourLe') String? pourLe,
    @JsonKey(name: 'effectue') bool effectue,
    String? interrogation,
    @JsonKey(name: 'rendpieces') bool rendpieces,
    String contenu,
    @JsonKey(name: 'contenuDeSeance') String? contenuDeSeance,
  });
}

/// @nodoc
class __$$HomeworkModelImplCopyWithImpl<$Res>
    extends _$HomeworkModelCopyWithImpl<$Res, _$HomeworkModelImpl>
    implements _$$HomeworkModelImplCopyWith<$Res> {
  __$$HomeworkModelImplCopyWithImpl(
    _$HomeworkModelImpl _value,
    $Res Function(_$HomeworkModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeworkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? idDevoir = freezed,
    Object? matiere = freezed,
    Object? codeMatiere = freezed,
    Object? aFaire = freezed,
    Object? idEleve = freezed,
    Object? documentsAFaire = null,
    Object? donneLe = freezed,
    Object? pourLe = freezed,
    Object? effectue = null,
    Object? interrogation = freezed,
    Object? rendpieces = null,
    Object? contenu = null,
    Object? contenuDeSeance = freezed,
  }) {
    return _then(
      _$HomeworkModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        idDevoir: freezed == idDevoir
            ? _value.idDevoir
            : idDevoir // ignore: cast_nullable_to_non_nullable
                  as int?,
        matiere: freezed == matiere
            ? _value.matiere
            : matiere // ignore: cast_nullable_to_non_nullable
                  as String?,
        codeMatiere: freezed == codeMatiere
            ? _value.codeMatiere
            : codeMatiere // ignore: cast_nullable_to_non_nullable
                  as String?,
        aFaire: freezed == aFaire
            ? _value.aFaire
            : aFaire // ignore: cast_nullable_to_non_nullable
                  as bool?,
        idEleve: freezed == idEleve
            ? _value.idEleve
            : idEleve // ignore: cast_nullable_to_non_nullable
                  as int?,
        documentsAFaire: null == documentsAFaire
            ? _value.documentsAFaire
            : documentsAFaire // ignore: cast_nullable_to_non_nullable
                  as bool,
        donneLe: freezed == donneLe
            ? _value.donneLe
            : donneLe // ignore: cast_nullable_to_non_nullable
                  as String?,
        pourLe: freezed == pourLe
            ? _value.pourLe
            : pourLe // ignore: cast_nullable_to_non_nullable
                  as String?,
        effectue: null == effectue
            ? _value.effectue
            : effectue // ignore: cast_nullable_to_non_nullable
                  as bool,
        interrogation: freezed == interrogation
            ? _value.interrogation
            : interrogation // ignore: cast_nullable_to_non_nullable
                  as String?,
        rendpieces: null == rendpieces
            ? _value.rendpieces
            : rendpieces // ignore: cast_nullable_to_non_nullable
                  as bool,
        contenu: null == contenu
            ? _value.contenu
            : contenu // ignore: cast_nullable_to_non_nullable
                  as String,
        contenuDeSeance: freezed == contenuDeSeance
            ? _value.contenuDeSeance
            : contenuDeSeance // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeworkModelImpl extends _HomeworkModel {
  const _$HomeworkModelImpl({
    this.id,
    @JsonKey(name: 'idDevoir') this.idDevoir,
    this.matiere,
    @JsonKey(name: 'codeMatiere') this.codeMatiere,
    @JsonKey(name: 'aFaire') this.aFaire,
    @JsonKey(name: 'idEleve') this.idEleve,
    @JsonKey(name: 'documentsAFaire') this.documentsAFaire = false,
    @JsonKey(name: 'donneLe') this.donneLe,
    @JsonKey(name: 'pourLe') this.pourLe,
    @JsonKey(name: 'effectue') this.effectue = false,
    this.interrogation,
    @JsonKey(name: 'rendpieces') this.rendpieces = false,
    this.contenu = '',
    @JsonKey(name: 'contenuDeSeance') this.contenuDeSeance,
  }) : super._();

  factory _$HomeworkModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeworkModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'idDevoir')
  final int? idDevoir;
  @override
  final String? matiere;
  @override
  @JsonKey(name: 'codeMatiere')
  final String? codeMatiere;
  @override
  @JsonKey(name: 'aFaire')
  final bool? aFaire;
  @override
  @JsonKey(name: 'idEleve')
  final int? idEleve;
  @override
  @JsonKey(name: 'documentsAFaire')
  final bool documentsAFaire;
  @override
  @JsonKey(name: 'donneLe')
  final String? donneLe;
  @override
  @JsonKey(name: 'pourLe')
  final String? pourLe;
  @override
  @JsonKey(name: 'effectue')
  final bool effectue;
  @override
  final String? interrogation;
  @override
  @JsonKey(name: 'rendpieces')
  final bool rendpieces;
  @override
  @JsonKey()
  final String contenu;
  @override
  @JsonKey(name: 'contenuDeSeance')
  final String? contenuDeSeance;

  @override
  String toString() {
    return 'HomeworkModel(id: $id, idDevoir: $idDevoir, matiere: $matiere, codeMatiere: $codeMatiere, aFaire: $aFaire, idEleve: $idEleve, documentsAFaire: $documentsAFaire, donneLe: $donneLe, pourLe: $pourLe, effectue: $effectue, interrogation: $interrogation, rendpieces: $rendpieces, contenu: $contenu, contenuDeSeance: $contenuDeSeance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeworkModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idDevoir, idDevoir) ||
                other.idDevoir == idDevoir) &&
            (identical(other.matiere, matiere) || other.matiere == matiere) &&
            (identical(other.codeMatiere, codeMatiere) ||
                other.codeMatiere == codeMatiere) &&
            (identical(other.aFaire, aFaire) || other.aFaire == aFaire) &&
            (identical(other.idEleve, idEleve) || other.idEleve == idEleve) &&
            (identical(other.documentsAFaire, documentsAFaire) ||
                other.documentsAFaire == documentsAFaire) &&
            (identical(other.donneLe, donneLe) || other.donneLe == donneLe) &&
            (identical(other.pourLe, pourLe) || other.pourLe == pourLe) &&
            (identical(other.effectue, effectue) ||
                other.effectue == effectue) &&
            (identical(other.interrogation, interrogation) ||
                other.interrogation == interrogation) &&
            (identical(other.rendpieces, rendpieces) ||
                other.rendpieces == rendpieces) &&
            (identical(other.contenu, contenu) || other.contenu == contenu) &&
            (identical(other.contenuDeSeance, contenuDeSeance) ||
                other.contenuDeSeance == contenuDeSeance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idDevoir,
    matiere,
    codeMatiere,
    aFaire,
    idEleve,
    documentsAFaire,
    donneLe,
    pourLe,
    effectue,
    interrogation,
    rendpieces,
    contenu,
    contenuDeSeance,
  );

  /// Create a copy of HomeworkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeworkModelImplCopyWith<_$HomeworkModelImpl> get copyWith =>
      __$$HomeworkModelImplCopyWithImpl<_$HomeworkModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeworkModelImplToJson(this);
  }
}

abstract class _HomeworkModel extends HomeworkModel {
  const factory _HomeworkModel({
    final int? id,
    @JsonKey(name: 'idDevoir') final int? idDevoir,
    final String? matiere,
    @JsonKey(name: 'codeMatiere') final String? codeMatiere,
    @JsonKey(name: 'aFaire') final bool? aFaire,
    @JsonKey(name: 'idEleve') final int? idEleve,
    @JsonKey(name: 'documentsAFaire') final bool documentsAFaire,
    @JsonKey(name: 'donneLe') final String? donneLe,
    @JsonKey(name: 'pourLe') final String? pourLe,
    @JsonKey(name: 'effectue') final bool effectue,
    final String? interrogation,
    @JsonKey(name: 'rendpieces') final bool rendpieces,
    final String contenu,
    @JsonKey(name: 'contenuDeSeance') final String? contenuDeSeance,
  }) = _$HomeworkModelImpl;
  const _HomeworkModel._() : super._();

  factory _HomeworkModel.fromJson(Map<String, dynamic> json) =
      _$HomeworkModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'idDevoir')
  int? get idDevoir;
  @override
  String? get matiere;
  @override
  @JsonKey(name: 'codeMatiere')
  String? get codeMatiere;
  @override
  @JsonKey(name: 'aFaire')
  bool? get aFaire;
  @override
  @JsonKey(name: 'idEleve')
  int? get idEleve;
  @override
  @JsonKey(name: 'documentsAFaire')
  bool get documentsAFaire;
  @override
  @JsonKey(name: 'donneLe')
  String? get donneLe;
  @override
  @JsonKey(name: 'pourLe')
  String? get pourLe;
  @override
  @JsonKey(name: 'effectue')
  bool get effectue;
  @override
  String? get interrogation;
  @override
  @JsonKey(name: 'rendpieces')
  bool get rendpieces;
  @override
  String get contenu;
  @override
  @JsonKey(name: 'contenuDeSeance')
  String? get contenuDeSeance;

  /// Create a copy of HomeworkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeworkModelImplCopyWith<_$HomeworkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CahierDeTexteJour _$CahierDeTexteJourFromJson(Map<String, dynamic> json) {
  return _CahierDeTexteJour.fromJson(json);
}

/// @nodoc
mixin _$CahierDeTexteJour {
  String get date => throw _privateConstructorUsedError;
  List<HomeworkModel> get devoirs => throw _privateConstructorUsedError;

  /// Serializes this CahierDeTexteJour to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CahierDeTexteJour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CahierDeTexteJourCopyWith<CahierDeTexteJour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CahierDeTexteJourCopyWith<$Res> {
  factory $CahierDeTexteJourCopyWith(
    CahierDeTexteJour value,
    $Res Function(CahierDeTexteJour) then,
  ) = _$CahierDeTexteJourCopyWithImpl<$Res, CahierDeTexteJour>;
  @useResult
  $Res call({String date, List<HomeworkModel> devoirs});
}

/// @nodoc
class _$CahierDeTexteJourCopyWithImpl<$Res, $Val extends CahierDeTexteJour>
    implements $CahierDeTexteJourCopyWith<$Res> {
  _$CahierDeTexteJourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CahierDeTexteJour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? devoirs = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            devoirs: null == devoirs
                ? _value.devoirs
                : devoirs // ignore: cast_nullable_to_non_nullable
                      as List<HomeworkModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CahierDeTexteJourImplCopyWith<$Res>
    implements $CahierDeTexteJourCopyWith<$Res> {
  factory _$$CahierDeTexteJourImplCopyWith(
    _$CahierDeTexteJourImpl value,
    $Res Function(_$CahierDeTexteJourImpl) then,
  ) = __$$CahierDeTexteJourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, List<HomeworkModel> devoirs});
}

/// @nodoc
class __$$CahierDeTexteJourImplCopyWithImpl<$Res>
    extends _$CahierDeTexteJourCopyWithImpl<$Res, _$CahierDeTexteJourImpl>
    implements _$$CahierDeTexteJourImplCopyWith<$Res> {
  __$$CahierDeTexteJourImplCopyWithImpl(
    _$CahierDeTexteJourImpl _value,
    $Res Function(_$CahierDeTexteJourImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CahierDeTexteJour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? devoirs = null}) {
    return _then(
      _$CahierDeTexteJourImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        devoirs: null == devoirs
            ? _value._devoirs
            : devoirs // ignore: cast_nullable_to_non_nullable
                  as List<HomeworkModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CahierDeTexteJourImpl implements _CahierDeTexteJour {
  const _$CahierDeTexteJourImpl({
    required this.date,
    final List<HomeworkModel> devoirs = const [],
  }) : _devoirs = devoirs;

  factory _$CahierDeTexteJourImpl.fromJson(Map<String, dynamic> json) =>
      _$$CahierDeTexteJourImplFromJson(json);

  @override
  final String date;
  final List<HomeworkModel> _devoirs;
  @override
  @JsonKey()
  List<HomeworkModel> get devoirs {
    if (_devoirs is EqualUnmodifiableListView) return _devoirs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devoirs);
  }

  @override
  String toString() {
    return 'CahierDeTexteJour(date: $date, devoirs: $devoirs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CahierDeTexteJourImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._devoirs, _devoirs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    const DeepCollectionEquality().hash(_devoirs),
  );

  /// Create a copy of CahierDeTexteJour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CahierDeTexteJourImplCopyWith<_$CahierDeTexteJourImpl> get copyWith =>
      __$$CahierDeTexteJourImplCopyWithImpl<_$CahierDeTexteJourImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CahierDeTexteJourImplToJson(this);
  }
}

abstract class _CahierDeTexteJour implements CahierDeTexteJour {
  const factory _CahierDeTexteJour({
    required final String date,
    final List<HomeworkModel> devoirs,
  }) = _$CahierDeTexteJourImpl;

  factory _CahierDeTexteJour.fromJson(Map<String, dynamic> json) =
      _$CahierDeTexteJourImpl.fromJson;

  @override
  String get date;
  @override
  List<HomeworkModel> get devoirs;

  /// Create a copy of CahierDeTexteJour
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CahierDeTexteJourImplCopyWith<_$CahierDeTexteJourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HomeworkData {
  List<HomeworkModel> get homeworks => throw _privateConstructorUsedError;
  Map<String, List<HomeworkModel>> get homeworksByDate =>
      throw _privateConstructorUsedError;

  /// Create a copy of HomeworkData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeworkDataCopyWith<HomeworkData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeworkDataCopyWith<$Res> {
  factory $HomeworkDataCopyWith(
    HomeworkData value,
    $Res Function(HomeworkData) then,
  ) = _$HomeworkDataCopyWithImpl<$Res, HomeworkData>;
  @useResult
  $Res call({
    List<HomeworkModel> homeworks,
    Map<String, List<HomeworkModel>> homeworksByDate,
  });
}

/// @nodoc
class _$HomeworkDataCopyWithImpl<$Res, $Val extends HomeworkData>
    implements $HomeworkDataCopyWith<$Res> {
  _$HomeworkDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeworkData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? homeworks = null, Object? homeworksByDate = null}) {
    return _then(
      _value.copyWith(
            homeworks: null == homeworks
                ? _value.homeworks
                : homeworks // ignore: cast_nullable_to_non_nullable
                      as List<HomeworkModel>,
            homeworksByDate: null == homeworksByDate
                ? _value.homeworksByDate
                : homeworksByDate // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<HomeworkModel>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeworkDataImplCopyWith<$Res>
    implements $HomeworkDataCopyWith<$Res> {
  factory _$$HomeworkDataImplCopyWith(
    _$HomeworkDataImpl value,
    $Res Function(_$HomeworkDataImpl) then,
  ) = __$$HomeworkDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<HomeworkModel> homeworks,
    Map<String, List<HomeworkModel>> homeworksByDate,
  });
}

/// @nodoc
class __$$HomeworkDataImplCopyWithImpl<$Res>
    extends _$HomeworkDataCopyWithImpl<$Res, _$HomeworkDataImpl>
    implements _$$HomeworkDataImplCopyWith<$Res> {
  __$$HomeworkDataImplCopyWithImpl(
    _$HomeworkDataImpl _value,
    $Res Function(_$HomeworkDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeworkData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? homeworks = null, Object? homeworksByDate = null}) {
    return _then(
      _$HomeworkDataImpl(
        homeworks: null == homeworks
            ? _value._homeworks
            : homeworks // ignore: cast_nullable_to_non_nullable
                  as List<HomeworkModel>,
        homeworksByDate: null == homeworksByDate
            ? _value._homeworksByDate
            : homeworksByDate // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<HomeworkModel>>,
      ),
    );
  }
}

/// @nodoc

class _$HomeworkDataImpl extends _HomeworkData {
  const _$HomeworkDataImpl({
    final List<HomeworkModel> homeworks = const [],
    final Map<String, List<HomeworkModel>> homeworksByDate = const {},
  }) : _homeworks = homeworks,
       _homeworksByDate = homeworksByDate,
       super._();

  final List<HomeworkModel> _homeworks;
  @override
  @JsonKey()
  List<HomeworkModel> get homeworks {
    if (_homeworks is EqualUnmodifiableListView) return _homeworks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_homeworks);
  }

  final Map<String, List<HomeworkModel>> _homeworksByDate;
  @override
  @JsonKey()
  Map<String, List<HomeworkModel>> get homeworksByDate {
    if (_homeworksByDate is EqualUnmodifiableMapView) return _homeworksByDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_homeworksByDate);
  }

  @override
  String toString() {
    return 'HomeworkData(homeworks: $homeworks, homeworksByDate: $homeworksByDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeworkDataImpl &&
            const DeepCollectionEquality().equals(
              other._homeworks,
              _homeworks,
            ) &&
            const DeepCollectionEquality().equals(
              other._homeworksByDate,
              _homeworksByDate,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_homeworks),
    const DeepCollectionEquality().hash(_homeworksByDate),
  );

  /// Create a copy of HomeworkData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeworkDataImplCopyWith<_$HomeworkDataImpl> get copyWith =>
      __$$HomeworkDataImplCopyWithImpl<_$HomeworkDataImpl>(this, _$identity);
}

abstract class _HomeworkData extends HomeworkData {
  const factory _HomeworkData({
    final List<HomeworkModel> homeworks,
    final Map<String, List<HomeworkModel>> homeworksByDate,
  }) = _$HomeworkDataImpl;
  const _HomeworkData._() : super._();

  @override
  List<HomeworkModel> get homeworks;
  @override
  Map<String, List<HomeworkModel>> get homeworksByDate;

  /// Create a copy of HomeworkData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeworkDataImplCopyWith<_$HomeworkDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GradeModel _$GradeModelFromJson(Map<String, dynamic> json) {
  return _GradeModel.fromJson(json);
}

/// @nodoc
mixin _$GradeModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'devoir')
  String get devoir => throw _privateConstructorUsedError;
  @JsonKey(name: 'codePeriode')
  String get codePeriode => throw _privateConstructorUsedError;
  @JsonKey(name: 'codeMatiere')
  String get codeMatiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'libelleMatiere')
  String get libelleMatiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'codeSousMatiere')
  String? get codeSousMatiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'typeDevoir')
  String? get typeDevoir => throw _privateConstructorUsedError;
  @JsonKey(name: 'enpirenote')
  bool? get enpirenote => throw _privateConstructorUsedError;
  @JsonKey(name: 'coef')
  String get coef => throw _privateConstructorUsedError;
  @JsonKey(name: 'noteSur')
  String get noteSur => throw _privateConstructorUsedError;
  @JsonKey(name: 'valeur')
  String get valeur => throw _privateConstructorUsedError;
  @JsonKey(name: 'nonSignificatif')
  bool get nonSignificatif => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'dateSaisie')
  String? get dateSaisie => throw _privateConstructorUsedError;
  @JsonKey(name: 'moyenneClasse')
  String? get moyenneClasse => throw _privateConstructorUsedError;
  @JsonKey(name: 'minClasse')
  String? get minClasse => throw _privateConstructorUsedError;
  @JsonKey(name: 'maxClasse')
  String? get maxClasse => throw _privateConstructorUsedError;
  String? get commentaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'elements')
  List<dynamic> get elements => throw _privateConstructorUsedError;

  /// Serializes this GradeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GradeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeModelCopyWith<GradeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeModelCopyWith<$Res> {
  factory $GradeModelCopyWith(
    GradeModel value,
    $Res Function(GradeModel) then,
  ) = _$GradeModelCopyWithImpl<$Res, GradeModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'devoir') String devoir,
    @JsonKey(name: 'codePeriode') String codePeriode,
    @JsonKey(name: 'codeMatiere') String codeMatiere,
    @JsonKey(name: 'libelleMatiere') String libelleMatiere,
    @JsonKey(name: 'codeSousMatiere') String? codeSousMatiere,
    @JsonKey(name: 'typeDevoir') String? typeDevoir,
    @JsonKey(name: 'enpirenote') bool? enpirenote,
    @JsonKey(name: 'coef') String coef,
    @JsonKey(name: 'noteSur') String noteSur,
    @JsonKey(name: 'valeur') String valeur,
    @JsonKey(name: 'nonSignificatif') bool nonSignificatif,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'dateSaisie') String? dateSaisie,
    @JsonKey(name: 'moyenneClasse') String? moyenneClasse,
    @JsonKey(name: 'minClasse') String? minClasse,
    @JsonKey(name: 'maxClasse') String? maxClasse,
    String? commentaire,
    @JsonKey(name: 'elements') List<dynamic> elements,
  });
}

/// @nodoc
class _$GradeModelCopyWithImpl<$Res, $Val extends GradeModel>
    implements $GradeModelCopyWith<$Res> {
  _$GradeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GradeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? devoir = null,
    Object? codePeriode = null,
    Object? codeMatiere = null,
    Object? libelleMatiere = null,
    Object? codeSousMatiere = freezed,
    Object? typeDevoir = freezed,
    Object? enpirenote = freezed,
    Object? coef = null,
    Object? noteSur = null,
    Object? valeur = null,
    Object? nonSignificatif = null,
    Object? date = freezed,
    Object? dateSaisie = freezed,
    Object? moyenneClasse = freezed,
    Object? minClasse = freezed,
    Object? maxClasse = freezed,
    Object? commentaire = freezed,
    Object? elements = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            devoir: null == devoir
                ? _value.devoir
                : devoir // ignore: cast_nullable_to_non_nullable
                      as String,
            codePeriode: null == codePeriode
                ? _value.codePeriode
                : codePeriode // ignore: cast_nullable_to_non_nullable
                      as String,
            codeMatiere: null == codeMatiere
                ? _value.codeMatiere
                : codeMatiere // ignore: cast_nullable_to_non_nullable
                      as String,
            libelleMatiere: null == libelleMatiere
                ? _value.libelleMatiere
                : libelleMatiere // ignore: cast_nullable_to_non_nullable
                      as String,
            codeSousMatiere: freezed == codeSousMatiere
                ? _value.codeSousMatiere
                : codeSousMatiere // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeDevoir: freezed == typeDevoir
                ? _value.typeDevoir
                : typeDevoir // ignore: cast_nullable_to_non_nullable
                      as String?,
            enpirenote: freezed == enpirenote
                ? _value.enpirenote
                : enpirenote // ignore: cast_nullable_to_non_nullable
                      as bool?,
            coef: null == coef
                ? _value.coef
                : coef // ignore: cast_nullable_to_non_nullable
                      as String,
            noteSur: null == noteSur
                ? _value.noteSur
                : noteSur // ignore: cast_nullable_to_non_nullable
                      as String,
            valeur: null == valeur
                ? _value.valeur
                : valeur // ignore: cast_nullable_to_non_nullable
                      as String,
            nonSignificatif: null == nonSignificatif
                ? _value.nonSignificatif
                : nonSignificatif // ignore: cast_nullable_to_non_nullable
                      as bool,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateSaisie: freezed == dateSaisie
                ? _value.dateSaisie
                : dateSaisie // ignore: cast_nullable_to_non_nullable
                      as String?,
            moyenneClasse: freezed == moyenneClasse
                ? _value.moyenneClasse
                : moyenneClasse // ignore: cast_nullable_to_non_nullable
                      as String?,
            minClasse: freezed == minClasse
                ? _value.minClasse
                : minClasse // ignore: cast_nullable_to_non_nullable
                      as String?,
            maxClasse: freezed == maxClasse
                ? _value.maxClasse
                : maxClasse // ignore: cast_nullable_to_non_nullable
                      as String?,
            commentaire: freezed == commentaire
                ? _value.commentaire
                : commentaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            elements: null == elements
                ? _value.elements
                : elements // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GradeModelImplCopyWith<$Res>
    implements $GradeModelCopyWith<$Res> {
  factory _$$GradeModelImplCopyWith(
    _$GradeModelImpl value,
    $Res Function(_$GradeModelImpl) then,
  ) = __$$GradeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'devoir') String devoir,
    @JsonKey(name: 'codePeriode') String codePeriode,
    @JsonKey(name: 'codeMatiere') String codeMatiere,
    @JsonKey(name: 'libelleMatiere') String libelleMatiere,
    @JsonKey(name: 'codeSousMatiere') String? codeSousMatiere,
    @JsonKey(name: 'typeDevoir') String? typeDevoir,
    @JsonKey(name: 'enpirenote') bool? enpirenote,
    @JsonKey(name: 'coef') String coef,
    @JsonKey(name: 'noteSur') String noteSur,
    @JsonKey(name: 'valeur') String valeur,
    @JsonKey(name: 'nonSignificatif') bool nonSignificatif,
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'dateSaisie') String? dateSaisie,
    @JsonKey(name: 'moyenneClasse') String? moyenneClasse,
    @JsonKey(name: 'minClasse') String? minClasse,
    @JsonKey(name: 'maxClasse') String? maxClasse,
    String? commentaire,
    @JsonKey(name: 'elements') List<dynamic> elements,
  });
}

/// @nodoc
class __$$GradeModelImplCopyWithImpl<$Res>
    extends _$GradeModelCopyWithImpl<$Res, _$GradeModelImpl>
    implements _$$GradeModelImplCopyWith<$Res> {
  __$$GradeModelImplCopyWithImpl(
    _$GradeModelImpl _value,
    $Res Function(_$GradeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GradeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? devoir = null,
    Object? codePeriode = null,
    Object? codeMatiere = null,
    Object? libelleMatiere = null,
    Object? codeSousMatiere = freezed,
    Object? typeDevoir = freezed,
    Object? enpirenote = freezed,
    Object? coef = null,
    Object? noteSur = null,
    Object? valeur = null,
    Object? nonSignificatif = null,
    Object? date = freezed,
    Object? dateSaisie = freezed,
    Object? moyenneClasse = freezed,
    Object? minClasse = freezed,
    Object? maxClasse = freezed,
    Object? commentaire = freezed,
    Object? elements = null,
  }) {
    return _then(
      _$GradeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        devoir: null == devoir
            ? _value.devoir
            : devoir // ignore: cast_nullable_to_non_nullable
                  as String,
        codePeriode: null == codePeriode
            ? _value.codePeriode
            : codePeriode // ignore: cast_nullable_to_non_nullable
                  as String,
        codeMatiere: null == codeMatiere
            ? _value.codeMatiere
            : codeMatiere // ignore: cast_nullable_to_non_nullable
                  as String,
        libelleMatiere: null == libelleMatiere
            ? _value.libelleMatiere
            : libelleMatiere // ignore: cast_nullable_to_non_nullable
                  as String,
        codeSousMatiere: freezed == codeSousMatiere
            ? _value.codeSousMatiere
            : codeSousMatiere // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeDevoir: freezed == typeDevoir
            ? _value.typeDevoir
            : typeDevoir // ignore: cast_nullable_to_non_nullable
                  as String?,
        enpirenote: freezed == enpirenote
            ? _value.enpirenote
            : enpirenote // ignore: cast_nullable_to_non_nullable
                  as bool?,
        coef: null == coef
            ? _value.coef
            : coef // ignore: cast_nullable_to_non_nullable
                  as String,
        noteSur: null == noteSur
            ? _value.noteSur
            : noteSur // ignore: cast_nullable_to_non_nullable
                  as String,
        valeur: null == valeur
            ? _value.valeur
            : valeur // ignore: cast_nullable_to_non_nullable
                  as String,
        nonSignificatif: null == nonSignificatif
            ? _value.nonSignificatif
            : nonSignificatif // ignore: cast_nullable_to_non_nullable
                  as bool,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateSaisie: freezed == dateSaisie
            ? _value.dateSaisie
            : dateSaisie // ignore: cast_nullable_to_non_nullable
                  as String?,
        moyenneClasse: freezed == moyenneClasse
            ? _value.moyenneClasse
            : moyenneClasse // ignore: cast_nullable_to_non_nullable
                  as String?,
        minClasse: freezed == minClasse
            ? _value.minClasse
            : minClasse // ignore: cast_nullable_to_non_nullable
                  as String?,
        maxClasse: freezed == maxClasse
            ? _value.maxClasse
            : maxClasse // ignore: cast_nullable_to_non_nullable
                  as String?,
        commentaire: freezed == commentaire
            ? _value.commentaire
            : commentaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        elements: null == elements
            ? _value._elements
            : elements // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeModelImpl implements _GradeModel {
  const _$GradeModelImpl({
    required this.id,
    @JsonKey(name: 'devoir') required this.devoir,
    @JsonKey(name: 'codePeriode') required this.codePeriode,
    @JsonKey(name: 'codeMatiere') required this.codeMatiere,
    @JsonKey(name: 'libelleMatiere') required this.libelleMatiere,
    @JsonKey(name: 'codeSousMatiere') this.codeSousMatiere,
    @JsonKey(name: 'typeDevoir') this.typeDevoir,
    @JsonKey(name: 'enpirenote') this.enpirenote,
    @JsonKey(name: 'coef') required this.coef,
    @JsonKey(name: 'noteSur') required this.noteSur,
    @JsonKey(name: 'valeur') required this.valeur,
    @JsonKey(name: 'nonSignificatif') this.nonSignificatif = false,
    @JsonKey(name: 'date') this.date,
    @JsonKey(name: 'dateSaisie') this.dateSaisie,
    @JsonKey(name: 'moyenneClasse') this.moyenneClasse,
    @JsonKey(name: 'minClasse') this.minClasse,
    @JsonKey(name: 'maxClasse') this.maxClasse,
    this.commentaire,
    @JsonKey(name: 'elements') final List<dynamic> elements = const [],
  }) : _elements = elements;

  factory _$GradeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'devoir')
  final String devoir;
  @override
  @JsonKey(name: 'codePeriode')
  final String codePeriode;
  @override
  @JsonKey(name: 'codeMatiere')
  final String codeMatiere;
  @override
  @JsonKey(name: 'libelleMatiere')
  final String libelleMatiere;
  @override
  @JsonKey(name: 'codeSousMatiere')
  final String? codeSousMatiere;
  @override
  @JsonKey(name: 'typeDevoir')
  final String? typeDevoir;
  @override
  @JsonKey(name: 'enpirenote')
  final bool? enpirenote;
  @override
  @JsonKey(name: 'coef')
  final String coef;
  @override
  @JsonKey(name: 'noteSur')
  final String noteSur;
  @override
  @JsonKey(name: 'valeur')
  final String valeur;
  @override
  @JsonKey(name: 'nonSignificatif')
  final bool nonSignificatif;
  @override
  @JsonKey(name: 'date')
  final String? date;
  @override
  @JsonKey(name: 'dateSaisie')
  final String? dateSaisie;
  @override
  @JsonKey(name: 'moyenneClasse')
  final String? moyenneClasse;
  @override
  @JsonKey(name: 'minClasse')
  final String? minClasse;
  @override
  @JsonKey(name: 'maxClasse')
  final String? maxClasse;
  @override
  final String? commentaire;
  final List<dynamic> _elements;
  @override
  @JsonKey(name: 'elements')
  List<dynamic> get elements {
    if (_elements is EqualUnmodifiableListView) return _elements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_elements);
  }

  @override
  String toString() {
    return 'GradeModel(id: $id, devoir: $devoir, codePeriode: $codePeriode, codeMatiere: $codeMatiere, libelleMatiere: $libelleMatiere, codeSousMatiere: $codeSousMatiere, typeDevoir: $typeDevoir, enpirenote: $enpirenote, coef: $coef, noteSur: $noteSur, valeur: $valeur, nonSignificatif: $nonSignificatif, date: $date, dateSaisie: $dateSaisie, moyenneClasse: $moyenneClasse, minClasse: $minClasse, maxClasse: $maxClasse, commentaire: $commentaire, elements: $elements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.devoir, devoir) || other.devoir == devoir) &&
            (identical(other.codePeriode, codePeriode) ||
                other.codePeriode == codePeriode) &&
            (identical(other.codeMatiere, codeMatiere) ||
                other.codeMatiere == codeMatiere) &&
            (identical(other.libelleMatiere, libelleMatiere) ||
                other.libelleMatiere == libelleMatiere) &&
            (identical(other.codeSousMatiere, codeSousMatiere) ||
                other.codeSousMatiere == codeSousMatiere) &&
            (identical(other.typeDevoir, typeDevoir) ||
                other.typeDevoir == typeDevoir) &&
            (identical(other.enpirenote, enpirenote) ||
                other.enpirenote == enpirenote) &&
            (identical(other.coef, coef) || other.coef == coef) &&
            (identical(other.noteSur, noteSur) || other.noteSur == noteSur) &&
            (identical(other.valeur, valeur) || other.valeur == valeur) &&
            (identical(other.nonSignificatif, nonSignificatif) ||
                other.nonSignificatif == nonSignificatif) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dateSaisie, dateSaisie) ||
                other.dateSaisie == dateSaisie) &&
            (identical(other.moyenneClasse, moyenneClasse) ||
                other.moyenneClasse == moyenneClasse) &&
            (identical(other.minClasse, minClasse) ||
                other.minClasse == minClasse) &&
            (identical(other.maxClasse, maxClasse) ||
                other.maxClasse == maxClasse) &&
            (identical(other.commentaire, commentaire) ||
                other.commentaire == commentaire) &&
            const DeepCollectionEquality().equals(other._elements, _elements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    devoir,
    codePeriode,
    codeMatiere,
    libelleMatiere,
    codeSousMatiere,
    typeDevoir,
    enpirenote,
    coef,
    noteSur,
    valeur,
    nonSignificatif,
    date,
    dateSaisie,
    moyenneClasse,
    minClasse,
    maxClasse,
    commentaire,
    const DeepCollectionEquality().hash(_elements),
  ]);

  /// Create a copy of GradeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeModelImplCopyWith<_$GradeModelImpl> get copyWith =>
      __$$GradeModelImplCopyWithImpl<_$GradeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeModelImplToJson(this);
  }
}

abstract class _GradeModel implements GradeModel {
  const factory _GradeModel({
    required final int id,
    @JsonKey(name: 'devoir') required final String devoir,
    @JsonKey(name: 'codePeriode') required final String codePeriode,
    @JsonKey(name: 'codeMatiere') required final String codeMatiere,
    @JsonKey(name: 'libelleMatiere') required final String libelleMatiere,
    @JsonKey(name: 'codeSousMatiere') final String? codeSousMatiere,
    @JsonKey(name: 'typeDevoir') final String? typeDevoir,
    @JsonKey(name: 'enpirenote') final bool? enpirenote,
    @JsonKey(name: 'coef') required final String coef,
    @JsonKey(name: 'noteSur') required final String noteSur,
    @JsonKey(name: 'valeur') required final String valeur,
    @JsonKey(name: 'nonSignificatif') final bool nonSignificatif,
    @JsonKey(name: 'date') final String? date,
    @JsonKey(name: 'dateSaisie') final String? dateSaisie,
    @JsonKey(name: 'moyenneClasse') final String? moyenneClasse,
    @JsonKey(name: 'minClasse') final String? minClasse,
    @JsonKey(name: 'maxClasse') final String? maxClasse,
    final String? commentaire,
    @JsonKey(name: 'elements') final List<dynamic> elements,
  }) = _$GradeModelImpl;

  factory _GradeModel.fromJson(Map<String, dynamic> json) =
      _$GradeModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'devoir')
  String get devoir;
  @override
  @JsonKey(name: 'codePeriode')
  String get codePeriode;
  @override
  @JsonKey(name: 'codeMatiere')
  String get codeMatiere;
  @override
  @JsonKey(name: 'libelleMatiere')
  String get libelleMatiere;
  @override
  @JsonKey(name: 'codeSousMatiere')
  String? get codeSousMatiere;
  @override
  @JsonKey(name: 'typeDevoir')
  String? get typeDevoir;
  @override
  @JsonKey(name: 'enpirenote')
  bool? get enpirenote;
  @override
  @JsonKey(name: 'coef')
  String get coef;
  @override
  @JsonKey(name: 'noteSur')
  String get noteSur;
  @override
  @JsonKey(name: 'valeur')
  String get valeur;
  @override
  @JsonKey(name: 'nonSignificatif')
  bool get nonSignificatif;
  @override
  @JsonKey(name: 'date')
  String? get date;
  @override
  @JsonKey(name: 'dateSaisie')
  String? get dateSaisie;
  @override
  @JsonKey(name: 'moyenneClasse')
  String? get moyenneClasse;
  @override
  @JsonKey(name: 'minClasse')
  String? get minClasse;
  @override
  @JsonKey(name: 'maxClasse')
  String? get maxClasse;
  @override
  String? get commentaire;
  @override
  @JsonKey(name: 'elements')
  List<dynamic> get elements;

  /// Create a copy of GradeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeModelImplCopyWith<_$GradeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PeriodModel _$PeriodModelFromJson(Map<String, dynamic> json) {
  return _PeriodModel.fromJson(json);
}

/// @nodoc
mixin _$PeriodModel {
  @JsonKey(name: 'codePeriode')
  String get codePeriode => throw _privateConstructorUsedError;
  @JsonKey(name: 'periode')
  String get periode => throw _privateConstructorUsedError;
  @JsonKey(name: 'annuel')
  bool get annuel => throw _privateConstructorUsedError;
  @JsonKey(name: 'dateDebut')
  String? get dateDebut => throw _privateConstructorUsedError;
  @JsonKey(name: 'dateFin')
  String? get dateFin => throw _privateConstructorUsedError;
  @JsonKey(name: 'cloture')
  bool get cloture => throw _privateConstructorUsedError;

  /// Serializes this PeriodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PeriodModelCopyWith<PeriodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodModelCopyWith<$Res> {
  factory $PeriodModelCopyWith(
    PeriodModel value,
    $Res Function(PeriodModel) then,
  ) = _$PeriodModelCopyWithImpl<$Res, PeriodModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'codePeriode') String codePeriode,
    @JsonKey(name: 'periode') String periode,
    @JsonKey(name: 'annuel') bool annuel,
    @JsonKey(name: 'dateDebut') String? dateDebut,
    @JsonKey(name: 'dateFin') String? dateFin,
    @JsonKey(name: 'cloture') bool cloture,
  });
}

/// @nodoc
class _$PeriodModelCopyWithImpl<$Res, $Val extends PeriodModel>
    implements $PeriodModelCopyWith<$Res> {
  _$PeriodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codePeriode = null,
    Object? periode = null,
    Object? annuel = null,
    Object? dateDebut = freezed,
    Object? dateFin = freezed,
    Object? cloture = null,
  }) {
    return _then(
      _value.copyWith(
            codePeriode: null == codePeriode
                ? _value.codePeriode
                : codePeriode // ignore: cast_nullable_to_non_nullable
                      as String,
            periode: null == periode
                ? _value.periode
                : periode // ignore: cast_nullable_to_non_nullable
                      as String,
            annuel: null == annuel
                ? _value.annuel
                : annuel // ignore: cast_nullable_to_non_nullable
                      as bool,
            dateDebut: freezed == dateDebut
                ? _value.dateDebut
                : dateDebut // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateFin: freezed == dateFin
                ? _value.dateFin
                : dateFin // ignore: cast_nullable_to_non_nullable
                      as String?,
            cloture: null == cloture
                ? _value.cloture
                : cloture // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PeriodModelImplCopyWith<$Res>
    implements $PeriodModelCopyWith<$Res> {
  factory _$$PeriodModelImplCopyWith(
    _$PeriodModelImpl value,
    $Res Function(_$PeriodModelImpl) then,
  ) = __$$PeriodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'codePeriode') String codePeriode,
    @JsonKey(name: 'periode') String periode,
    @JsonKey(name: 'annuel') bool annuel,
    @JsonKey(name: 'dateDebut') String? dateDebut,
    @JsonKey(name: 'dateFin') String? dateFin,
    @JsonKey(name: 'cloture') bool cloture,
  });
}

/// @nodoc
class __$$PeriodModelImplCopyWithImpl<$Res>
    extends _$PeriodModelCopyWithImpl<$Res, _$PeriodModelImpl>
    implements _$$PeriodModelImplCopyWith<$Res> {
  __$$PeriodModelImplCopyWithImpl(
    _$PeriodModelImpl _value,
    $Res Function(_$PeriodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codePeriode = null,
    Object? periode = null,
    Object? annuel = null,
    Object? dateDebut = freezed,
    Object? dateFin = freezed,
    Object? cloture = null,
  }) {
    return _then(
      _$PeriodModelImpl(
        codePeriode: null == codePeriode
            ? _value.codePeriode
            : codePeriode // ignore: cast_nullable_to_non_nullable
                  as String,
        periode: null == periode
            ? _value.periode
            : periode // ignore: cast_nullable_to_non_nullable
                  as String,
        annuel: null == annuel
            ? _value.annuel
            : annuel // ignore: cast_nullable_to_non_nullable
                  as bool,
        dateDebut: freezed == dateDebut
            ? _value.dateDebut
            : dateDebut // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateFin: freezed == dateFin
            ? _value.dateFin
            : dateFin // ignore: cast_nullable_to_non_nullable
                  as String?,
        cloture: null == cloture
            ? _value.cloture
            : cloture // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PeriodModelImpl implements _PeriodModel {
  const _$PeriodModelImpl({
    @JsonKey(name: 'codePeriode') required this.codePeriode,
    @JsonKey(name: 'periode') required this.periode,
    @JsonKey(name: 'annuel') this.annuel = false,
    @JsonKey(name: 'dateDebut') this.dateDebut,
    @JsonKey(name: 'dateFin') this.dateFin,
    @JsonKey(name: 'cloture') this.cloture = false,
  });

  factory _$PeriodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PeriodModelImplFromJson(json);

  @override
  @JsonKey(name: 'codePeriode')
  final String codePeriode;
  @override
  @JsonKey(name: 'periode')
  final String periode;
  @override
  @JsonKey(name: 'annuel')
  final bool annuel;
  @override
  @JsonKey(name: 'dateDebut')
  final String? dateDebut;
  @override
  @JsonKey(name: 'dateFin')
  final String? dateFin;
  @override
  @JsonKey(name: 'cloture')
  final bool cloture;

  @override
  String toString() {
    return 'PeriodModel(codePeriode: $codePeriode, periode: $periode, annuel: $annuel, dateDebut: $dateDebut, dateFin: $dateFin, cloture: $cloture)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodModelImpl &&
            (identical(other.codePeriode, codePeriode) ||
                other.codePeriode == codePeriode) &&
            (identical(other.periode, periode) || other.periode == periode) &&
            (identical(other.annuel, annuel) || other.annuel == annuel) &&
            (identical(other.dateDebut, dateDebut) ||
                other.dateDebut == dateDebut) &&
            (identical(other.dateFin, dateFin) || other.dateFin == dateFin) &&
            (identical(other.cloture, cloture) || other.cloture == cloture));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    codePeriode,
    periode,
    annuel,
    dateDebut,
    dateFin,
    cloture,
  );

  /// Create a copy of PeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodModelImplCopyWith<_$PeriodModelImpl> get copyWith =>
      __$$PeriodModelImplCopyWithImpl<_$PeriodModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PeriodModelImplToJson(this);
  }
}

abstract class _PeriodModel implements PeriodModel {
  const factory _PeriodModel({
    @JsonKey(name: 'codePeriode') required final String codePeriode,
    @JsonKey(name: 'periode') required final String periode,
    @JsonKey(name: 'annuel') final bool annuel,
    @JsonKey(name: 'dateDebut') final String? dateDebut,
    @JsonKey(name: 'dateFin') final String? dateFin,
    @JsonKey(name: 'cloture') final bool cloture,
  }) = _$PeriodModelImpl;

  factory _PeriodModel.fromJson(Map<String, dynamic> json) =
      _$PeriodModelImpl.fromJson;

  @override
  @JsonKey(name: 'codePeriode')
  String get codePeriode;
  @override
  @JsonKey(name: 'periode')
  String get periode;
  @override
  @JsonKey(name: 'annuel')
  bool get annuel;
  @override
  @JsonKey(name: 'dateDebut')
  String? get dateDebut;
  @override
  @JsonKey(name: 'dateFin')
  String? get dateFin;
  @override
  @JsonKey(name: 'cloture')
  bool get cloture;

  /// Create a copy of PeriodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PeriodModelImplCopyWith<_$PeriodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) {
  return _SubjectModel.fromJson(json);
}

/// @nodoc
mixin _$SubjectModel {
  @JsonKey(name: 'codeMatiere')
  String get codeMatiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'discipline')
  String get discipline => throw _privateConstructorUsedError;
  @JsonKey(name: 'coef')
  double get coef => throw _privateConstructorUsedError;
  String? get professeur => throw _privateConstructorUsedError;
  String? get moyenne => throw _privateConstructorUsedError;
  String? get moyenneClasse => throw _privateConstructorUsedError;
  String? get moyenneMin => throw _privateConstructorUsedError;
  String? get moyenneMax => throw _privateConstructorUsedError;

  /// Serializes this SubjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubjectModelCopyWith<SubjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectModelCopyWith<$Res> {
  factory $SubjectModelCopyWith(
    SubjectModel value,
    $Res Function(SubjectModel) then,
  ) = _$SubjectModelCopyWithImpl<$Res, SubjectModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'codeMatiere') String codeMatiere,
    @JsonKey(name: 'discipline') String discipline,
    @JsonKey(name: 'coef') double coef,
    String? professeur,
    String? moyenne,
    String? moyenneClasse,
    String? moyenneMin,
    String? moyenneMax,
  });
}

/// @nodoc
class _$SubjectModelCopyWithImpl<$Res, $Val extends SubjectModel>
    implements $SubjectModelCopyWith<$Res> {
  _$SubjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeMatiere = null,
    Object? discipline = null,
    Object? coef = null,
    Object? professeur = freezed,
    Object? moyenne = freezed,
    Object? moyenneClasse = freezed,
    Object? moyenneMin = freezed,
    Object? moyenneMax = freezed,
  }) {
    return _then(
      _value.copyWith(
            codeMatiere: null == codeMatiere
                ? _value.codeMatiere
                : codeMatiere // ignore: cast_nullable_to_non_nullable
                      as String,
            discipline: null == discipline
                ? _value.discipline
                : discipline // ignore: cast_nullable_to_non_nullable
                      as String,
            coef: null == coef
                ? _value.coef
                : coef // ignore: cast_nullable_to_non_nullable
                      as double,
            professeur: freezed == professeur
                ? _value.professeur
                : professeur // ignore: cast_nullable_to_non_nullable
                      as String?,
            moyenne: freezed == moyenne
                ? _value.moyenne
                : moyenne // ignore: cast_nullable_to_non_nullable
                      as String?,
            moyenneClasse: freezed == moyenneClasse
                ? _value.moyenneClasse
                : moyenneClasse // ignore: cast_nullable_to_non_nullable
                      as String?,
            moyenneMin: freezed == moyenneMin
                ? _value.moyenneMin
                : moyenneMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            moyenneMax: freezed == moyenneMax
                ? _value.moyenneMax
                : moyenneMax // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubjectModelImplCopyWith<$Res>
    implements $SubjectModelCopyWith<$Res> {
  factory _$$SubjectModelImplCopyWith(
    _$SubjectModelImpl value,
    $Res Function(_$SubjectModelImpl) then,
  ) = __$$SubjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'codeMatiere') String codeMatiere,
    @JsonKey(name: 'discipline') String discipline,
    @JsonKey(name: 'coef') double coef,
    String? professeur,
    String? moyenne,
    String? moyenneClasse,
    String? moyenneMin,
    String? moyenneMax,
  });
}

/// @nodoc
class __$$SubjectModelImplCopyWithImpl<$Res>
    extends _$SubjectModelCopyWithImpl<$Res, _$SubjectModelImpl>
    implements _$$SubjectModelImplCopyWith<$Res> {
  __$$SubjectModelImplCopyWithImpl(
    _$SubjectModelImpl _value,
    $Res Function(_$SubjectModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeMatiere = null,
    Object? discipline = null,
    Object? coef = null,
    Object? professeur = freezed,
    Object? moyenne = freezed,
    Object? moyenneClasse = freezed,
    Object? moyenneMin = freezed,
    Object? moyenneMax = freezed,
  }) {
    return _then(
      _$SubjectModelImpl(
        codeMatiere: null == codeMatiere
            ? _value.codeMatiere
            : codeMatiere // ignore: cast_nullable_to_non_nullable
                  as String,
        discipline: null == discipline
            ? _value.discipline
            : discipline // ignore: cast_nullable_to_non_nullable
                  as String,
        coef: null == coef
            ? _value.coef
            : coef // ignore: cast_nullable_to_non_nullable
                  as double,
        professeur: freezed == professeur
            ? _value.professeur
            : professeur // ignore: cast_nullable_to_non_nullable
                  as String?,
        moyenne: freezed == moyenne
            ? _value.moyenne
            : moyenne // ignore: cast_nullable_to_non_nullable
                  as String?,
        moyenneClasse: freezed == moyenneClasse
            ? _value.moyenneClasse
            : moyenneClasse // ignore: cast_nullable_to_non_nullable
                  as String?,
        moyenneMin: freezed == moyenneMin
            ? _value.moyenneMin
            : moyenneMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        moyenneMax: freezed == moyenneMax
            ? _value.moyenneMax
            : moyenneMax // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubjectModelImpl implements _SubjectModel {
  const _$SubjectModelImpl({
    @JsonKey(name: 'codeMatiere') required this.codeMatiere,
    @JsonKey(name: 'discipline') required this.discipline,
    @JsonKey(name: 'coef') this.coef = 1.0,
    this.professeur,
    this.moyenne,
    this.moyenneClasse,
    this.moyenneMin,
    this.moyenneMax,
  });

  factory _$SubjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubjectModelImplFromJson(json);

  @override
  @JsonKey(name: 'codeMatiere')
  final String codeMatiere;
  @override
  @JsonKey(name: 'discipline')
  final String discipline;
  @override
  @JsonKey(name: 'coef')
  final double coef;
  @override
  final String? professeur;
  @override
  final String? moyenne;
  @override
  final String? moyenneClasse;
  @override
  final String? moyenneMin;
  @override
  final String? moyenneMax;

  @override
  String toString() {
    return 'SubjectModel(codeMatiere: $codeMatiere, discipline: $discipline, coef: $coef, professeur: $professeur, moyenne: $moyenne, moyenneClasse: $moyenneClasse, moyenneMin: $moyenneMin, moyenneMax: $moyenneMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubjectModelImpl &&
            (identical(other.codeMatiere, codeMatiere) ||
                other.codeMatiere == codeMatiere) &&
            (identical(other.discipline, discipline) ||
                other.discipline == discipline) &&
            (identical(other.coef, coef) || other.coef == coef) &&
            (identical(other.professeur, professeur) ||
                other.professeur == professeur) &&
            (identical(other.moyenne, moyenne) || other.moyenne == moyenne) &&
            (identical(other.moyenneClasse, moyenneClasse) ||
                other.moyenneClasse == moyenneClasse) &&
            (identical(other.moyenneMin, moyenneMin) ||
                other.moyenneMin == moyenneMin) &&
            (identical(other.moyenneMax, moyenneMax) ||
                other.moyenneMax == moyenneMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    codeMatiere,
    discipline,
    coef,
    professeur,
    moyenne,
    moyenneClasse,
    moyenneMin,
    moyenneMax,
  );

  /// Create a copy of SubjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubjectModelImplCopyWith<_$SubjectModelImpl> get copyWith =>
      __$$SubjectModelImplCopyWithImpl<_$SubjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubjectModelImplToJson(this);
  }
}

abstract class _SubjectModel implements SubjectModel {
  const factory _SubjectModel({
    @JsonKey(name: 'codeMatiere') required final String codeMatiere,
    @JsonKey(name: 'discipline') required final String discipline,
    @JsonKey(name: 'coef') final double coef,
    final String? professeur,
    final String? moyenne,
    final String? moyenneClasse,
    final String? moyenneMin,
    final String? moyenneMax,
  }) = _$SubjectModelImpl;

  factory _SubjectModel.fromJson(Map<String, dynamic> json) =
      _$SubjectModelImpl.fromJson;

  @override
  @JsonKey(name: 'codeMatiere')
  String get codeMatiere;
  @override
  @JsonKey(name: 'discipline')
  String get discipline;
  @override
  @JsonKey(name: 'coef')
  double get coef;
  @override
  String? get professeur;
  @override
  String? get moyenne;
  @override
  String? get moyenneClasse;
  @override
  String? get moyenneMin;
  @override
  String? get moyenneMax;

  /// Create a copy of SubjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubjectModelImplCopyWith<_$SubjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vie_scolaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AbsenceRetardModel _$AbsenceRetardModelFromJson(Map<String, dynamic> json) {
  return _AbsenceRetardModel.fromJson(json);
}

/// @nodoc
mixin _$AbsenceRetardModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'idEleve')
  int? get idEleve => throw _privateConstructorUsedError;
  @JsonKey(name: 'typeElement')
  String get typeElement => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'displayDate')
  String? get displayDate => throw _privateConstructorUsedError;
  String? get libelle => throw _privateConstructorUsedError;
  bool get justifie => throw _privateConstructorUsedError;
  @JsonKey(name: 'typeJustification')
  String? get typeJustification => throw _privateConstructorUsedError;
  String? get commentaire => throw _privateConstructorUsedError;
  String? get motif => throw _privateConstructorUsedError;

  /// Serializes this AbsenceRetardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AbsenceRetardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbsenceRetardModelCopyWith<AbsenceRetardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbsenceRetardModelCopyWith<$Res> {
  factory $AbsenceRetardModelCopyWith(
    AbsenceRetardModel value,
    $Res Function(AbsenceRetardModel) then,
  ) = _$AbsenceRetardModelCopyWithImpl<$Res, AbsenceRetardModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    bool justifie,
    @JsonKey(name: 'typeJustification') String? typeJustification,
    String? commentaire,
    String? motif,
  });
}

/// @nodoc
class _$AbsenceRetardModelCopyWithImpl<$Res, $Val extends AbsenceRetardModel>
    implements $AbsenceRetardModelCopyWith<$Res> {
  _$AbsenceRetardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbsenceRetardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEleve = freezed,
    Object? typeElement = null,
    Object? date = freezed,
    Object? displayDate = freezed,
    Object? libelle = freezed,
    Object? justifie = null,
    Object? typeJustification = freezed,
    Object? commentaire = freezed,
    Object? motif = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            idEleve: freezed == idEleve
                ? _value.idEleve
                : idEleve // ignore: cast_nullable_to_non_nullable
                      as int?,
            typeElement: null == typeElement
                ? _value.typeElement
                : typeElement // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayDate: freezed == displayDate
                ? _value.displayDate
                : displayDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            libelle: freezed == libelle
                ? _value.libelle
                : libelle // ignore: cast_nullable_to_non_nullable
                      as String?,
            justifie: null == justifie
                ? _value.justifie
                : justifie // ignore: cast_nullable_to_non_nullable
                      as bool,
            typeJustification: freezed == typeJustification
                ? _value.typeJustification
                : typeJustification // ignore: cast_nullable_to_non_nullable
                      as String?,
            commentaire: freezed == commentaire
                ? _value.commentaire
                : commentaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            motif: freezed == motif
                ? _value.motif
                : motif // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AbsenceRetardModelImplCopyWith<$Res>
    implements $AbsenceRetardModelCopyWith<$Res> {
  factory _$$AbsenceRetardModelImplCopyWith(
    _$AbsenceRetardModelImpl value,
    $Res Function(_$AbsenceRetardModelImpl) then,
  ) = __$$AbsenceRetardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    bool justifie,
    @JsonKey(name: 'typeJustification') String? typeJustification,
    String? commentaire,
    String? motif,
  });
}

/// @nodoc
class __$$AbsenceRetardModelImplCopyWithImpl<$Res>
    extends _$AbsenceRetardModelCopyWithImpl<$Res, _$AbsenceRetardModelImpl>
    implements _$$AbsenceRetardModelImplCopyWith<$Res> {
  __$$AbsenceRetardModelImplCopyWithImpl(
    _$AbsenceRetardModelImpl _value,
    $Res Function(_$AbsenceRetardModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AbsenceRetardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEleve = freezed,
    Object? typeElement = null,
    Object? date = freezed,
    Object? displayDate = freezed,
    Object? libelle = freezed,
    Object? justifie = null,
    Object? typeJustification = freezed,
    Object? commentaire = freezed,
    Object? motif = freezed,
  }) {
    return _then(
      _$AbsenceRetardModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        idEleve: freezed == idEleve
            ? _value.idEleve
            : idEleve // ignore: cast_nullable_to_non_nullable
                  as int?,
        typeElement: null == typeElement
            ? _value.typeElement
            : typeElement // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayDate: freezed == displayDate
            ? _value.displayDate
            : displayDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        libelle: freezed == libelle
            ? _value.libelle
            : libelle // ignore: cast_nullable_to_non_nullable
                  as String?,
        justifie: null == justifie
            ? _value.justifie
            : justifie // ignore: cast_nullable_to_non_nullable
                  as bool,
        typeJustification: freezed == typeJustification
            ? _value.typeJustification
            : typeJustification // ignore: cast_nullable_to_non_nullable
                  as String?,
        commentaire: freezed == commentaire
            ? _value.commentaire
            : commentaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        motif: freezed == motif
            ? _value.motif
            : motif // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AbsenceRetardModelImpl implements _AbsenceRetardModel {
  const _$AbsenceRetardModelImpl({
    required this.id,
    @JsonKey(name: 'idEleve') this.idEleve,
    @JsonKey(name: 'typeElement') required this.typeElement,
    this.date,
    @JsonKey(name: 'displayDate') this.displayDate,
    this.libelle,
    this.justifie = false,
    @JsonKey(name: 'typeJustification') this.typeJustification,
    this.commentaire,
    this.motif,
  });

  factory _$AbsenceRetardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbsenceRetardModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'idEleve')
  final int? idEleve;
  @override
  @JsonKey(name: 'typeElement')
  final String typeElement;
  @override
  final String? date;
  @override
  @JsonKey(name: 'displayDate')
  final String? displayDate;
  @override
  final String? libelle;
  @override
  @JsonKey()
  final bool justifie;
  @override
  @JsonKey(name: 'typeJustification')
  final String? typeJustification;
  @override
  final String? commentaire;
  @override
  final String? motif;

  @override
  String toString() {
    return 'AbsenceRetardModel(id: $id, idEleve: $idEleve, typeElement: $typeElement, date: $date, displayDate: $displayDate, libelle: $libelle, justifie: $justifie, typeJustification: $typeJustification, commentaire: $commentaire, motif: $motif)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbsenceRetardModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idEleve, idEleve) || other.idEleve == idEleve) &&
            (identical(other.typeElement, typeElement) ||
                other.typeElement == typeElement) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.displayDate, displayDate) ||
                other.displayDate == displayDate) &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.justifie, justifie) ||
                other.justifie == justifie) &&
            (identical(other.typeJustification, typeJustification) ||
                other.typeJustification == typeJustification) &&
            (identical(other.commentaire, commentaire) ||
                other.commentaire == commentaire) &&
            (identical(other.motif, motif) || other.motif == motif));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idEleve,
    typeElement,
    date,
    displayDate,
    libelle,
    justifie,
    typeJustification,
    commentaire,
    motif,
  );

  /// Create a copy of AbsenceRetardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbsenceRetardModelImplCopyWith<_$AbsenceRetardModelImpl> get copyWith =>
      __$$AbsenceRetardModelImplCopyWithImpl<_$AbsenceRetardModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AbsenceRetardModelImplToJson(this);
  }
}

abstract class _AbsenceRetardModel implements AbsenceRetardModel {
  const factory _AbsenceRetardModel({
    required final int id,
    @JsonKey(name: 'idEleve') final int? idEleve,
    @JsonKey(name: 'typeElement') required final String typeElement,
    final String? date,
    @JsonKey(name: 'displayDate') final String? displayDate,
    final String? libelle,
    final bool justifie,
    @JsonKey(name: 'typeJustification') final String? typeJustification,
    final String? commentaire,
    final String? motif,
  }) = _$AbsenceRetardModelImpl;

  factory _AbsenceRetardModel.fromJson(Map<String, dynamic> json) =
      _$AbsenceRetardModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'idEleve')
  int? get idEleve;
  @override
  @JsonKey(name: 'typeElement')
  String get typeElement;
  @override
  String? get date;
  @override
  @JsonKey(name: 'displayDate')
  String? get displayDate;
  @override
  String? get libelle;
  @override
  bool get justifie;
  @override
  @JsonKey(name: 'typeJustification')
  String? get typeJustification;
  @override
  String? get commentaire;
  @override
  String? get motif;

  /// Create a copy of AbsenceRetardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbsenceRetardModelImplCopyWith<_$AbsenceRetardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SanctionEncouragementModel _$SanctionEncouragementModelFromJson(
  Map<String, dynamic> json,
) {
  return _SanctionEncouragementModel.fromJson(json);
}

/// @nodoc
mixin _$SanctionEncouragementModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'idEleve')
  int? get idEleve => throw _privateConstructorUsedError;
  @JsonKey(name: 'typeElement')
  String get typeElement => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'displayDate')
  String? get displayDate => throw _privateConstructorUsedError;
  String? get libelle => throw _privateConstructorUsedError;
  String? get motif => throw _privateConstructorUsedError;
  bool get justifie => throw _privateConstructorUsedError;
  String? get par => throw _privateConstructorUsedError;
  String? get commentaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'aFaire')
  String? get aFaire => throw _privateConstructorUsedError;
  @JsonKey(name: 'dateDeroulement')
  String? get dateDeroulement => throw _privateConstructorUsedError;

  /// Serializes this SanctionEncouragementModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SanctionEncouragementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SanctionEncouragementModelCopyWith<SanctionEncouragementModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SanctionEncouragementModelCopyWith<$Res> {
  factory $SanctionEncouragementModelCopyWith(
    SanctionEncouragementModel value,
    $Res Function(SanctionEncouragementModel) then,
  ) =
      _$SanctionEncouragementModelCopyWithImpl<
        $Res,
        SanctionEncouragementModel
      >;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    String? motif,
    bool justifie,
    String? par,
    String? commentaire,
    @JsonKey(name: 'aFaire') String? aFaire,
    @JsonKey(name: 'dateDeroulement') String? dateDeroulement,
  });
}

/// @nodoc
class _$SanctionEncouragementModelCopyWithImpl<
  $Res,
  $Val extends SanctionEncouragementModel
>
    implements $SanctionEncouragementModelCopyWith<$Res> {
  _$SanctionEncouragementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SanctionEncouragementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEleve = freezed,
    Object? typeElement = null,
    Object? date = freezed,
    Object? displayDate = freezed,
    Object? libelle = freezed,
    Object? motif = freezed,
    Object? justifie = null,
    Object? par = freezed,
    Object? commentaire = freezed,
    Object? aFaire = freezed,
    Object? dateDeroulement = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            idEleve: freezed == idEleve
                ? _value.idEleve
                : idEleve // ignore: cast_nullable_to_non_nullable
                      as int?,
            typeElement: null == typeElement
                ? _value.typeElement
                : typeElement // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayDate: freezed == displayDate
                ? _value.displayDate
                : displayDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            libelle: freezed == libelle
                ? _value.libelle
                : libelle // ignore: cast_nullable_to_non_nullable
                      as String?,
            motif: freezed == motif
                ? _value.motif
                : motif // ignore: cast_nullable_to_non_nullable
                      as String?,
            justifie: null == justifie
                ? _value.justifie
                : justifie // ignore: cast_nullable_to_non_nullable
                      as bool,
            par: freezed == par
                ? _value.par
                : par // ignore: cast_nullable_to_non_nullable
                      as String?,
            commentaire: freezed == commentaire
                ? _value.commentaire
                : commentaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            aFaire: freezed == aFaire
                ? _value.aFaire
                : aFaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateDeroulement: freezed == dateDeroulement
                ? _value.dateDeroulement
                : dateDeroulement // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SanctionEncouragementModelImplCopyWith<$Res>
    implements $SanctionEncouragementModelCopyWith<$Res> {
  factory _$$SanctionEncouragementModelImplCopyWith(
    _$SanctionEncouragementModelImpl value,
    $Res Function(_$SanctionEncouragementModelImpl) then,
  ) = __$$SanctionEncouragementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'idEleve') int? idEleve,
    @JsonKey(name: 'typeElement') String typeElement,
    String? date,
    @JsonKey(name: 'displayDate') String? displayDate,
    String? libelle,
    String? motif,
    bool justifie,
    String? par,
    String? commentaire,
    @JsonKey(name: 'aFaire') String? aFaire,
    @JsonKey(name: 'dateDeroulement') String? dateDeroulement,
  });
}

/// @nodoc
class __$$SanctionEncouragementModelImplCopyWithImpl<$Res>
    extends
        _$SanctionEncouragementModelCopyWithImpl<
          $Res,
          _$SanctionEncouragementModelImpl
        >
    implements _$$SanctionEncouragementModelImplCopyWith<$Res> {
  __$$SanctionEncouragementModelImplCopyWithImpl(
    _$SanctionEncouragementModelImpl _value,
    $Res Function(_$SanctionEncouragementModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SanctionEncouragementModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idEleve = freezed,
    Object? typeElement = null,
    Object? date = freezed,
    Object? displayDate = freezed,
    Object? libelle = freezed,
    Object? motif = freezed,
    Object? justifie = null,
    Object? par = freezed,
    Object? commentaire = freezed,
    Object? aFaire = freezed,
    Object? dateDeroulement = freezed,
  }) {
    return _then(
      _$SanctionEncouragementModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        idEleve: freezed == idEleve
            ? _value.idEleve
            : idEleve // ignore: cast_nullable_to_non_nullable
                  as int?,
        typeElement: null == typeElement
            ? _value.typeElement
            : typeElement // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayDate: freezed == displayDate
            ? _value.displayDate
            : displayDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        libelle: freezed == libelle
            ? _value.libelle
            : libelle // ignore: cast_nullable_to_non_nullable
                  as String?,
        motif: freezed == motif
            ? _value.motif
            : motif // ignore: cast_nullable_to_non_nullable
                  as String?,
        justifie: null == justifie
            ? _value.justifie
            : justifie // ignore: cast_nullable_to_non_nullable
                  as bool,
        par: freezed == par
            ? _value.par
            : par // ignore: cast_nullable_to_non_nullable
                  as String?,
        commentaire: freezed == commentaire
            ? _value.commentaire
            : commentaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        aFaire: freezed == aFaire
            ? _value.aFaire
            : aFaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateDeroulement: freezed == dateDeroulement
            ? _value.dateDeroulement
            : dateDeroulement // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SanctionEncouragementModelImpl implements _SanctionEncouragementModel {
  const _$SanctionEncouragementModelImpl({
    required this.id,
    @JsonKey(name: 'idEleve') this.idEleve,
    @JsonKey(name: 'typeElement') required this.typeElement,
    this.date,
    @JsonKey(name: 'displayDate') this.displayDate,
    this.libelle,
    this.motif,
    this.justifie = false,
    this.par,
    this.commentaire,
    @JsonKey(name: 'aFaire') this.aFaire,
    @JsonKey(name: 'dateDeroulement') this.dateDeroulement,
  });

  factory _$SanctionEncouragementModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SanctionEncouragementModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'idEleve')
  final int? idEleve;
  @override
  @JsonKey(name: 'typeElement')
  final String typeElement;
  @override
  final String? date;
  @override
  @JsonKey(name: 'displayDate')
  final String? displayDate;
  @override
  final String? libelle;
  @override
  final String? motif;
  @override
  @JsonKey()
  final bool justifie;
  @override
  final String? par;
  @override
  final String? commentaire;
  @override
  @JsonKey(name: 'aFaire')
  final String? aFaire;
  @override
  @JsonKey(name: 'dateDeroulement')
  final String? dateDeroulement;

  @override
  String toString() {
    return 'SanctionEncouragementModel(id: $id, idEleve: $idEleve, typeElement: $typeElement, date: $date, displayDate: $displayDate, libelle: $libelle, motif: $motif, justifie: $justifie, par: $par, commentaire: $commentaire, aFaire: $aFaire, dateDeroulement: $dateDeroulement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SanctionEncouragementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idEleve, idEleve) || other.idEleve == idEleve) &&
            (identical(other.typeElement, typeElement) ||
                other.typeElement == typeElement) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.displayDate, displayDate) ||
                other.displayDate == displayDate) &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.motif, motif) || other.motif == motif) &&
            (identical(other.justifie, justifie) ||
                other.justifie == justifie) &&
            (identical(other.par, par) || other.par == par) &&
            (identical(other.commentaire, commentaire) ||
                other.commentaire == commentaire) &&
            (identical(other.aFaire, aFaire) || other.aFaire == aFaire) &&
            (identical(other.dateDeroulement, dateDeroulement) ||
                other.dateDeroulement == dateDeroulement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idEleve,
    typeElement,
    date,
    displayDate,
    libelle,
    motif,
    justifie,
    par,
    commentaire,
    aFaire,
    dateDeroulement,
  );

  /// Create a copy of SanctionEncouragementModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SanctionEncouragementModelImplCopyWith<_$SanctionEncouragementModelImpl>
  get copyWith =>
      __$$SanctionEncouragementModelImplCopyWithImpl<
        _$SanctionEncouragementModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SanctionEncouragementModelImplToJson(this);
  }
}

abstract class _SanctionEncouragementModel
    implements SanctionEncouragementModel {
  const factory _SanctionEncouragementModel({
    required final int id,
    @JsonKey(name: 'idEleve') final int? idEleve,
    @JsonKey(name: 'typeElement') required final String typeElement,
    final String? date,
    @JsonKey(name: 'displayDate') final String? displayDate,
    final String? libelle,
    final String? motif,
    final bool justifie,
    final String? par,
    final String? commentaire,
    @JsonKey(name: 'aFaire') final String? aFaire,
    @JsonKey(name: 'dateDeroulement') final String? dateDeroulement,
  }) = _$SanctionEncouragementModelImpl;

  factory _SanctionEncouragementModel.fromJson(Map<String, dynamic> json) =
      _$SanctionEncouragementModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'idEleve')
  int? get idEleve;
  @override
  @JsonKey(name: 'typeElement')
  String get typeElement;
  @override
  String? get date;
  @override
  @JsonKey(name: 'displayDate')
  String? get displayDate;
  @override
  String? get libelle;
  @override
  String? get motif;
  @override
  bool get justifie;
  @override
  String? get par;
  @override
  String? get commentaire;
  @override
  @JsonKey(name: 'aFaire')
  String? get aFaire;
  @override
  @JsonKey(name: 'dateDeroulement')
  String? get dateDeroulement;

  /// Create a copy of SanctionEncouragementModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SanctionEncouragementModelImplCopyWith<_$SanctionEncouragementModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VieScolaireData _$VieScolaireDataFromJson(Map<String, dynamic> json) {
  return _VieScolaireData.fromJson(json);
}

/// @nodoc
mixin _$VieScolaireData {
  List<AbsenceRetardModel> get absencesRetards =>
      throw _privateConstructorUsedError;
  List<SanctionEncouragementModel> get sanctionsEncouragements =>
      throw _privateConstructorUsedError;
  VieScolaireParametrage? get parametrage => throw _privateConstructorUsedError;

  /// Serializes this VieScolaireData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VieScolaireDataCopyWith<VieScolaireData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VieScolaireDataCopyWith<$Res> {
  factory $VieScolaireDataCopyWith(
    VieScolaireData value,
    $Res Function(VieScolaireData) then,
  ) = _$VieScolaireDataCopyWithImpl<$Res, VieScolaireData>;
  @useResult
  $Res call({
    List<AbsenceRetardModel> absencesRetards,
    List<SanctionEncouragementModel> sanctionsEncouragements,
    VieScolaireParametrage? parametrage,
  });

  $VieScolaireParametrageCopyWith<$Res>? get parametrage;
}

/// @nodoc
class _$VieScolaireDataCopyWithImpl<$Res, $Val extends VieScolaireData>
    implements $VieScolaireDataCopyWith<$Res> {
  _$VieScolaireDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absencesRetards = null,
    Object? sanctionsEncouragements = null,
    Object? parametrage = freezed,
  }) {
    return _then(
      _value.copyWith(
            absencesRetards: null == absencesRetards
                ? _value.absencesRetards
                : absencesRetards // ignore: cast_nullable_to_non_nullable
                      as List<AbsenceRetardModel>,
            sanctionsEncouragements: null == sanctionsEncouragements
                ? _value.sanctionsEncouragements
                : sanctionsEncouragements // ignore: cast_nullable_to_non_nullable
                      as List<SanctionEncouragementModel>,
            parametrage: freezed == parametrage
                ? _value.parametrage
                : parametrage // ignore: cast_nullable_to_non_nullable
                      as VieScolaireParametrage?,
          )
          as $Val,
    );
  }

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VieScolaireParametrageCopyWith<$Res>? get parametrage {
    if (_value.parametrage == null) {
      return null;
    }

    return $VieScolaireParametrageCopyWith<$Res>(_value.parametrage!, (value) {
      return _then(_value.copyWith(parametrage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VieScolaireDataImplCopyWith<$Res>
    implements $VieScolaireDataCopyWith<$Res> {
  factory _$$VieScolaireDataImplCopyWith(
    _$VieScolaireDataImpl value,
    $Res Function(_$VieScolaireDataImpl) then,
  ) = __$$VieScolaireDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AbsenceRetardModel> absencesRetards,
    List<SanctionEncouragementModel> sanctionsEncouragements,
    VieScolaireParametrage? parametrage,
  });

  @override
  $VieScolaireParametrageCopyWith<$Res>? get parametrage;
}

/// @nodoc
class __$$VieScolaireDataImplCopyWithImpl<$Res>
    extends _$VieScolaireDataCopyWithImpl<$Res, _$VieScolaireDataImpl>
    implements _$$VieScolaireDataImplCopyWith<$Res> {
  __$$VieScolaireDataImplCopyWithImpl(
    _$VieScolaireDataImpl _value,
    $Res Function(_$VieScolaireDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absencesRetards = null,
    Object? sanctionsEncouragements = null,
    Object? parametrage = freezed,
  }) {
    return _then(
      _$VieScolaireDataImpl(
        absencesRetards: null == absencesRetards
            ? _value._absencesRetards
            : absencesRetards // ignore: cast_nullable_to_non_nullable
                  as List<AbsenceRetardModel>,
        sanctionsEncouragements: null == sanctionsEncouragements
            ? _value._sanctionsEncouragements
            : sanctionsEncouragements // ignore: cast_nullable_to_non_nullable
                  as List<SanctionEncouragementModel>,
        parametrage: freezed == parametrage
            ? _value.parametrage
            : parametrage // ignore: cast_nullable_to_non_nullable
                  as VieScolaireParametrage?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VieScolaireDataImpl extends _VieScolaireData {
  const _$VieScolaireDataImpl({
    final List<AbsenceRetardModel> absencesRetards = const [],
    final List<SanctionEncouragementModel> sanctionsEncouragements = const [],
    this.parametrage,
  }) : _absencesRetards = absencesRetards,
       _sanctionsEncouragements = sanctionsEncouragements,
       super._();

  factory _$VieScolaireDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VieScolaireDataImplFromJson(json);

  final List<AbsenceRetardModel> _absencesRetards;
  @override
  @JsonKey()
  List<AbsenceRetardModel> get absencesRetards {
    if (_absencesRetards is EqualUnmodifiableListView) return _absencesRetards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_absencesRetards);
  }

  final List<SanctionEncouragementModel> _sanctionsEncouragements;
  @override
  @JsonKey()
  List<SanctionEncouragementModel> get sanctionsEncouragements {
    if (_sanctionsEncouragements is EqualUnmodifiableListView)
      return _sanctionsEncouragements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sanctionsEncouragements);
  }

  @override
  final VieScolaireParametrage? parametrage;

  @override
  String toString() {
    return 'VieScolaireData(absencesRetards: $absencesRetards, sanctionsEncouragements: $sanctionsEncouragements, parametrage: $parametrage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VieScolaireDataImpl &&
            const DeepCollectionEquality().equals(
              other._absencesRetards,
              _absencesRetards,
            ) &&
            const DeepCollectionEquality().equals(
              other._sanctionsEncouragements,
              _sanctionsEncouragements,
            ) &&
            (identical(other.parametrage, parametrage) ||
                other.parametrage == parametrage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_absencesRetards),
    const DeepCollectionEquality().hash(_sanctionsEncouragements),
    parametrage,
  );

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VieScolaireDataImplCopyWith<_$VieScolaireDataImpl> get copyWith =>
      __$$VieScolaireDataImplCopyWithImpl<_$VieScolaireDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VieScolaireDataImplToJson(this);
  }
}

abstract class _VieScolaireData extends VieScolaireData {
  const factory _VieScolaireData({
    final List<AbsenceRetardModel> absencesRetards,
    final List<SanctionEncouragementModel> sanctionsEncouragements,
    final VieScolaireParametrage? parametrage,
  }) = _$VieScolaireDataImpl;
  const _VieScolaireData._() : super._();

  factory _VieScolaireData.fromJson(Map<String, dynamic> json) =
      _$VieScolaireDataImpl.fromJson;

  @override
  List<AbsenceRetardModel> get absencesRetards;
  @override
  List<SanctionEncouragementModel> get sanctionsEncouragements;
  @override
  VieScolaireParametrage? get parametrage;

  /// Create a copy of VieScolaireData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VieScolaireDataImplCopyWith<_$VieScolaireDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VieScolaireParametrage _$VieScolaireParametrageFromJson(
  Map<String, dynamic> json,
) {
  return _VieScolaireParametrage.fromJson(json);
}

/// @nodoc
mixin _$VieScolaireParametrage {
  bool get justificationEnLigne => throw _privateConstructorUsedError;
  bool get absenceCommentaire => throw _privateConstructorUsedError;
  bool get retardCommentaire => throw _privateConstructorUsedError;
  bool get sanctionsVisible => throw _privateConstructorUsedError;
  bool get sanctionParQui => throw _privateConstructorUsedError;
  bool get sanctionCommentaire => throw _privateConstructorUsedError;
  bool get encouragementsVisible => throw _privateConstructorUsedError;

  /// Serializes this VieScolaireParametrage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VieScolaireParametrage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VieScolaireParametrageCopyWith<VieScolaireParametrage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VieScolaireParametrageCopyWith<$Res> {
  factory $VieScolaireParametrageCopyWith(
    VieScolaireParametrage value,
    $Res Function(VieScolaireParametrage) then,
  ) = _$VieScolaireParametrageCopyWithImpl<$Res, VieScolaireParametrage>;
  @useResult
  $Res call({
    bool justificationEnLigne,
    bool absenceCommentaire,
    bool retardCommentaire,
    bool sanctionsVisible,
    bool sanctionParQui,
    bool sanctionCommentaire,
    bool encouragementsVisible,
  });
}

/// @nodoc
class _$VieScolaireParametrageCopyWithImpl<
  $Res,
  $Val extends VieScolaireParametrage
>
    implements $VieScolaireParametrageCopyWith<$Res> {
  _$VieScolaireParametrageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VieScolaireParametrage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? justificationEnLigne = null,
    Object? absenceCommentaire = null,
    Object? retardCommentaire = null,
    Object? sanctionsVisible = null,
    Object? sanctionParQui = null,
    Object? sanctionCommentaire = null,
    Object? encouragementsVisible = null,
  }) {
    return _then(
      _value.copyWith(
            justificationEnLigne: null == justificationEnLigne
                ? _value.justificationEnLigne
                : justificationEnLigne // ignore: cast_nullable_to_non_nullable
                      as bool,
            absenceCommentaire: null == absenceCommentaire
                ? _value.absenceCommentaire
                : absenceCommentaire // ignore: cast_nullable_to_non_nullable
                      as bool,
            retardCommentaire: null == retardCommentaire
                ? _value.retardCommentaire
                : retardCommentaire // ignore: cast_nullable_to_non_nullable
                      as bool,
            sanctionsVisible: null == sanctionsVisible
                ? _value.sanctionsVisible
                : sanctionsVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            sanctionParQui: null == sanctionParQui
                ? _value.sanctionParQui
                : sanctionParQui // ignore: cast_nullable_to_non_nullable
                      as bool,
            sanctionCommentaire: null == sanctionCommentaire
                ? _value.sanctionCommentaire
                : sanctionCommentaire // ignore: cast_nullable_to_non_nullable
                      as bool,
            encouragementsVisible: null == encouragementsVisible
                ? _value.encouragementsVisible
                : encouragementsVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VieScolaireParametrageImplCopyWith<$Res>
    implements $VieScolaireParametrageCopyWith<$Res> {
  factory _$$VieScolaireParametrageImplCopyWith(
    _$VieScolaireParametrageImpl value,
    $Res Function(_$VieScolaireParametrageImpl) then,
  ) = __$$VieScolaireParametrageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool justificationEnLigne,
    bool absenceCommentaire,
    bool retardCommentaire,
    bool sanctionsVisible,
    bool sanctionParQui,
    bool sanctionCommentaire,
    bool encouragementsVisible,
  });
}

/// @nodoc
class __$$VieScolaireParametrageImplCopyWithImpl<$Res>
    extends
        _$VieScolaireParametrageCopyWithImpl<$Res, _$VieScolaireParametrageImpl>
    implements _$$VieScolaireParametrageImplCopyWith<$Res> {
  __$$VieScolaireParametrageImplCopyWithImpl(
    _$VieScolaireParametrageImpl _value,
    $Res Function(_$VieScolaireParametrageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VieScolaireParametrage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? justificationEnLigne = null,
    Object? absenceCommentaire = null,
    Object? retardCommentaire = null,
    Object? sanctionsVisible = null,
    Object? sanctionParQui = null,
    Object? sanctionCommentaire = null,
    Object? encouragementsVisible = null,
  }) {
    return _then(
      _$VieScolaireParametrageImpl(
        justificationEnLigne: null == justificationEnLigne
            ? _value.justificationEnLigne
            : justificationEnLigne // ignore: cast_nullable_to_non_nullable
                  as bool,
        absenceCommentaire: null == absenceCommentaire
            ? _value.absenceCommentaire
            : absenceCommentaire // ignore: cast_nullable_to_non_nullable
                  as bool,
        retardCommentaire: null == retardCommentaire
            ? _value.retardCommentaire
            : retardCommentaire // ignore: cast_nullable_to_non_nullable
                  as bool,
        sanctionsVisible: null == sanctionsVisible
            ? _value.sanctionsVisible
            : sanctionsVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        sanctionParQui: null == sanctionParQui
            ? _value.sanctionParQui
            : sanctionParQui // ignore: cast_nullable_to_non_nullable
                  as bool,
        sanctionCommentaire: null == sanctionCommentaire
            ? _value.sanctionCommentaire
            : sanctionCommentaire // ignore: cast_nullable_to_non_nullable
                  as bool,
        encouragementsVisible: null == encouragementsVisible
            ? _value.encouragementsVisible
            : encouragementsVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VieScolaireParametrageImpl implements _VieScolaireParametrage {
  const _$VieScolaireParametrageImpl({
    this.justificationEnLigne = false,
    this.absenceCommentaire = false,
    this.retardCommentaire = false,
    this.sanctionsVisible = true,
    this.sanctionParQui = false,
    this.sanctionCommentaire = false,
    this.encouragementsVisible = true,
  });

  factory _$VieScolaireParametrageImpl.fromJson(Map<String, dynamic> json) =>
      _$$VieScolaireParametrageImplFromJson(json);

  @override
  @JsonKey()
  final bool justificationEnLigne;
  @override
  @JsonKey()
  final bool absenceCommentaire;
  @override
  @JsonKey()
  final bool retardCommentaire;
  @override
  @JsonKey()
  final bool sanctionsVisible;
  @override
  @JsonKey()
  final bool sanctionParQui;
  @override
  @JsonKey()
  final bool sanctionCommentaire;
  @override
  @JsonKey()
  final bool encouragementsVisible;

  @override
  String toString() {
    return 'VieScolaireParametrage(justificationEnLigne: $justificationEnLigne, absenceCommentaire: $absenceCommentaire, retardCommentaire: $retardCommentaire, sanctionsVisible: $sanctionsVisible, sanctionParQui: $sanctionParQui, sanctionCommentaire: $sanctionCommentaire, encouragementsVisible: $encouragementsVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VieScolaireParametrageImpl &&
            (identical(other.justificationEnLigne, justificationEnLigne) ||
                other.justificationEnLigne == justificationEnLigne) &&
            (identical(other.absenceCommentaire, absenceCommentaire) ||
                other.absenceCommentaire == absenceCommentaire) &&
            (identical(other.retardCommentaire, retardCommentaire) ||
                other.retardCommentaire == retardCommentaire) &&
            (identical(other.sanctionsVisible, sanctionsVisible) ||
                other.sanctionsVisible == sanctionsVisible) &&
            (identical(other.sanctionParQui, sanctionParQui) ||
                other.sanctionParQui == sanctionParQui) &&
            (identical(other.sanctionCommentaire, sanctionCommentaire) ||
                other.sanctionCommentaire == sanctionCommentaire) &&
            (identical(other.encouragementsVisible, encouragementsVisible) ||
                other.encouragementsVisible == encouragementsVisible));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    justificationEnLigne,
    absenceCommentaire,
    retardCommentaire,
    sanctionsVisible,
    sanctionParQui,
    sanctionCommentaire,
    encouragementsVisible,
  );

  /// Create a copy of VieScolaireParametrage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VieScolaireParametrageImplCopyWith<_$VieScolaireParametrageImpl>
  get copyWith =>
      __$$VieScolaireParametrageImplCopyWithImpl<_$VieScolaireParametrageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VieScolaireParametrageImplToJson(this);
  }
}

abstract class _VieScolaireParametrage implements VieScolaireParametrage {
  const factory _VieScolaireParametrage({
    final bool justificationEnLigne,
    final bool absenceCommentaire,
    final bool retardCommentaire,
    final bool sanctionsVisible,
    final bool sanctionParQui,
    final bool sanctionCommentaire,
    final bool encouragementsVisible,
  }) = _$VieScolaireParametrageImpl;

  factory _VieScolaireParametrage.fromJson(Map<String, dynamic> json) =
      _$VieScolaireParametrageImpl.fromJson;

  @override
  bool get justificationEnLigne;
  @override
  bool get absenceCommentaire;
  @override
  bool get retardCommentaire;
  @override
  bool get sanctionsVisible;
  @override
  bool get sanctionParQui;
  @override
  bool get sanctionCommentaire;
  @override
  bool get encouragementsVisible;

  /// Create a copy of VieScolaireParametrage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VieScolaireParametrageImplCopyWith<_$VieScolaireParametrageImpl>
  get copyWith => throw _privateConstructorUsedError;
}

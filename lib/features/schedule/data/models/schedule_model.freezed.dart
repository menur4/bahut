// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return _CourseModel.fromJson(json);
}

/// @nodoc
mixin _$CourseModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String? get endDate => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  String? get matiere => throw _privateConstructorUsedError;
  @JsonKey(name: 'codeMatiere')
  String? get codeMatiere => throw _privateConstructorUsedError;
  String? get typeCours => throw _privateConstructorUsedError;
  String? get salle => throw _privateConstructorUsedError;
  String? get prof => throw _privateConstructorUsedError;
  @JsonKey(name: 'classe')
  String? get classe => throw _privateConstructorUsedError;
  @JsonKey(name: 'classeId')
  int? get classeId => throw _privateConstructorUsedError;
  String? get classeCode => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  bool get isFlexible => throw _privateConstructorUsedError;
  bool get isModifie => throw _privateConstructorUsedError;
  bool get isAnnule => throw _privateConstructorUsedError;
  bool get contenuDeSeance => throw _privateConstructorUsedError;
  bool get devoirAFaire => throw _privateConstructorUsedError;

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseModelCopyWith<CourseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseModelCopyWith<$Res> {
  factory $CourseModelCopyWith(
    CourseModel value,
    $Res Function(CourseModel) then,
  ) = _$CourseModelCopyWithImpl<$Res, CourseModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    String? text,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    String? typeCours,
    String? salle,
    String? prof,
    @JsonKey(name: 'classe') String? classe,
    @JsonKey(name: 'classeId') int? classeId,
    String? classeCode,
    String? color,
    bool isFlexible,
    bool isModifie,
    bool isAnnule,
    bool contenuDeSeance,
    bool devoirAFaire,
  });
}

/// @nodoc
class _$CourseModelCopyWithImpl<$Res, $Val extends CourseModel>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? text = freezed,
    Object? matiere = freezed,
    Object? codeMatiere = freezed,
    Object? typeCours = freezed,
    Object? salle = freezed,
    Object? prof = freezed,
    Object? classe = freezed,
    Object? classeId = freezed,
    Object? classeCode = freezed,
    Object? color = freezed,
    Object? isFlexible = null,
    Object? isModifie = null,
    Object? isAnnule = null,
    Object? contenuDeSeance = null,
    Object? devoirAFaire = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            matiere: freezed == matiere
                ? _value.matiere
                : matiere // ignore: cast_nullable_to_non_nullable
                      as String?,
            codeMatiere: freezed == codeMatiere
                ? _value.codeMatiere
                : codeMatiere // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeCours: freezed == typeCours
                ? _value.typeCours
                : typeCours // ignore: cast_nullable_to_non_nullable
                      as String?,
            salle: freezed == salle
                ? _value.salle
                : salle // ignore: cast_nullable_to_non_nullable
                      as String?,
            prof: freezed == prof
                ? _value.prof
                : prof // ignore: cast_nullable_to_non_nullable
                      as String?,
            classe: freezed == classe
                ? _value.classe
                : classe // ignore: cast_nullable_to_non_nullable
                      as String?,
            classeId: freezed == classeId
                ? _value.classeId
                : classeId // ignore: cast_nullable_to_non_nullable
                      as int?,
            classeCode: freezed == classeCode
                ? _value.classeCode
                : classeCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFlexible: null == isFlexible
                ? _value.isFlexible
                : isFlexible // ignore: cast_nullable_to_non_nullable
                      as bool,
            isModifie: null == isModifie
                ? _value.isModifie
                : isModifie // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAnnule: null == isAnnule
                ? _value.isAnnule
                : isAnnule // ignore: cast_nullable_to_non_nullable
                      as bool,
            contenuDeSeance: null == contenuDeSeance
                ? _value.contenuDeSeance
                : contenuDeSeance // ignore: cast_nullable_to_non_nullable
                      as bool,
            devoirAFaire: null == devoirAFaire
                ? _value.devoirAFaire
                : devoirAFaire // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseModelImplCopyWith<$Res>
    implements $CourseModelCopyWith<$Res> {
  factory _$$CourseModelImplCopyWith(
    _$CourseModelImpl value,
    $Res Function(_$CourseModelImpl) then,
  ) = __$$CourseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    String? text,
    String? matiere,
    @JsonKey(name: 'codeMatiere') String? codeMatiere,
    String? typeCours,
    String? salle,
    String? prof,
    @JsonKey(name: 'classe') String? classe,
    @JsonKey(name: 'classeId') int? classeId,
    String? classeCode,
    String? color,
    bool isFlexible,
    bool isModifie,
    bool isAnnule,
    bool contenuDeSeance,
    bool devoirAFaire,
  });
}

/// @nodoc
class __$$CourseModelImplCopyWithImpl<$Res>
    extends _$CourseModelCopyWithImpl<$Res, _$CourseModelImpl>
    implements _$$CourseModelImplCopyWith<$Res> {
  __$$CourseModelImplCopyWithImpl(
    _$CourseModelImpl _value,
    $Res Function(_$CourseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? text = freezed,
    Object? matiere = freezed,
    Object? codeMatiere = freezed,
    Object? typeCours = freezed,
    Object? salle = freezed,
    Object? prof = freezed,
    Object? classe = freezed,
    Object? classeId = freezed,
    Object? classeCode = freezed,
    Object? color = freezed,
    Object? isFlexible = null,
    Object? isModifie = null,
    Object? isAnnule = null,
    Object? contenuDeSeance = null,
    Object? devoirAFaire = null,
  }) {
    return _then(
      _$CourseModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        matiere: freezed == matiere
            ? _value.matiere
            : matiere // ignore: cast_nullable_to_non_nullable
                  as String?,
        codeMatiere: freezed == codeMatiere
            ? _value.codeMatiere
            : codeMatiere // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeCours: freezed == typeCours
            ? _value.typeCours
            : typeCours // ignore: cast_nullable_to_non_nullable
                  as String?,
        salle: freezed == salle
            ? _value.salle
            : salle // ignore: cast_nullable_to_non_nullable
                  as String?,
        prof: freezed == prof
            ? _value.prof
            : prof // ignore: cast_nullable_to_non_nullable
                  as String?,
        classe: freezed == classe
            ? _value.classe
            : classe // ignore: cast_nullable_to_non_nullable
                  as String?,
        classeId: freezed == classeId
            ? _value.classeId
            : classeId // ignore: cast_nullable_to_non_nullable
                  as int?,
        classeCode: freezed == classeCode
            ? _value.classeCode
            : classeCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFlexible: null == isFlexible
            ? _value.isFlexible
            : isFlexible // ignore: cast_nullable_to_non_nullable
                  as bool,
        isModifie: null == isModifie
            ? _value.isModifie
            : isModifie // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAnnule: null == isAnnule
            ? _value.isAnnule
            : isAnnule // ignore: cast_nullable_to_non_nullable
                  as bool,
        contenuDeSeance: null == contenuDeSeance
            ? _value.contenuDeSeance
            : contenuDeSeance // ignore: cast_nullable_to_non_nullable
                  as bool,
        devoirAFaire: null == devoirAFaire
            ? _value.devoirAFaire
            : devoirAFaire // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseModelImpl extends _CourseModel {
  const _$CourseModelImpl({
    this.id,
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    this.text,
    this.matiere,
    @JsonKey(name: 'codeMatiere') this.codeMatiere,
    this.typeCours,
    this.salle,
    this.prof,
    @JsonKey(name: 'classe') this.classe,
    @JsonKey(name: 'classeId') this.classeId,
    this.classeCode,
    this.color,
    this.isFlexible = false,
    this.isModifie = false,
    this.isAnnule = false,
    this.contenuDeSeance = false,
    this.devoirAFaire = false,
  }) : super._();

  factory _$CourseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'start_date')
  final String? startDate;
  @override
  @JsonKey(name: 'end_date')
  final String? endDate;
  @override
  final String? text;
  @override
  final String? matiere;
  @override
  @JsonKey(name: 'codeMatiere')
  final String? codeMatiere;
  @override
  final String? typeCours;
  @override
  final String? salle;
  @override
  final String? prof;
  @override
  @JsonKey(name: 'classe')
  final String? classe;
  @override
  @JsonKey(name: 'classeId')
  final int? classeId;
  @override
  final String? classeCode;
  @override
  final String? color;
  @override
  @JsonKey()
  final bool isFlexible;
  @override
  @JsonKey()
  final bool isModifie;
  @override
  @JsonKey()
  final bool isAnnule;
  @override
  @JsonKey()
  final bool contenuDeSeance;
  @override
  @JsonKey()
  final bool devoirAFaire;

  @override
  String toString() {
    return 'CourseModel(id: $id, startDate: $startDate, endDate: $endDate, text: $text, matiere: $matiere, codeMatiere: $codeMatiere, typeCours: $typeCours, salle: $salle, prof: $prof, classe: $classe, classeId: $classeId, classeCode: $classeCode, color: $color, isFlexible: $isFlexible, isModifie: $isModifie, isAnnule: $isAnnule, contenuDeSeance: $contenuDeSeance, devoirAFaire: $devoirAFaire)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.matiere, matiere) || other.matiere == matiere) &&
            (identical(other.codeMatiere, codeMatiere) ||
                other.codeMatiere == codeMatiere) &&
            (identical(other.typeCours, typeCours) ||
                other.typeCours == typeCours) &&
            (identical(other.salle, salle) || other.salle == salle) &&
            (identical(other.prof, prof) || other.prof == prof) &&
            (identical(other.classe, classe) || other.classe == classe) &&
            (identical(other.classeId, classeId) ||
                other.classeId == classeId) &&
            (identical(other.classeCode, classeCode) ||
                other.classeCode == classeCode) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isFlexible, isFlexible) ||
                other.isFlexible == isFlexible) &&
            (identical(other.isModifie, isModifie) ||
                other.isModifie == isModifie) &&
            (identical(other.isAnnule, isAnnule) ||
                other.isAnnule == isAnnule) &&
            (identical(other.contenuDeSeance, contenuDeSeance) ||
                other.contenuDeSeance == contenuDeSeance) &&
            (identical(other.devoirAFaire, devoirAFaire) ||
                other.devoirAFaire == devoirAFaire));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    startDate,
    endDate,
    text,
    matiere,
    codeMatiere,
    typeCours,
    salle,
    prof,
    classe,
    classeId,
    classeCode,
    color,
    isFlexible,
    isModifie,
    isAnnule,
    contenuDeSeance,
    devoirAFaire,
  );

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      __$$CourseModelImplCopyWithImpl<_$CourseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseModelImplToJson(this);
  }
}

abstract class _CourseModel extends CourseModel {
  const factory _CourseModel({
    final int? id,
    @JsonKey(name: 'start_date') final String? startDate,
    @JsonKey(name: 'end_date') final String? endDate,
    final String? text,
    final String? matiere,
    @JsonKey(name: 'codeMatiere') final String? codeMatiere,
    final String? typeCours,
    final String? salle,
    final String? prof,
    @JsonKey(name: 'classe') final String? classe,
    @JsonKey(name: 'classeId') final int? classeId,
    final String? classeCode,
    final String? color,
    final bool isFlexible,
    final bool isModifie,
    final bool isAnnule,
    final bool contenuDeSeance,
    final bool devoirAFaire,
  }) = _$CourseModelImpl;
  const _CourseModel._() : super._();

  factory _CourseModel.fromJson(Map<String, dynamic> json) =
      _$CourseModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'start_date')
  String? get startDate;
  @override
  @JsonKey(name: 'end_date')
  String? get endDate;
  @override
  String? get text;
  @override
  String? get matiere;
  @override
  @JsonKey(name: 'codeMatiere')
  String? get codeMatiere;
  @override
  String? get typeCours;
  @override
  String? get salle;
  @override
  String? get prof;
  @override
  @JsonKey(name: 'classe')
  String? get classe;
  @override
  @JsonKey(name: 'classeId')
  int? get classeId;
  @override
  String? get classeCode;
  @override
  String? get color;
  @override
  bool get isFlexible;
  @override
  bool get isModifie;
  @override
  bool get isAnnule;
  @override
  bool get contenuDeSeance;
  @override
  bool get devoirAFaire;

  /// Create a copy of CourseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseModelImplCopyWith<_$CourseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleData {
  List<CourseModel> get courses => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleDataCopyWith<ScheduleData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleDataCopyWith<$Res> {
  factory $ScheduleDataCopyWith(
    ScheduleData value,
    $Res Function(ScheduleData) then,
  ) = _$ScheduleDataCopyWithImpl<$Res, ScheduleData>;
  @useResult
  $Res call({
    List<CourseModel> courses,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// @nodoc
class _$ScheduleDataCopyWithImpl<$Res, $Val extends ScheduleData>
    implements $ScheduleDataCopyWith<$Res> {
  _$ScheduleDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courses = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            courses: null == courses
                ? _value.courses
                : courses // ignore: cast_nullable_to_non_nullable
                      as List<CourseModel>,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleDataImplCopyWith<$Res>
    implements $ScheduleDataCopyWith<$Res> {
  factory _$$ScheduleDataImplCopyWith(
    _$ScheduleDataImpl value,
    $Res Function(_$ScheduleDataImpl) then,
  ) = __$$ScheduleDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CourseModel> courses,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// @nodoc
class __$$ScheduleDataImplCopyWithImpl<$Res>
    extends _$ScheduleDataCopyWithImpl<$Res, _$ScheduleDataImpl>
    implements _$$ScheduleDataImplCopyWith<$Res> {
  __$$ScheduleDataImplCopyWithImpl(
    _$ScheduleDataImpl _value,
    $Res Function(_$ScheduleDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courses = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$ScheduleDataImpl(
        courses: null == courses
            ? _value._courses
            : courses // ignore: cast_nullable_to_non_nullable
                  as List<CourseModel>,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$ScheduleDataImpl extends _ScheduleData {
  const _$ScheduleDataImpl({
    final List<CourseModel> courses = const [],
    this.startDate,
    this.endDate,
  }) : _courses = courses,
       super._();

  final List<CourseModel> _courses;
  @override
  @JsonKey()
  List<CourseModel> get courses {
    if (_courses is EqualUnmodifiableListView) return _courses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_courses);
  }

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'ScheduleData(courses: $courses, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleDataImpl &&
            const DeepCollectionEquality().equals(other._courses, _courses) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_courses),
    startDate,
    endDate,
  );

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleDataImplCopyWith<_$ScheduleDataImpl> get copyWith =>
      __$$ScheduleDataImplCopyWithImpl<_$ScheduleDataImpl>(this, _$identity);
}

abstract class _ScheduleData extends ScheduleData {
  const factory _ScheduleData({
    final List<CourseModel> courses,
    final DateTime? startDate,
    final DateTime? endDate,
  }) = _$ScheduleDataImpl;
  const _ScheduleData._() : super._();

  @override
  List<CourseModel> get courses;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;

  /// Create a copy of ScheduleData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleDataImplCopyWith<_$ScheduleDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) {
  return _AuthResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseModel {
  int get code => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  AuthDataModel? get data => throw _privateConstructorUsedError;

  /// Serializes this AuthResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseModelCopyWith<AuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseModelCopyWith<$Res> {
  factory $AuthResponseModelCopyWith(
    AuthResponseModel value,
    $Res Function(AuthResponseModel) then,
  ) = _$AuthResponseModelCopyWithImpl<$Res, AuthResponseModel>;
  @useResult
  $Res call({int code, String token, String? message, AuthDataModel? data});

  $AuthDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res, $Val extends AuthResponseModel>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? token = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as int,
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as AuthDataModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthDataModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $AuthDataModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$AuthResponseModelImplCopyWith(
    _$AuthResponseModelImpl value,
    $Res Function(_$AuthResponseModelImpl) then,
  ) = __$$AuthResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int code, String token, String? message, AuthDataModel? data});

  @override
  $AuthDataModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$AuthResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$AuthResponseModelImpl>
    implements _$$AuthResponseModelImplCopyWith<$Res> {
  __$$AuthResponseModelImplCopyWithImpl(
    _$AuthResponseModelImpl _value,
    $Res Function(_$AuthResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? token = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$AuthResponseModelImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as int,
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as AuthDataModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseModelImpl implements _AuthResponseModel {
  const _$AuthResponseModelImpl({
    required this.code,
    this.token = '',
    this.message,
    this.data,
  });

  factory _$AuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseModelImplFromJson(json);

  @override
  final int code;
  @override
  @JsonKey()
  final String token;
  @override
  final String? message;
  @override
  final AuthDataModel? data;

  @override
  String toString() {
    return 'AuthResponseModel(code: $code, token: $token, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseModelImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, token, message, data);

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      __$$AuthResponseModelImplCopyWithImpl<_$AuthResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseModelImplToJson(this);
  }
}

abstract class _AuthResponseModel implements AuthResponseModel {
  const factory _AuthResponseModel({
    required final int code,
    final String token,
    final String? message,
    final AuthDataModel? data,
  }) = _$AuthResponseModelImpl;

  factory _AuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$AuthResponseModelImpl.fromJson;

  @override
  int get code;
  @override
  String get token;
  @override
  String? get message;
  @override
  AuthDataModel? get data;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseModelImplCopyWith<_$AuthResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthDataModel _$AuthDataModelFromJson(Map<String, dynamic> json) {
  return _AuthDataModel.fromJson(json);
}

/// @nodoc
mixin _$AuthDataModel {
  List<UserModel> get accounts => throw _privateConstructorUsedError;

  /// Serializes this AuthDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthDataModelCopyWith<AuthDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthDataModelCopyWith<$Res> {
  factory $AuthDataModelCopyWith(
    AuthDataModel value,
    $Res Function(AuthDataModel) then,
  ) = _$AuthDataModelCopyWithImpl<$Res, AuthDataModel>;
  @useResult
  $Res call({List<UserModel> accounts});
}

/// @nodoc
class _$AuthDataModelCopyWithImpl<$Res, $Val extends AuthDataModel>
    implements $AuthDataModelCopyWith<$Res> {
  _$AuthDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accounts = null}) {
    return _then(
      _value.copyWith(
            accounts: null == accounts
                ? _value.accounts
                : accounts // ignore: cast_nullable_to_non_nullable
                      as List<UserModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthDataModelImplCopyWith<$Res>
    implements $AuthDataModelCopyWith<$Res> {
  factory _$$AuthDataModelImplCopyWith(
    _$AuthDataModelImpl value,
    $Res Function(_$AuthDataModelImpl) then,
  ) = __$$AuthDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserModel> accounts});
}

/// @nodoc
class __$$AuthDataModelImplCopyWithImpl<$Res>
    extends _$AuthDataModelCopyWithImpl<$Res, _$AuthDataModelImpl>
    implements _$$AuthDataModelImplCopyWith<$Res> {
  __$$AuthDataModelImplCopyWithImpl(
    _$AuthDataModelImpl _value,
    $Res Function(_$AuthDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accounts = null}) {
    return _then(
      _$AuthDataModelImpl(
        accounts: null == accounts
            ? _value._accounts
            : accounts // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthDataModelImpl implements _AuthDataModel {
  const _$AuthDataModelImpl({final List<UserModel> accounts = const []})
    : _accounts = accounts;

  factory _$AuthDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthDataModelImplFromJson(json);

  final List<UserModel> _accounts;
  @override
  @JsonKey()
  List<UserModel> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  @override
  String toString() {
    return 'AuthDataModel(accounts: $accounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDataModelImpl &&
            const DeepCollectionEquality().equals(other._accounts, _accounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_accounts));

  /// Create a copy of AuthDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDataModelImplCopyWith<_$AuthDataModelImpl> get copyWith =>
      __$$AuthDataModelImplCopyWithImpl<_$AuthDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthDataModelImplToJson(this);
  }
}

abstract class _AuthDataModel implements AuthDataModel {
  const factory _AuthDataModel({final List<UserModel> accounts}) =
      _$AuthDataModelImpl;

  factory _AuthDataModel.fromJson(Map<String, dynamic> json) =
      _$AuthDataModelImpl.fromJson;

  @override
  List<UserModel> get accounts;

  /// Create a copy of AuthDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthDataModelImplCopyWith<_$AuthDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

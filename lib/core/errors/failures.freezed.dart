// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
    _$ServerFailureImpl value,
    $Res Function(_$ServerFailureImpl) then,
  ) = __$$ServerFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
    _$ServerFailureImpl _value,
    $Res Function(_$ServerFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? statusCode = freezed}) {
    return _then(
      _$ServerFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        statusCode: freezed == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl({required this.message, this.statusCode});

  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'Failure.server(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return server(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return server?.call(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(message, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure({
    required final String message,
    final int? statusCode,
  }) = _$ServerFailureImpl;

  @override
  String get message;
  int? get statusCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({this.message = 'Pas de connexion internet'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({final String message}) = _$NetworkFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthFailureImplCopyWith(
    _$AuthFailureImpl value,
    $Res Function(_$AuthFailureImpl) then,
  ) = __$$AuthFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, bool isTokenExpired});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthFailureImpl>
    implements _$$AuthFailureImplCopyWith<$Res> {
  __$$AuthFailureImplCopyWithImpl(
    _$AuthFailureImpl _value,
    $Res Function(_$AuthFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isTokenExpired = null}) {
    return _then(
      _$AuthFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isTokenExpired: null == isTokenExpired
            ? _value.isTokenExpired
            : isTokenExpired // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthFailureImpl implements AuthFailure {
  const _$AuthFailureImpl({required this.message, this.isTokenExpired = false});

  @override
  final String message;
  @override
  @JsonKey()
  final bool isTokenExpired;

  @override
  String toString() {
    return 'Failure.auth(message: $message, isTokenExpired: $isTokenExpired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isTokenExpired, isTokenExpired) ||
                other.isTokenExpired == isTokenExpired));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isTokenExpired);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<_$AuthFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return auth(message, isTokenExpired);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return auth?.call(message, isTokenExpired);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message, isTokenExpired);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthFailure implements Failure {
  const factory AuthFailure({
    required final String message,
    final bool isTokenExpired,
  }) = _$AuthFailureImpl;

  @override
  String get message;
  bool get isTokenExpired;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CacheFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$CacheFailureImplCopyWith(
    _$CacheFailureImpl value,
    $Res Function(_$CacheFailureImpl) then,
  ) = __$$CacheFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CacheFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$CacheFailureImpl>
    implements _$$CacheFailureImplCopyWith<$Res> {
  __$$CacheFailureImplCopyWithImpl(
    _$CacheFailureImpl _value,
    $Res Function(_$CacheFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CacheFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CacheFailureImpl implements CacheFailure {
  const _$CacheFailureImpl({this.message = 'Erreur de cache'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'Failure.cache(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CacheFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      __$$CacheFailureImplCopyWithImpl<_$CacheFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return cache(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return cache?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return cache(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return cache?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (cache != null) {
      return cache(this);
    }
    return orElse();
  }
}

abstract class CacheFailure implements Failure {
  const factory CacheFailure({final String message}) = _$CacheFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CacheFailureImplCopyWith<_$CacheFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BiometricFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$BiometricFailureImplCopyWith(
    _$BiometricFailureImpl value,
    $Res Function(_$BiometricFailureImpl) then,
  ) = __$$BiometricFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, bool isNotAvailable, bool isNotEnrolled});
}

/// @nodoc
class __$$BiometricFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$BiometricFailureImpl>
    implements _$$BiometricFailureImplCopyWith<$Res> {
  __$$BiometricFailureImplCopyWithImpl(
    _$BiometricFailureImpl _value,
    $Res Function(_$BiometricFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isNotAvailable = null,
    Object? isNotEnrolled = null,
  }) {
    return _then(
      _$BiometricFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isNotAvailable: null == isNotAvailable
            ? _value.isNotAvailable
            : isNotAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isNotEnrolled: null == isNotEnrolled
            ? _value.isNotEnrolled
            : isNotEnrolled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BiometricFailureImpl implements BiometricFailure {
  const _$BiometricFailureImpl({
    required this.message,
    this.isNotAvailable = false,
    this.isNotEnrolled = false,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final bool isNotAvailable;
  @override
  @JsonKey()
  final bool isNotEnrolled;

  @override
  String toString() {
    return 'Failure.biometric(message: $message, isNotAvailable: $isNotAvailable, isNotEnrolled: $isNotEnrolled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isNotAvailable, isNotAvailable) ||
                other.isNotAvailable == isNotAvailable) &&
            (identical(other.isNotEnrolled, isNotEnrolled) ||
                other.isNotEnrolled == isNotEnrolled));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, isNotAvailable, isNotEnrolled);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricFailureImplCopyWith<_$BiometricFailureImpl> get copyWith =>
      __$$BiometricFailureImplCopyWithImpl<_$BiometricFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return biometric(message, isNotAvailable, isNotEnrolled);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return biometric?.call(message, isNotAvailable, isNotEnrolled);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (biometric != null) {
      return biometric(message, isNotAvailable, isNotEnrolled);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return biometric(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return biometric?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (biometric != null) {
      return biometric(this);
    }
    return orElse();
  }
}

abstract class BiometricFailure implements Failure {
  const factory BiometricFailure({
    required final String message,
    final bool isNotAvailable,
    final bool isNotEnrolled,
  }) = _$BiometricFailureImpl;

  @override
  String get message;
  bool get isNotAvailable;
  bool get isNotEnrolled;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiometricFailureImplCopyWith<_$BiometricFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(
    _$UnknownFailureImpl value,
    $Res Function(_$UnknownFailureImpl) then,
  ) = __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
    _$UnknownFailureImpl _value,
    $Res Function(_$UnknownFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? error = freezed}) {
    return _then(
      _$UnknownFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
      ),
    );
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({
    this.message = 'Une erreur inattendue est survenue',
    this.error,
  });

  @override
  @JsonKey()
  final String message;
  @override
  final Object? error;

  @override
  String toString() {
    return 'Failure.unknown(message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) server,
    required TResult Function(String message) network,
    required TResult Function(String message, bool isTokenExpired) auth,
    required TResult Function(String message) cache,
    required TResult Function(
      String message,
      bool isNotAvailable,
      bool isNotEnrolled,
    )
    biometric,
    required TResult Function(String message, Object? error) unknown,
  }) {
    return unknown(message, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? server,
    TResult? Function(String message)? network,
    TResult? Function(String message, bool isTokenExpired)? auth,
    TResult? Function(String message)? cache,
    TResult? Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult? Function(String message, Object? error)? unknown,
  }) {
    return unknown?.call(message, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? server,
    TResult Function(String message)? network,
    TResult Function(String message, bool isTokenExpired)? auth,
    TResult Function(String message)? cache,
    TResult Function(String message, bool isNotAvailable, bool isNotEnrolled)?
    biometric,
    TResult Function(String message, Object? error)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(CacheFailure value) cache,
    required TResult Function(BiometricFailure value) biometric,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(CacheFailure value)? cache,
    TResult? Function(BiometricFailure value)? biometric,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(CacheFailure value)? cache,
    TResult Function(BiometricFailure value)? biometric,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure({final String message, final Object? error}) =
      _$UnknownFailureImpl;

  @override
  String get message;
  Object? get error;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

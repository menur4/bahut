// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthResponseModelImpl(
  code: (json['code'] as num).toInt(),
  token: json['token'] as String? ?? '',
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthResponseModelImplToJson(
  _$AuthResponseModelImpl instance,
) => <String, dynamic>{
  'code': instance.code,
  'token': instance.token,
  'message': instance.message,
  'data': instance.data,
};

_$AuthDataModelImpl _$$AuthDataModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthDataModelImpl(
      accounts:
          (json['accounts'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AuthDataModelImplToJson(_$AuthDataModelImpl instance) =>
    <String, dynamic>{'accounts': instance.accounts};

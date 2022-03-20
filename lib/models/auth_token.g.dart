// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
    };

AuthTokenData _$AuthTokenDataFromJson(Map<String, dynamic> json) =>
    AuthTokenData(
      jti: json['jti'] as String,
      issuedAt: json['iat'] as int,
      notValidBefore: json['nfb'] as int,
      identity: json['identity'] as String,
      validUntil: json['exp'] as int,
    );

Map<String, dynamic> _$AuthTokenDataToJson(AuthTokenData instance) =>
    <String, dynamic>{
      'jti': instance.jti,
      'identity': instance.identity,
      'iat': instance.issuedAt,
      'nfb': instance.notValidBefore,
      'exp': instance.validUntil,
    };

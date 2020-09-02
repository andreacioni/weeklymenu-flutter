// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) {
  return AuthToken(
    accessToken: json['access_token'] as String,
  );
}

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
      'access_token': instance.accessToken,
    };

JWTToken _$JWTTokenFromJson(Map<String, dynamic> json) {
  return JWTToken(
    jti: json['jti'] as String,
    issuedAt: json['iat'] as int,
    notValidBefore: json['nfb'] as int,
    identity: json['identity'] as String,
    validUntil: json['exp'] as int,
  );
}

Map<String, dynamic> _$JWTTokenToJson(JWTToken instance) => <String, dynamic>{
      'jti': instance.jti,
      'identity': instance.identity,
      'iat': instance.issuedAt,
      'nfb': instance.notValidBefore,
      'exp': instance.validUntil,
    };

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/utils.dart' as utils;
part 'auth_token.g.dart';

@immutable
class AuthToken {
  final String _jwtString;
  final AuthTokenData _tokenData;

  AuthToken(this._jwtString, this._tokenData);

  factory AuthToken.fromJWT(String jwtString) {
    return AuthToken(
        jwtString, AuthTokenData.fromBase64Json(jwtString.split(".")[1]));
  }
  factory AuthToken.fromLoginResponse(LoginResponse loginResponse) {
    return AuthToken(loginResponse.accessToken,
        AuthTokenData.fromBase64Json(loginResponse.accessToken.split(".")[1]));
  }

  String get jwt => _jwtString;

  AuthTokenData get data => _tokenData;

  bool get isValid => _tokenData.isValid;
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  LoginResponse({
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class AuthTokenData {
  final String jti;

  final String identity;

  @JsonKey(name: 'iat')
  final int issuedAt;

  @JsonKey(name: 'nbf')
  final int notValidBefore;

  @JsonKey(name: 'exp')
  final int validUntil;

  AuthTokenData({
    required this.jti,
    required this.issuedAt,
    required this.notValidBefore,
    required this.identity,
    required this.validUntil,
  });

  factory AuthTokenData.fromBase64Json(String jwtBody) {
    final jsonString = utils.decodeBase64(jwtBody);
    final jsonMap = utils.jsonMapFromString(jsonString);

    final jwtToken = _$AuthTokenDataFromJson(jsonMap);

    return jwtToken;
  }

  Duration get duration {
    final d = DateTime.fromMillisecondsSinceEpoch(validUntil * 1000)
        .difference(DateTime.now().toUtc());

    if (d.isNegative) {
      return Duration.zero;
    }

    return d;
  }

  bool get isValid => duration > Duration.zero;
}

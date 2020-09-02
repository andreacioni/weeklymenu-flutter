import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/utils.dart' as utils;
part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken {
  @JsonKey(name: 'access_token')
  final String accessToken;

  AuthToken({
    this.accessToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}

@JsonSerializable()
class JWTToken {
  String _token;

  final String jti;

  final String identity;

  @JsonKey(name: 'iat')
  final int issuedAt;

  @JsonKey(name: 'nfb')
  final int notValidBefore;

  @JsonKey(name: 'exp')
  final int validUntil;

  JWTToken({
    this.jti,
    this.issuedAt,
    this.notValidBefore,
    this.identity,
    this.validUntil,
  });

  factory JWTToken.fromBase64Json(String token) {
    final jsonString = utils.decodeBase64(token);
    final jsonMap = utils.jsonMapFromString(jsonString);

    final jwtToken = _$JWTTokenFromJson(jsonMap);
    jwtToken._token = token;

    return jwtToken;
  }

  String get token => _token;

  bool isValid() {
    final unixNow = DateTime.now().toUtc().millisecondsSinceEpoch;

    return unixNow <= validUntil && unixNow >= notValidBefore;
  }
}

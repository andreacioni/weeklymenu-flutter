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
    final jsonString = utils.decodeBase64(token.split(".")[1]);
    final jsonMap = utils.jsonMapFromString(jsonString);

    final jwtToken = _$JWTTokenFromJson(jsonMap);
    jwtToken._token = token;

    return jwtToken;
  }

  String get toJwtString => _token;

  Duration get duration {
    final d = DateTime.fromMillisecondsSinceEpoch(validUntil * 1000)
        .difference(DateTime.now().toUtc());

    if (d.isNegative) {
      return Duration.zero;
    }

    return d;
  }

  bool isValid() => duration > Duration.zero;
}


import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AuthToken {
  
  @JsonKey(name: 'access_token')
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthToken({this.accessToken, this.refreshToken, this.expiresIn});

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}
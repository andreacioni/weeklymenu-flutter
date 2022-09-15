import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/auth_token.dart';
import 'auth_service.dart';
import 'local_preferences.dart';

class TokenService {
  final LocalPreferences _localPreferences;
  final AuthService _authService;

  TokenService(
      {required LocalPreferences localPreferences,
      required AuthService authService})
      : this._localPreferences = localPreferences,
        this._authService = authService;

  String? _email, _password;
  AuthToken? _token;

  Future<AuthToken?> get token async {
    try {
      await _loadUserInformation();
    } catch (e) {
      log("There was an error loading saved credentials: $e");
      throw e;
    }

    if (_token == null || !_token!.isValid) {
      log("Invalid cached token, getting new one...");

      try {
        await _tryLogin();
      } on DioError catch (e) {
        if (e.type == DioErrorType.response && e.response!.statusCode == 401) {
          log("Failed auto login with saved credentials, password changed. Login again...");
        } else {
          log("Unexpected failure while logging in: ${e.stackTrace}");
        }
      } catch (e) {
        log("Generic error raised while logging in: $e");
      }
    }

    return _token;
  }

  Future<void> _loadUserInformation() async {
    //Email & Password
    _email = _localPreferences.getString(LocalPreferenceKey.email);
    _password = _localPreferences.getString(LocalPreferenceKey.password);

    //Token
    final jwt = _localPreferences.getString(LocalPreferenceKey.token);
    _token = jwt != null ? AuthToken.fromJWT(jwt) : null;
  }

  Future<void> _tryLogin() async {
    if (_password != null && _email != null) {
      _token = await _authService.login(_email!, _password!);
    } else {
      log("email & password are null");
    }
  }
}
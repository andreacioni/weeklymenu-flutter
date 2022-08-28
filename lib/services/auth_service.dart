import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

import '../globals/constants.dart';
import '../models/auth_token.dart';

@CopyWith()
class AuthState {
  final loggingIn;
  final loggedIn;

  AuthState({this.loggingIn, this.loggedIn});
}

class AuthService {
  static const BASE_URL = 'https://heroku-weeklymenu.herokuapp.com/api/v1';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  );

  final LocalPreferences _localPreferences;

  late final StreamController<AuthState> _

  AuthToken? _token;

  String? _email, _password;

  bool _initialized;

  AuthService(LocalPreferences localPreferences) : _initialized = false, this._localPreferences = localPreferences;

  Future<void> register(String name, String email, String password) async {
    await _dio.post('$BASE_URL/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return;
  }

  Future<void> login(String email, String password) async {
    final authResp = await _dio.post('$BASE_URL/auth/token',
        data: {'email': email, 'password': password});

    final loginResponse = LoginResponse.fromJson(authResp.data);
    _token = AuthToken.fromLoginResponse(loginResponse);

    await _storeUserInformation(email, password, _token!);
  }

  Future<void> logout() async {
    await _dio.post('$BASE_URL/auth/logout');
    await _clearUserInformation();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('$BASE_URL/auth/reset_password', data: {'email': email});
    await _clearUserInformation();
  }

  Stream<AuthState> get authenticationStream async* {}

  Future<void> _storeUserInformation(
      String email, String password, AuthToken token) async {
    //Email & Password
    _email = email;
    _password = password;
    await _localPreferences.setString(LocalPreferenceKey.email, email);
    await _localPreferences.setString(LocalPreferenceKey.password, password);

    //Token
    _token = token;
    await _localPreferences.setString(LocalPreferenceKey.token, _token!.jwt);
  }

  Future<void> _loadUserInformation() async {
    //Email & Password
    _email = _localPreferences.getString(LocalPreferenceKey.email);
    _password = _localPreferences.getString(LocalPreferenceKey.password);

    //Token
    final jwt = _localPreferences.getString(LocalPreferenceKey.token);
    _token = jwt != null ? AuthToken.fromJWT(jwt) : null;
  }

  Future<void> _clearUserInformation() async {
    //Email & Password
    _email = null;
    _password = null;
    await _localPreferences.remove(LocalPreferenceKey.email);
    await _localPreferences.remove(LocalPreferenceKey.password);

    //Token
    _token = null;
    await _localPreference.remove(LocalPreferenceKey.token);
  }

  Future<AuthToken?> get token async {
    if (!_initialized) {
      print("Auth service not yet initialized");
      try {
        await _loadUserInformation();
        _initialized = true;
      } catch (e) {
        print("There was an error loading saved credentials");
        throw e;
      }
    }

    if (_token == null || !_token!.isValid) {
      print("Invalid cached token, getting new one...");

      try {
        await _tryLogin();
      } on DioError catch (e) {
        if (e.type == DioErrorType.response && e.response!.statusCode == 401) {
          print(
              "Failed auto login with saved credentials, password changed. Login again...");
        } else {
          print("Unexpected failure while logging in\n${e.stackTrace}");
        }
      } catch (e) {
        print("Generic error raised while logging in\n$e");
      }
    }

    return _token;
  }

  Future<void> _tryLogin() async {
    if (_password != null && _email != null) {
      await login(_email!, _password!);
    } else {
      print("email & password are null");
    }
  }
}

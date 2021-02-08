import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/constants.dart';
import '../models/auth_token.dart';

class AuthService {
  static final _log = Logger();

  static final String BASE_URL =
      'https://heroku-weeklymenu.herokuapp.com/api/v1';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  );

  static final AuthService _singleton = AuthService._internal();

  factory AuthService.getInstance() => _singleton;

  JWTToken _token;

  String _email, _password;

  bool _initialized;

  AuthService._internal() {
    _initialized = false;
  }

  Future<void> register(String name, String email, String password) async {
    await _dio.post('$BASE_URL/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return;
  }

  Future<JWTToken> login(String email, String password) async {
    var authResp = await _dio.post('$BASE_URL/auth/token',
        data: {'email': email, 'password': password});

    await _storeUserInformation(
        email, password, AuthToken.fromJson(authResp.data).accessToken);

    return _token;
  }

  Future<void> logout() async {
    await _dio.post('$BASE_URL/auth/logout');
    await _clearUserInformation();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('$BASE_URL/auth/reset_password', data: {'email': email});
    await _clearUserInformation();
  }

  Future<void> _storeUserInformation(
      String email, String password, String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = email;
    _password = password;
    await sharedPreferences.setString(
        SharedPreferencesKeys.emailSharedPreferencesKey, _email);
    await sharedPreferences.setString(
        SharedPreferencesKeys.passwordSharedPreferencesKey, _password);

    //Token
    _token = JWTToken.fromBase64Json(token);
    await sharedPreferences.setString(
        SharedPreferencesKeys.tokenSharedPreferencesKey, _token.toJwtString);
  }

  Future<void> _loadUserInformation() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = sharedPreferences
        .getString(SharedPreferencesKeys.emailSharedPreferencesKey);
    _password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);

    //Token
    _token = JWTToken.fromBase64Json(sharedPreferences
        .getString(SharedPreferencesKeys.tokenSharedPreferencesKey));
  }

  Future<void> _clearUserInformation() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = null;
    _password = null;
    await sharedPreferences
        .remove(SharedPreferencesKeys.emailSharedPreferencesKey);
    await sharedPreferences
        .remove(SharedPreferencesKeys.passwordSharedPreferencesKey);

    //Token
    _token = null;
    await sharedPreferences
        .remove(SharedPreferencesKeys.tokenSharedPreferencesKey);
  }

  Future<JWTToken> get token async {
    if (!_initialized) {
      _log.i("Auth service not yet initialized");
      try {
        await _loadUserInformation();
        _initialized = true;
      } catch (e) {
        _log.e("There was an error loading saved credentials");
        throw e;
      }
    }

    if (_token == null || !_token.isValid()) {
      _log.i("Invalid cached token, getting new one...");

      try {
        await _tryLogin();
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 401) {
          _log.i(
              "Failed auto login with saved credentials, password changed. Login again...");
        } else {
          _log.e("Unexpented failure while logging in", e);
        }
      } catch (e) {
        _log.e("Generic error raised while logging in", e);
      }
    }

    return _token;
  }

  Future<void> _tryLogin() async {
    if (_password != null && _email != null) {
      return await login(_email, _password);
    }
  }
}

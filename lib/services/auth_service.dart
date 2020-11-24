import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    ),
  );

  static final AuthService _singleton = AuthService._internal();

  factory AuthService.getInstance() => _singleton;

  JWTToken _token;

  String _email, _password;

  bool _initialized;

  AuthService._internal();

  Future<void> register(String name, String email, String password) async {
    await _dio.post('$BASE_URL/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return;
  }

  Future<JWTToken> login(String email, String password) async {
    var authResp = await _dio.post('$BASE_URL/auth/token',
        data: {'email': email, 'password': password});

    _storeUserInformation(
        email, password, AuthToken.fromJson(authResp.data).accessToken);

    return _token;
  }

  Future<void> logout() async {
    await _dio.post('$BASE_URL/auth/logout');
    _clearUserInformation();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('$BASE_URL/auth/reset_password', data: {'email': email});
    _clearUserInformation();
  }

  Future<void> _storeUserInformation(
      String email, String password, String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = email;
    _password = password;
    sharedPreferences.setString(
        SharedPreferencesKeys.emailSharedPreferencesKey, _email);
    sharedPreferences.setString(
        SharedPreferencesKeys.passwordSharedPreferencesKey, _password);

    //Token
    _token = JWTToken.fromBase64Json(token);
    sharedPreferences.setString(
        SharedPreferencesKeys.tokenSharedPreferencesKey, _token.toJwtString);
  }

  Future<void> _loadUserInformation() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = sharedPreferences
        .getString(SharedPreferencesKeys.emailSharedPreferencesKey);
    _password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);
    ;

    //Token
    _token = JWTToken.fromBase64Json(sharedPreferences
        .getString(SharedPreferencesKeys.tokenSharedPreferencesKey));
  }

  Future<void> _clearUserInformation() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = null;
    _password = null;
    sharedPreferences.remove(SharedPreferencesKeys.emailSharedPreferencesKey);
    sharedPreferences
        .remove(SharedPreferencesKeys.passwordSharedPreferencesKey);

    //Token
    _token = null;
    sharedPreferences.remove(SharedPreferencesKeys.tokenSharedPreferencesKey);
  }

  Future<JWTToken> get token => _tryLogin();

  Future<JWTToken> _tryLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!_initialized) {
      _log.i("Auth service not yet initialized");
      await _loadUserInformation();
      _initialized = true;
    }

    if (_token != null && _token.isValid()) {
      return _token;
    }

    JWTToken tempToken;
    _log.i("Invalid cached token, getting new one...");

    try {
      if ((tempToken = await _tryUseCredentials(sharedPreferences)) != null) {
        _token = tempToken;
        return tempToken;
      } else {
        _log.e("Can't login with saved credentials");
      }
    } catch (e) {
      _log.w("Invalid credentials saved in shared preference", e);
    }

    return null;
  }

  Future<JWTToken> _tryUseCredentials(
      SharedPreferences sharedPreferences) async {
    final username = sharedPreferences
        .getString(SharedPreferencesKeys.emailSharedPreferencesKey);
    final password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);

    if (password != null && username != null) {
      return await login(username, password);
    }

    return null;
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/http.dart';
import '../globals/shared_preferences.dart';
import '../models/auth_token.dart';

final authServiceProvider =
    Provider((ref) => AuthService(ref.read(dioProvider)));

class AuthService {
  static final _log = Logger();

  AuthToken? _token;

  String? _email, _password;

  bool _initialized;

  final Dio _dio;

  AuthService(this._dio) : _initialized = false;

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

  Future<void> _storeUserInformation(
      String email, String password, AuthToken token) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = email;
    _password = password;
    await sharedPreferences.setString(
        SharedPreferencesKeys.emailSharedPreferencesKey, email);
    await sharedPreferences.setString(
        SharedPreferencesKeys.passwordSharedPreferencesKey, password);

    //Token
    _token = token;
    await sharedPreferences.setString(
        SharedPreferencesKeys.tokenSharedPreferencesKey, _token!.jwt);
  }

  Future<void> _loadUserInformation() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    //Email & Password
    _email = sharedPreferences
        .getString(SharedPreferencesKeys.emailSharedPreferencesKey);
    _password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);

    //Token
    final jwt = sharedPreferences
        .getString(SharedPreferencesKeys.tokenSharedPreferencesKey);
    _token = jwt != null ? AuthToken.fromJWT(jwt) : null;
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

  Future<AuthToken?> get token async {
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

    if (_token == null || !_token!.isValid) {
      _log.i("Invalid cached token, getting new one...");

      try {
        await _tryLogin();
      } on DioError catch (e) {
        if (e.type == DioErrorType.response && e.response!.statusCode == 401) {
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
      await login(_email!, _password!);
    } else {
      _log.w("email & password are null");
    }
  }
}

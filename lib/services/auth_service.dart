import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/constants.dart';
import '../models/auth_token.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  static final String BASE_URL =
      'https://weeklymenu.fly.dev/api/v1';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  );

  AuthToken? _token;

  String? _email, _password;

  bool _initialized;

  AuthService() : _initialized = false;

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
          print("Unexpented failure while logging in\n${e.stackTrace}");
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

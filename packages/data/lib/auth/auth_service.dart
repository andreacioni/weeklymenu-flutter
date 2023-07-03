import 'dart:async';
import 'dart:developer';

import 'package:common/constants.dart';
import 'package:data/auth/token_service.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/auth_token.dart';

import '../configuration/local_preferences.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final tokenServiceProvider = Provider<TokenService>((ref) {
  final localPreferences = ref.read(localPreferencesProvider);
  final authService = ref.read(authServiceProvider);
  return TokenService(
      localPreferences: localPreferences, authService: authService);
});

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: API_BASE_PATH,
      contentType: 'application/json',
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  );

  Future<void> register(String name, String email, String password) async {
    await _dio.post('$API_BASE_PATH/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return;
  }

  Future<AuthToken> login(String email, String password) async {
    try {
      final authResp = await _dio.post('$API_BASE_PATH/auth/token',
          data: {'email': email, 'password': password});

      final loginResponse = LoginResponse.fromJson(authResp.data);
      final token = AuthToken.fromLoginResponse(loginResponse);

      return token;
    } catch (e) {
      log('user $email failed to login: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    await _dio.post('$API_BASE_PATH/auth/logout');
  }

  Future<void> resetPassword(String email) async {
    await _dio
        .post('$API_BASE_PATH/auth/reset_password', data: {'email': email});
  }
}
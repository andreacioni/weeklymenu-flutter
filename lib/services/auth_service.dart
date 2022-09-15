import 'dart:async';
import 'dart:developer';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/services/local_preferences.dart';

import '../globals/constants.dart';
import '../models/auth_token.dart';

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
    final authResp = await _dio.post('$API_BASE_PATH/auth/token',
        data: {'email': email, 'password': password});

    final loginResponse = LoginResponse.fromJson(authResp.data);
    final token = AuthToken.fromLoginResponse(loginResponse);

    return token;
  }

  Future<void> logout() async {
    await _dio.post('$API_BASE_PATH/auth/logout');
  }

  Future<void> resetPassword(String email) async {
    await _dio
        .post('$API_BASE_PATH/auth/reset_password', data: {'email': email});
  }
}

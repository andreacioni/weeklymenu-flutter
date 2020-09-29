import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:weekly_menu_app/datastore/hive_datasource.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/datastore/abstract_datastore.dart';

import 'package:weekly_menu_app/globals/constants.dart' as consts;

class AuthProvider {
  final _log = Logger();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: consts.BASE_URL,
      contentType: 'application/json',
    ),
  );

  Timer _expiryTokenTimer;

  String email, password;

  @override
  Future<void> register(String name, email, password) async {
    var resp = await _dio.post('/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return resp.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var resp = await _dio
        .post('/auth/token', data: {'email': email, 'password': password});

    this.email = email;
    this.password = password;

    return resp.data;
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
    _clearToken();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('/auth/reset_password', data: {'email': email});
  }

  Future<void> updateToken(JWTToken jwt) async {
    _cancelTimer();

    _expiryTokenTimer = Timer(jwt.duration, () {
      _clearToken();
    });

    _dio.options.headers['Authorization'] = "Bearer ${jwt.toJwtString}";
  }

  void _clearToken() {
    _dio.options.headers['Authorization'] = '';
    _cancelTimer();
  }

  void _cancelTimer() {
    if (_expiryTokenTimer != null) {
      _expiryTokenTimer.cancel();
      _expiryTokenTimer = null;
    }
  }

  void _handleErrorResponse(DioError e) {
    if (e.response.statusCode == 401) {
      _log.e("Token is no more valid. Try to login again...");
      //TODO login(email, password);
    }
  }
}

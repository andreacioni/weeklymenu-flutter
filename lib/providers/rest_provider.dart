import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:weekly_menu_app/models/auth_token.dart';

class RestProvider with ChangeNotifier {
  final _log = Logger();

  static final String BASE_URL =
      'https://heroku-weeklymenu.herokuapp.com/api/v1';

  static final BASE_HEADERS = <String, dynamic>{};

  static final BASE_PARAMS = {
    'per_page': 1000, //TODO handle pagination
  };

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      headers: BASE_HEADERS,
      queryParameters: BASE_PARAMS,
    ),
  );

  Timer _expiryTokenTimer;

  String email, password;

  RestProvider() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e) {
        switch (e.type) {
          case DioErrorType.RESPONSE:
            _handleErrorResponse(e);
            break;
          case DioErrorType.CONNECT_TIMEOUT:
          case DioErrorType.SEND_TIMEOUT:
          case DioErrorType.RECEIVE_TIMEOUT:
          case DioErrorType.CANCEL:
          case DioErrorType.DEFAULT:
            break;
        }
      },
    ));
  }

  Future<void> register(String name, email, password) async {
    var resp = await _dio.post('$BASE_URL/auth/register',
        data: {'name': name, 'email': email, 'password': password});

    return resp.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var resp = await _dio.post('$BASE_URL/auth/token',
        data: {'email': email, 'password': password});

    this.email = email;
    this.password = password;

    return resp.data;
  }

  Future<void> logout() async {
    await _dio.post('$BASE_URL/auth/logout');
    _clearToken();
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('$BASE_URL/auth/reset_password', data: {'email': email});
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

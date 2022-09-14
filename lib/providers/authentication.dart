import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/providers/local_preferences.dart';

import '../models/auth_token.dart';
import '../services/auth_service.dart';
import '../services/local_preferences.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final tokenProvider = FutureProvider<AuthToken?>((ref) async {
  final localPreferences = ref.read(localPreferencesProvider).value!;
  final authService = ref.read(authServiceProvider);

  String? _email, _password;
  AuthToken? _token;

  Future<void> _loadUserInformation() async {
    //Email & Password
    _email = localPreferences.getString(LocalPreferenceKey.email);
    _password = localPreferences.getString(LocalPreferenceKey.password);

    //Token
    final jwt = localPreferences.getString(LocalPreferenceKey.token);
    _token = jwt != null ? AuthToken.fromJWT(jwt) : null;
  }

  Future<void> _tryLogin() async {
    if (_password != null && _email != null) {
      _token = await authService.login(_email!, _password!);
    } else {
      log("email & password are null");
    }
  }

  try {
    await _loadUserInformation();
  } catch (e) {
    log("There was an error loading saved credentials");
    throw e;
  }

  if (_token == null || !_token!.isValid) {
    log("Invalid cached token, getting new one...");

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
});

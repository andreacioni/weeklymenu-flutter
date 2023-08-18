import 'dart:async';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localPreferencesFutureProvider = FutureProvider<LocalPreferences>(
    (_) async => await LocalPreferences.getInstance());

final localPreferencesProvider = Provider<LocalPreferences>((ref) {
  return ref.watch(localPreferencesFutureProvider).when(
      data: (localPreferences) => localPreferences,
      error: (_, __) =>
          throw StateError('dependency not initialized in bootsrap phase?'),
      loading: () =>
          throw StateError('dependency not initialized in bootsrap phase?'));
});

class LocalPreferenceKey {
  static final String token = "token";
  static final String email = "username";
  static final String password = "password";

  static final String firstShoppingListId = "first_shopping_list_id";
}

class LocalPreferences {
  static final LocalPreferences _instance = LocalPreferences();
  static late final SharedPreferences _sharedPreferences;
  static late final EncryptedSharedPreferences _encryptedSharedPreferences;

  static Future<LocalPreferences> getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _encryptedSharedPreferences =
        EncryptedSharedPreferences(prefs: _sharedPreferences);
    return _instance;
  }

  Future<bool> remove(String key) async {
    var b = false;

    b |= await _sharedPreferences.remove(key);
    b |= await _encryptedSharedPreferences.remove(key);

    return b;
  }

  Future<bool> clear() async {
    var b = true;

    b &= await _sharedPreferences.clear();
    b &= await _encryptedSharedPreferences.clear();

    _sharedPreferences.reload();
    _encryptedSharedPreferences.reload();

    return b;
  }

  Future<String?> getString(String key) async {
    String? res;

    try {
      res = await _encryptedSharedPreferences.getString(key);
    } on TypeError {
      //not found on encrypted values
    }

    if (res?.isEmpty ?? true) {
      res = _sharedPreferences.getString(key);
    }

    return res;
  }

  Future<bool> setString(String key, String value, {secret: false}) {
    if (!secret) {
      return _sharedPreferences.setString(key, value);
    } else {
      return _encryptedSharedPreferences.setString(key, value);
    }
  }
}

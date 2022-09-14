import 'package:flutter_data/flutter_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferenceKey {
  static final String token = "token";
  static final String email = "username";
  static final String password = "password";

  static final String firstShoppingListId = "first_shopping_list_id";
}

class LocalPreferences {
  static final LocalPreferences _instance = LocalPreferences();
  static late final SharedPreferences _sharedPreferences;

  static Future<LocalPreferences> getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _instance;
  }

  Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  Future<bool> clear() {
    return _sharedPreferences.clear();
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }
}

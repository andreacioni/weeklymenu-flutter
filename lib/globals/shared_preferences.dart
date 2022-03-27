import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferenceProvider =
    FutureProvider((ref) async => await SharedPreferences.getInstance());

class SharedPreferencesKeys {
  static final String tokenSharedPreferencesKey = "token";
  static final String emailSharedPreferencesKey = "username";
  static final String passwordSharedPreferencesKey = "password";

  static final String lastSuccessfulShoppingListSync =
      "lastSuccessfulShoppingListSync";
}

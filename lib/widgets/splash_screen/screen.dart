import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/homepage.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/providers/rest_provider.dart';
import 'package:weekly_menu_app/widgets/login_screen/screen.dart';
import 'package:weekly_menu_app/globals/constants.dart';

class SplashScreen extends StatelessWidget {
  final log = Logger();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => tryLogin(context));

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LoginScreen.backgroudContainer,
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void tryLogin(BuildContext context) async {
    JWTToken jwt;
    final restProvider = Provider.of<RestProvider>(context, listen: false);
    final sharedPreferences = await SharedPreferences.getInstance();

    try {
      if ((jwt = tryUseOldToken(sharedPreferences)) != null) {
        restProvider.initWithToken(jwt);
        goToHomepage(context);
        return;
      } else {
        log.e("Can't login with previous token");
      }
    } catch (e) {
      log.w("Invalid token saved in shared preference", e);
    }

    try {
      if ((jwt = await tryUseCredentials(restProvider, sharedPreferences)) !=
          null) {
        restProvider.initWithToken(jwt);
        goToHomepage(context);
        return;
      } else {
        log.e("Can't login with saved credentials");
      }
    } catch (e) {
      log.w("Invalid credentials saved in shared preference", e);
    }

    goToLogin(context);
  }

  JWTToken tryUseOldToken(SharedPreferences sharedPreferences) {
    final token = sharedPreferences
        .getString(SharedPreferencesKeys.tokenSharedPreferencesKey);

    if (token != null) {
      JWTToken jwt = JWTToken.fromBase64Json(token);

      if (!jwt.isValid()) {
        log.w("Old token is not valid anymore");
        return null;
      }

      return jwt;
    } else {
      log.i("No token saved previusly");
    }

    return null;
  }

  Future<JWTToken> tryUseCredentials(
      RestProvider restProvider, SharedPreferences sharedPreferences) async {
    final username = sharedPreferences
        .getString(SharedPreferencesKeys.usernameSharedPreferencesKey);
    final password = sharedPreferences
        .getString(SharedPreferencesKeys.passwordSharedPreferencesKey);

    if (password != null && username != null) {
      final authReponse = await restProvider.login(username, password);
      return JWTToken.fromBase64Json(
          AuthToken.fromJson(authReponse).accessToken);
    }

    return null;
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  void goToHomepage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
  }
}

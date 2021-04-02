import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import '../../main.data.dart';
import '../../services/auth_service.dart';
import '../login_screen/screen.dart';

import '../../homepage.dart';
import '../../main.data.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService.getInstance();
    return Scaffold(body: Center(
      child: Consumer(builder: (context, read, child) {
        return read(repositoryInitializerProvider()).when(
            data: (_) {
              return FutureBuilder<JWTToken>(
                future: authService.token,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      Future.delayed(
                          Duration.zero, () => goToHomePage(context));
                    } else {
                      Future.delayed(
                          Duration.zero, () => goToLoginPage(context));
                    }
                  }

                  return loadingIndicator();
                },
              );
            },
            loading: loadingIndicator,
            error: (_, __) => Text('error'));
      }),
    ));
  }

  Widget loadingIndicator() => Center(
        child: CircularProgressIndicator(),
      );

  static void goToHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

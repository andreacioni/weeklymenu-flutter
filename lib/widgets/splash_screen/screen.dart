import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:provider/provider.dart';

import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import '../../services/auth_service.dart';
import '../login_screen/screen.dart';

import '../../homepage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService.getInstance();
    final someRepo = context.watch<Repository<Ingredient>>();
    return Scaffold(
      body: someRepo == null
          ? loadingIndicator()
          : FutureBuilder<JWTToken>(
              future: authService.token,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    Future.delayed(Duration.zero, () => goToHomePage(context));
                  } else {
                    Future.delayed(Duration.zero, () => goToLoginPage(context));
                  }
                }

                return loadingIndicator();
              },
            ),
    );
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

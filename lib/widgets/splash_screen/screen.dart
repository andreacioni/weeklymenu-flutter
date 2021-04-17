import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weekly_menu_app/providers/providers.dart';
import '../../main.data.dart';
import '../login_screen/screen.dart';

import '../../homepage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Consumer(builder: (context, read, child) {
        return read(repositoryInitializerProvider()).when(
            data: (_) {
              return context.read(jwtTokenProvider).when(
                    data: (jwt) {
                      if (jwt != null) {
                        Future.delayed(
                            Duration.zero, () => goToHomePage(context));
                      } else {
                        Future.delayed(
                            Duration.zero, () => goToLoginPage(context));
                      }

                      return loadingIndicator();
                    },
                    loading: () => loadingIndicator(),
                    error: (_, __) => Text('error'),
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

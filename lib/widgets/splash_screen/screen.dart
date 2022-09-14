import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/providers/authentication.dart';

import '../../providers/bootstrap.dart';
import '../login_screen/screen.dart';
import '../../homepage.dart';

class SplashScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ref.watch(bootstrapDependenciesProvider).when(
              data: (_) {
                return ref.watch(tokenProvider).when(
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
                    error: (_, __) => Text('error') //TODO,
                    );
              },
              loading: loadingIndicator,
              error: (_, __) => Text('error'), //TODO
            ),
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

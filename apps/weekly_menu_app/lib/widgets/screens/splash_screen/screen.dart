import 'package:data/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/auth_token.dart';
import 'package:common/log.dart';

import '../../../providers/bootstrap.dart';
import '../../screens/login_screen/screen.dart';
import '../homepage/homepage.dart';

final _authTokenProvider = FutureProvider.autoDispose<AuthToken?>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return tokenService.token;
});

class SplashScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ref.watch(bootstrapDependenciesProvider).when(
              data: (_) {
                return ref.watch(_authTokenProvider).when(
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
              error: (ex, st) {
                logError("failed to bootstrap", ex, st);
                return Text('error'); //TODO
              },
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

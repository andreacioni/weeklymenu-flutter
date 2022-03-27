import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/models/menu.dart';
import 'package:weekly_menu_app/models/recipe.dart';
import 'package:weekly_menu_app/widgets/shopping_list_screen/screen.dart';

import '../../models/ingredient.dart';
import '../../services/auth_service.dart';
import '../../main.data.dart';
import '../login_screen/screen.dart';
import '../../homepage.dart';

final _tokenProvider = FutureProvider.autoDispose<AuthToken?>((ref) async {
  return ref.read(authServiceProvider).token;
});

class SplashScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(
      child: ref.watch(repositoryInitializerProvider()).when(
          data: (_) {
            return ref.watch(_tokenProvider).when(
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
          error: (_, __) => Text('error')),
    ));
  }

  Widget loadingIndicator() => Center(
        child: CircularProgressIndicator(),
      );

  static void goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ShoppingListScreen()));
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

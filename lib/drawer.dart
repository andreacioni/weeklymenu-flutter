import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/main.data.dart';
import 'package:weekly_menu_app/providers/local_preferences.dart';

import 'providers/authentication.dart';
import 'providers/bootstrap.dart';
import 'widgets/tags_screen/screen.dart';
import './widgets/ingredients_screen/screen.dart';
import 'widgets/login_screen/screen.dart';

class AppDrawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logoutAndClearUserData() async {
      log('logging out...');
      final authService = ref.read(authServiceProvider);
      final localPreferences = ref.read(localPreferencesProvider);
      final repositoriesProviders = repositoryProviders.values;

      await authService.logout();
      await localPreferences.clear();

      for (final repositoryProvider in repositoriesProviders) {
        await ref.read(repositoryProvider).clear();
      }

      log('user data deleted');
    }

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Andrea Cioni'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Ingredients'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => IngredientsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Tags'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TagsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Q&A'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Info'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              logoutAndClearUserData();
              Navigator.pop(context);
              goToLogin(context);
            },
          ),
          ListTile(
            title: Text(
              'v.1.0.0',
              style: TextStyle(color: Colors.black38),
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

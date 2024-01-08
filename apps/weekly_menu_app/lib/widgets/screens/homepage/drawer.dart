import 'dart:developer';

import 'package:data/auth/auth_service.dart';
import 'package:data/configuration/local_preferences.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../ingredients_screen/screen.dart';
import '../login_screen/screen.dart';
import '../tags_screen/screen.dart';
import 'notifier.dart';

class AppDrawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homepageScreenNotifierProvider.notifier);

    Future<void> logoutAndClearUserData() async {
      log('logging out...');
      final authService = ref.read(authServiceProvider);
      final localPreferences = ref.read(localPreferencesProvider);
      final repositoriesProviders = ref.read(repositoryProviders);

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
            leading: Icon(Icons.kitchen),
            title: Text('Pantry'),
            onTap: () {
              Navigator.pop(context);
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
            leading: Icon(Icons.search),
            title: Text('More recipes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TagsScreen()));
            },
          ),
          Divider(),
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
              notifier.setLoading(true);
              await logoutAndClearUserData();
              notifier.setLoading(false);
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

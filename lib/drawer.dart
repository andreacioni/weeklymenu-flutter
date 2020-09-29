import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/providers/auth_provider.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/widgets/splash_screen/screen.dart';

import './widgets/ingredients_screen/screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              final sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences
                  .remove(SharedPreferencesKeys.tokenSharedPreferencesKey);
              sharedPreferences
                  .remove(SharedPreferencesKeys.emailSharedPreferencesKey);
              sharedPreferences
                  .remove(SharedPreferencesKeys.passwordSharedPreferencesKey);
              Provider.of<RestProvider>(context, listen: false).logout();
              Navigator.pop(context);
              SplashScreen.goToLogin(context);
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
}

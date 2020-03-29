import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/recipes_provider.dart';
import './providers/menus_provider.dart';
import './providers/ingredients_provider.dart';
import './homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MenusProvider()),
        ChangeNotifierProvider.value(value: RecipesProvider()),
        ChangeNotifierProvider.value(value: IngredientsProvider()),
        //Cart provider
      ],
      child: MaterialApp(
        title: 'Weekly Menu',
        home: HomePage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.amber,
          accentColor: Colors.amber,

          // Define the default font family.
          fontFamily: 'Aerial',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
      ),
    );
  }
}
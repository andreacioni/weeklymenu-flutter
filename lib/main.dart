import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/recipes_provider.dart';
import './providers/menus_provider.dart';
import './providers/ingredients_provider.dart';
import './providers/shopping_list_provider.dart';
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
        ChangeNotifierProvider.value(value: ShoppingListProvider()),
      ],
      child: MaterialApp(
        title: 'Weekly Menu',
        home: HomePage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.amber.shade300,
          accentColor: Colors.amberAccent,
          splashColor: Colors.amberAccent,
          scaffoldBackgroundColor: Colors.white,
          // Define the default font family.
          fontFamily: 'Rubik',

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.amber.shade300
          ),

          appBarTheme: AppBarTheme(color: Colors.amber.shade300),

          //AppBarTheme
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.white,
          ),

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),

          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(fontWeight: FontWeight.normal),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

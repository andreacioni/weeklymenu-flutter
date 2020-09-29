import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/widgets/login_screen/screen.dart';
import 'package:weekly_menu_app/widgets/splash_screen/screen.dart';

import 'providers/auth_provider.dart';
import './providers/recipes_provider.dart';
import './providers/menus_provider.dart';
import './providers/ingredients_provider.dart';
import './providers/shopping_list_provider.dart';
import './homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthProvider initialRestProvider = AuthProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: initialRestProvider),
        ChangeNotifierProxyProvider<RestProvider, IngredientsProvider>(
          create: (_) =>
              IngredientsProvider(initialRestProvider), //It depends on auth
          update: (_, restProvider, ingredientsProvider) =>
              ingredientsProvider..update(restProvider),
        ),
        ChangeNotifierProxyProvider2<RestProvider, IngredientsProvider,
            ShoppingListProvider>(
          create: (_) => ShoppingListProvider(
              initialRestProvider), //It depends on ingredients & auth
          update: (_, restProvider, ingredientsProvider,
                  shoppingListProvider) =>
              shoppingListProvider..update(restProvider, ingredientsProvider),
        ),
        ChangeNotifierProxyProvider2<RestProvider, IngredientsProvider,
            RecipesProvider>(
          create: (_) => RecipesProvider(
              initialRestProvider), //It depends on ingredients & auth
          update: (_, restProvider, ingredientsProvider, recipesProvider) =>
              recipesProvider..update(restProvider, ingredientsProvider),
        ),
        ChangeNotifierProxyProvider2<RestProvider, RecipesProvider,
            MenusProvider>(
          create: (_) => MenusProvider(
              initialRestProvider), //It depends on ingredients & auth
          update: (_, restProvider, recipesProvider, menusProvider) =>
              menusProvider..update(restProvider, recipesProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Weekly Menu',
        home: SplashScreen(), //LoginScreen(), //HomePage(),
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
              backgroundColor: Colors.amber.shade300),

          appBarTheme: AppBarTheme(color: Colors.amber.shade300),

          //AppBarTheme
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.white,
          ),

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            //subtitle1: TextStyle(fontSize: 15, fontFamily: 'Hind', color: Colors.amber)
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

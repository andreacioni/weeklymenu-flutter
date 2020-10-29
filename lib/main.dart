import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/models/app_state.dart';

import 'package:weekly_menu_app/reducers/app_state_reducer.dart';
import 'package:weekly_menu_app/widgets/splash_screen/screen.dart';

void main() async {
  final persistor = Persistor<AppState>(
    storage: FileStorage(File("state.json")),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  // Load initial state
  final initialState = await persistor.load();

  runApp(
    App(
      store: Store<AppState>(
        appReducer,
        initialState: initialState,
        middleware: [persistor.createMiddleware()],
      ),
    ),
  );
}

class App extends StatelessWidget {
  final Store<AppState> store;

  App({@required this.store});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

        //Used by native date picker (see: https://github.com/flutter/flutter/issues/58254)
        colorScheme: ColorScheme.light(
          primary: Colors.amber,
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
    );
  }
}

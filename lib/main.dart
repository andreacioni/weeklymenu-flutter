import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/widgets/recipes_screen/screen.dart';

import './homepage.dart';
import 'main.data.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...repositoryProviders(clear: false, verbose: true),
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
      ),
    );
  }
}

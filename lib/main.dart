import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/splash_screen/screen.dart';
import 'main.data.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        configureRepositoryLocalStorage(clear: false),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weekly Menu',
        home: SplashScreen(),
        theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Colors.amber.shade300,
            splashColor: Colors.amberAccent,
            highlightColor: Colors.amberAccent.withOpacity(0.3),
            scaffoldBackgroundColor: Colors.white,

            // Define the default font family.
            fontFamily: 'Rubik',
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.amber.shade300),
            appBarTheme: AppBarTheme(
                color: Colors.amber.shade300,
                titleTextStyle:
                    GoogleFonts.rubik(fontSize: 20, color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black)),

            //AppBarTheme
            bottomAppBarTheme: BottomAppBarTheme(
              color: Colors.white,
            ),
            listTileTheme: ListTileThemeData(
                selectedTileColor: Colors.amber.withOpacity(0.2)),

            //Used by native date picker (see: https://github.com/flutter/flutter/issues/58254)
            colorScheme: ColorScheme.light(
                primary: Colors.amber, secondary: Colors.amberAccent),

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              //subtitle1: TextStyle(fontSize: 15, fontFamily: 'Hind', color: Colors.amber)
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? Colors.amber
                      : null),
            ),
            radioTheme: RadioThemeData(
                fillColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected))
                return Colors.amber;
              else
                return Colors.black;
            })),
            dialogTheme: DialogTheme(
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
              opacity: 1,
              size: 23,
            )),
      ),
    );
  }
}

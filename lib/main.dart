import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main.data.dart';
import 'widgets/screens/splash_screen/screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColor = Color.fromRGBO(255, 223, 117, 1);
    final scaffoldBackgroundColor = Color.fromARGB(255, 255, 253, 247);

    return ProviderScope(
      overrides: [
        configureRepositoryLocalStorage(clear: false),
        graphNotifierThrottleDurationProvider
            .overrideWithValue(Duration(milliseconds: 100))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weekly Menu',
        home: SplashScreen(),
        themeMode: ThemeMode.light,
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.mango,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            //backgroundColor: Colors.white,
            primaryColor: appColor,
            primaryColorLight: appColor.withOpacity(0.7),
            primaryColorDark: Colors.black,
            splashColor: Colors.amberAccent,
            highlightColor: Colors.amberAccent.withOpacity(0.3),
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            bottomNavigationBarTheme: theme.bottomNavigationBarTheme
                .copyWith(backgroundColor: scaffoldBackgroundColor),
            // Define the default font family.
            fontFamily: 'Rubik',
            bottomAppBarColor: scaffoldBackgroundColor,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: appColor),
            appBarTheme: AppBarTheme(
                color: appColor,
                titleTextStyle:
                    GoogleFonts.rubik(fontSize: 20, color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black)),

            //AppBarTheme
            bottomAppBarTheme: BottomAppBarTheme(
              color: Colors.white,
            ),
            listTileTheme:
                ListTileThemeData(selectedTileColor: appColor.withOpacity(0.2)),

            //Used by native date picker (see: https://github.com/flutter/flutter/issues/58254)
            colorScheme: ColorScheme.light(
              primary: Colors.amber,
              secondary: Colors.amberAccent,
            ),

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              titleMedium: GoogleFonts.aleo(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.8)),
              displaySmall: GoogleFonts.aleo(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.8)),
              labelMedium: GoogleFonts.aleo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              bodyMedium: GoogleFonts.aleo(
                  fontSize: 15, color: Colors.black.withOpacity(0.8)),
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
            ),
            visualDensity: VisualDensity.comfortable,
            indicatorColor: Colors.amber),
      ),
    );
  }
}

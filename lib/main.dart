import 'package:flutter/material.dart';
import 'package:weekly_menu_app/dto/meal.dart';
import 'package:weekly_menu_app/dto/menu.dart';
import 'package:weekly_menu_app/dto/recipe.dart';
import 'package:weekly_menu_app/recipe_title.dart';

import './app_bar.dart';
import './page.dart';

void main() => runApp(WMApp());

class WMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Menu',
      home: WMHomePage(),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
        accentColor: Colors.yellowAccent,

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
    );
  }
}

class WMHomePage extends StatefulWidget {
  WMHomePage({Key key}) : super(key: key);

  @override
  _WMHomePageState createState() => _WMHomePageState();
}

class _WMHomePageState extends State<WMHomePage> {
  final _pageController = new PageController();
  bool _selectionMode = false;
  String _day = "";
  List<Recipe> _selectedRecipes = List();

  List<Menu> _menus = [
    
      Menu(
        day: "Today",
        meals: {
          "Lunch": [
          Recipe(
            name: "Insalata Andrea",
          ),
          Recipe(
            name: "Pane & Olio",
          )
        ],
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMAppBar(_selectionMode,
          day: _day, selectedRecipes: _selectedRecipes),
      floatingActionButton: !_selectionMode
          ? FloatingActionButton.extended(
              elevation: 4.0,
              icon: const Icon(Icons.add),
              label: const Text('ADD'),
              onPressed: () {},
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: !_selectionMode ? () {} : null,
                ),
                Text(_day),
              ],
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: !_selectionMode ? () {} : null,
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: PageView(
              controller: _pageController,
              children: _menus.map((v) => MenuPage(v.)).toList(),
            ),
          )
        ],
      ),
    );
  }
}

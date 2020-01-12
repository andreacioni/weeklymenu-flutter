import 'package:flutter/material.dart';
import './models/menu.dart';
import './models/recipe.dart';
import './models/meals.dart';
import './widgets/add_recipe_modal/add_recipe_to_menu_modal.dart';

import './widgets/app_bar/app_bar.dart';
import './widgets/menu_page/page.dart';

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
  String _day;
  int _pageIndex;
  List<Recipe> _selectedRecipes = List();
  Meal _selectedMeal = Meal.Breakfast;

  List<Menu> _menus = [
    Menu(day: "Today", meals: {
      Meal.Lunch: [
        Recipe(
          name: "Insalata Andrea",
        ),
        Recipe(
          name: "Pane & Olio",
        ),
        Recipe(
          name: "Vellutata di ceci",
        )
      ],
      Meal.Dinner: [
        Recipe(
          name: "Pizza",
        ),
        Recipe(
          name: "Pizza Cotto & Funghi",
        ),
      ],
    }),
    Menu(day: "Tomorrow", meals: {
      Meal.Lunch: [
        Recipe(
          name: "Insalata Andrea",
        ),
        Recipe(
          name: "Pane & Olio",
        )
      ],
    }),
  ];

  _WMHomePageState() {
    _pageIndex = 0;
    _day = _menus[_pageIndex.truncate()].day;
  }

  void _setDayNameInBottomAppBar(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
      _day = _menus[pageIndex].day;
    });
  }

  void _addNewRecipeOnCurrentDay(int pageIndex, String meal, Recipe recipe) {
    setState(() {
      _menus[pageIndex].meals[meal].add(recipe);
    });
  }

  void _updateSelectedMeal(Meal meal) {
    _selectedMeal = meal;
  }

  void _openAddRecipeModal(ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Padding(
        padding: EdgeInsets.all(15),
        child: AddRecipeToMenuModal(onSelectionEnd: (_) {},),
      ),
    );
  }

  void _openDatePickerModal(ctx) {
    showDatePicker(
        context: ctx,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 3600)),
        lastDate: DateTime.now().add((Duration(days: 3600))));
  }

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
              onPressed: () {
                _openAddRecipeModal(context);
              },
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
                  onPressed: !_selectionMode
                      ? () => _openDatePickerModal(context)
                      : null,
                ),
                GestureDetector(
                  child: Text(_day),
                  onTap: !_selectionMode
                      ? () => _openDatePickerModal(context)
                      : null,
                ),
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
              children: _menus.map((v) => MenuPage(v.meals)).toList(),
              onPageChanged: _setDayNameInBottomAppBar,
            ),
          )
        ],
      ),
    );
  }
}

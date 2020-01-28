import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekly_menu_app/models/ingredient.dart';

import './globals/constants.dart';
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
  PageController _pageController;
  bool _selectionMode = false;
  DateTime _day;
  List<Recipe> _selectedRecipes = List();
  Meal _selectedMeal = Meal.Breakfast;

  List<Menu> _menus = [
    Menu(day: DateTime(2020,01,14), meals: {
      Meal.Lunch: [
        Recipe(
          name: "Insalata Andrea",
          description: "A delicious salad",
          servs: 2,
          estimatedCookingTime: 0,
          estimatedPreparationTime: 10,
          ingredients: [
            RecipeIngredient(name: "Insalata", quantity: 50, unitOfMeasure: "pcs"),
            RecipeIngredient(name: "Pomodori", quantity: 1, unitOfMeasure: "pcs"),
            RecipeIngredient(name: "Tonno", quantity: 50, unitOfMeasure: "gr")
          ],
          imgUrl: "https://www.cucchiaio.it/content/cucchiaio/it/ricette/2018/08/insalata-con-uova-pane-e-mandorle/jcr:content/header-par/image-single.img10.jpg/1533489383063.jpg",
          tags: [
            "Vegetarian",
            "Healty",
            "Fast"
          ]
        ),
      ],
    }),
    Menu(day: DateTime(2020,01,15), meals: {
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
    Menu(day: DateTime(2020,01,16), meals: {
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
    var pageIndex = (PAGEVIEW_LIMIT_DAYS / 2).truncate();
    _pageController = new PageController(initialPage: pageIndex);
    
    var now = DateTime.now();
    _day = DateTime(now.year, now.month, now.day);
  }

  void _setDayNameInBottomAppBar(int newPageIndex) {
    print("page changed to ${newPageIndex}" );
    setState(() {
      var now = DateTime.now();
      _day = DateTime(now.year, now.month, now.day).add(Duration(days: newPageIndex - (PAGEVIEW_LIMIT_DAYS / 2).truncate()));
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
        child: AddRecipeToMenuModal(
          onSelectionEnd: (_) {},
        ),
      ),
    );
  }

  void _selectDate(ctx) async {
    showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate()))),
    ).then((selectedDate) {
      setState(() {
        int oldPageIndex = _pageController.page.truncate();
        if (selectedDate.compareTo(_day) != 0) {
          print("jump length: ${selectedDate.difference(_day).inDays}, from page: ${oldPageIndex} (${_day} to ${selectedDate})");
          int newPageIndex =
              oldPageIndex + selectedDate.difference(_day).inDays;
          print("jumping to page: ${newPageIndex}");
          _pageController.jumpToPage(newPageIndex);
        }
      });
      return selectedDate;
    });
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
                  onPressed:
                      !_selectionMode ? () => _selectDate(context) : null,
                ),
                GestureDetector(
                  child: Text(DateFormat.MMMEd().format(_day)),
                  onTap: !_selectionMode ? () => _selectDate(context) : null,
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
            child: PageView.builder(
              itemBuilder: (ctx, index) {
                return MenuPage(
                    _menus[(index - (PAGEVIEW_LIMIT_DAYS / 2).truncate())%3].meals);
              },
              onPageChanged: _setDayNameInBottomAppBar,
              controller: _pageController,
            ),
          )
        ],
      ),
    );
  }
}

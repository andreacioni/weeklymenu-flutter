import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './globals/constants.dart';
import './models/recipe.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/ingredients_screen/screen.dart';
import './widgets/cart_screen/screen.dart';
import './widgets/add_recipe_modal/add_recipe_to_menu_modal.dart';
import './widgets/menu_page/page.dart';
import './providers/ingredients_provider.dart';
import './providers/recipes_provider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _day;

  bool _ingredientLoaded = false;
  bool _recipesLoaded = false;

  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  void initState() {
    _day = DateTime.now();

    Provider.of<IngredientsProvider>(context, listen: false)
        .fetchIngredients()
        .then((_) => setState(() => _ingredientLoaded = true));
    Provider.of<RecipesProvider>(context, listen: false)
        .fetchRecipes()
        .then((_) => setState(() => _recipesLoaded = true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      MenuScreen(),
      RecipesScreen(),
      IngredientsScreen(),
      CartScreen(),
    ];
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomAppBar(context),
        body: (!_recipesLoaded || !_ingredientLoaded)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _screens[_activeScreenIndex],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 5.0,
      title: _activeScreenIndex == 0
          ? FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  SizedBox(
                    width: 5,
                  ),
                  Text(DateFormat.MMMEd().format(_day)),
                ],
              ),
              onPressed: () => _openDatePicker(context),
            )
          : null,
      leading: const IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
        onPressed: null,
      ),
      actions: const <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 30.0,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _activeScreenIndex,
      onTap: _selectTab,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day), title: Text('Menu')),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt), title: Text('Recipes')),
        BottomNavigationBarItem(
            icon: Icon(Icons.extension), title: Text('Ingredients')),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), title: Text('Cart')),
      ],
    );
  }

  void _selectTab(int index) {
    if (index == _activeScreenIndex) {
      return;
    }

    setState(() {
      _activeScreenIndex = index;
    });
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

  void _openDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: _day,
      firstDate: DateTime.now()
          .subtract(Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate())),
      lastDate: DateTime.now()
          .add((Duration(days: (PAGEVIEW_LIMIT_DAYS / 2).truncate()))),
    ).then(_setSelectedDayFromDatePicker);
  }

  void _setSelectedDayFromDatePicker(DateTime day) {
    if (day != null) {
      setState(() {
        _day = day;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './globals/constants.dart';
import './models/recipe.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/ingredients_screen/screen.dart';
import './widgets/shopping_list_screen/screen.dart';
import './widgets/add_recipe_modal/add_recipe_to_menu_modal.dart';
import './widgets/menu_page/page.dart';
import './providers/ingredients_provider.dart';
import './providers/shopping_list_provider.dart';
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
  bool _shoppingListLoaded = false;

  final List<Widget> _screens = [
    MenuScreen(),
    RecipesScreen(),
    //IngredientsScreen(),
    ShoppingListScreen(),
  ];
  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  void initState() {
    _day = DateTime.now();

    _fetchAndSetData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _hadleAddActionPasedOnScreen,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: _buildBottomAppBar(context),
        body: RefreshIndicator(
          child: (!_recipesLoaded || !_ingredientLoaded || !_shoppingListLoaded)
              ? _buildCircularLoadingIndicator()
              : _screens[_activeScreenIndex],
          onRefresh: _fetchAndSetData,
          displacement: 90,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Info'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('v.1.0.0',
                style: TextStyle(color: Colors.black38),),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center _buildCircularLoadingIndicator() {
    return Center(
                child: CircularProgressIndicator(),
              );
  }

  void _hadleAddActionPasedOnScreen() {
    
  }

  Future<void> _fetchAndSetData() async {
    await Provider.of<IngredientsProvider>(context, listen: false)
        .fetchIngredients()
        .then((_) => setState(() => _ingredientLoaded = true));
    await Provider.of<RecipesProvider>(context, listen: false)
        .fetchRecipes()
        .then((_) => setState(() => _recipesLoaded = true));
    await Provider.of<ShoppingListProvider>(context, listen: false)
        .fetchShoppingListItems()
        .then((_) => setState(() => _shoppingListLoaded = true));
  }

  BottomNavigationBar _buildBottomAppBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _activeScreenIndex,
      onTap: _selectTab,
      //type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day), title: Text('Menu')),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant), title: Text('Recipes')),
        //BottomNavigationBarItem(
        //    icon: Icon(Icons.category), title: Text('Ingredients')),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt), title: Text('Shop. List')),
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
}

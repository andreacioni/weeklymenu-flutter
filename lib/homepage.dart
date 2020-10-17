import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './drawer.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/shopping_list_screen/screen.dart';
import './providers/ingredients_provider.dart';
import './providers/shopping_list_provider.dart';
import './providers/recipes_provider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ingredientLoaded = false;
  bool _recipesLoaded = false;
  bool _shoppingListLoaded = false;

  final PageStorageBucket bucket = PageStorageBucket();
  final List<Widget> _screens = [
    MenuScreen(key: PageStorageKey('menuPage')),
    RecipesScreen(key: PageStorageKey('recipesPage')),
    //IngredientsScreen(),
    ShoppingListScreen(key: PageStorageKey('shoppingListPage')),
  ];
  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  void initState() {
    _fetchAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        bottomNavigationBar: _buildBottomAppBar(context),
        body: RefreshIndicator(
          child: (!_recipesLoaded || !_ingredientLoaded || !_shoppingListLoaded)
              ? _buildCircularLoadingIndicator()
              : PageStorage(
                  child: _screens[_activeScreenIndex],
                  bucket: bucket,
                ),
          onRefresh: _fetchAndSetData,
          displacement: 90,
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  Center _buildCircularLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
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
          icon: Icon(Icons.calendar_view_day),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Shop. List',
        ),
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

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './drawer.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/shopping_list_screen/screen.dart';
import 'main.data.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState<HomePage> {
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
  Widget build(BuildContext context) {
    ref.menus.logLevel = 1;
    ref.recipes.logLevel = 1;
    ref.ingredients.logLevel = 1;
    ref.shoppingLists.logLevel = 1;
    return Scaffold(
      bottomNavigationBar: _buildBottomAppBar(context),
      body: DefaultTabController(
        initialIndex: 1,
        length: 4,
        child: PageStorage(
          child: _screens[_activeScreenIndex],
          bucket: bucket,
        ),
      ),
      drawer: AppDrawer(),
    );
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

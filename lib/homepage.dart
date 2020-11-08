import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:provider/provider.dart';

import './drawer.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/shopping_list_screen/screen.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        bottomNavigationBar: _buildBottomAppBar(context),
        body: PageStorage(
          child: _screens[_activeScreenIndex],
          bucket: bucket,
        ),
        drawer: AppDrawer(),
      ),
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

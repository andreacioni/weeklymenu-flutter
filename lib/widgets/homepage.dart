import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'drawer.dart';
import '../main.data.dart';
import 'screens/menu_page/screen.dart';
import 'screens/recipes_screen/screen.dart';
import 'screens/shopping_list_screen/screen.dart';

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
    MenuScreen(key: const PageStorageKey('menuPage')),
    RecipesScreen(key: const PageStorageKey('recipesPage')),
    ShoppingListScreen(key: const PageStorageKey('shoppingListPage')),
  ];
  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomAppBar(context),
      body: PageStorage(
        child: _screens[_activeScreenIndex],
        bucket: bucket,
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

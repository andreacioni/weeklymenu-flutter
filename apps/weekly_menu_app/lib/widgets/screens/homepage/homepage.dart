import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:weekly_menu_app/widgets/screens/menu_page/screen.dart';
import 'package:weekly_menu_app/widgets/screens/recipes_screen/screen.dart';

import '../shopping_list_screen/screen.dart';
import 'drawer.dart';
import 'notifier.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return ImportFromMenuScreen();
    return ProviderScope(overrides: [
      homepageScreenNotifierProvider.overrideWith((_) =>
          HomepageScreenStateNotifier(HomepageScreenState(isLoading: false)))
    ], child: _HomePage());
  }
}

class _HomePage extends ConsumerStatefulWidget {
  const _HomePage();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState<_HomePage> {
  final PageStorageBucket bucket = PageStorageBucket();

  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(homepageScreenNotifierProvider.select((s) => s.isLoading));

    final List<Widget> _screens = [
      MenuScreen(key: const PageStorageKey('menuPage')),
      const RecipesScreen(key: const PageStorageKey('recipesPage')),
      const ShoppingListScreen(key: const PageStorageKey('shoppingListPage')),
    ];

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        bottomNavigationBar: _buildBottomAppBar(),
        body: PageStorage(
          //ScaffoldMessenger is needed to allow SnackBar to be showed properly
          //in the child Scaffolds
          child: _screens[_activeScreenIndex],
          bucket: bucket,
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  BottomNavigationBar _buildBottomAppBar() {
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

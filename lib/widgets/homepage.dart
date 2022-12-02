import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:weekly_menu_app/providers/screen_notifier.dart';
import 'package:weekly_menu_app/widgets/homepage_screen_notifier.dart';

import '../providers/authentication.dart';
import '../providers/bootstrap.dart';
import '../main.data.dart';
import 'screens/ingredients_screen/screen.dart';
import 'screens/login_screen/screen.dart';
import 'screens/menu_page/screen.dart';
import 'screens/recipes_screen/screen.dart';
import 'screens/shopping_list_screen/screen.dart';
import 'screens/tags_screen/screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      homepageScreenNotifierProvider.overrideWithValue(
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
  final List<Widget> _screens = [
    MenuScreen(key: const PageStorageKey('menuPage')),
    RecipesScreen(key: const PageStorageKey('recipesPage')),
    ShoppingListScreen(key: const PageStorageKey('shoppingListPage')),
  ];
  int _activeScreenIndex = 0;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(homepageScreenNotifierProvider.select((s) => s.isLoading));

    return LoadingOverlay(
      isLoading: isLoading,
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

class AppDrawer extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homepageScreenNotifierProvider.notifier);

    Future<void> logoutAndClearUserData() async {
      log('logging out...');
      final authService = ref.read(authServiceProvider);
      final localPreferences = ref.read(localPreferencesProvider);
      final repositoriesProviders = repositoryProviders.values;

      await authService.logout();
      await localPreferences.clear();

      for (final repositoryProvider in repositoriesProviders) {
        await ref.read(repositoryProvider).clear();
      }

      log('user data deleted');
    }

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Andrea Cioni'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Ingredients'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => IngredientsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Tags'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TagsScreen()));
            },
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
            leading: Icon(Icons.question_answer),
            title: Text('Q&A'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
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
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              notifier.setLoading(true);
              await logoutAndClearUserData();
              notifier.setLoading(false);
              Navigator.pop(context);
              goToLogin(context);
            },
          ),
          ListTile(
            title: Text(
              'v.1.0.0',
              style: TextStyle(color: Colors.black38),
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

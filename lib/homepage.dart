import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './drawer.dart';
import './widgets/menu_page/screen.dart';
import './widgets/recipes_screen/screen.dart';
import './widgets/shopping_list_screen/screen.dart';
import 'models/menu.dart';
import 'widgets/menu_editor/screen.dart';

final homePageModalBottomSheetDailyMenuProvider =
    StateProvider.autoDispose<DailyMenu?>((_) => null);
final homePagePanelControllerProvider =
    Provider<PanelController>((_) => PanelController());

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
    return _BottomSheetPanel(
      child: Scaffold(
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

class _BottomSheetPanel extends HookConsumerWidget {
  final Widget child;
  final double? panelHeight;
  _BottomSheetPanel({required this.child, this.panelHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelController = ref.read(homePagePanelControllerProvider);
    final bottomSheetDailyMenu =
        ref.watch(homePageModalBottomSheetDailyMenuProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = this.panelHeight ?? screenHeight * 0.60;
    final backdropAreaHeight = screenHeight - panelHeight;

    return SlidingUpPanel(
        backdropEnabled: true,
        controller: panelController,
        maxHeight: screenHeight,
        minHeight: 0,
        color: Colors.transparent,
        boxShadow: [],
        backdropTapClosesPanel: true,
        panel: bottomSheetDailyMenu != null
            ? Column(
                children: [
                  GestureDetector(
                    onTap: () => panelController.close(),
                    child: DragTarget(
                      onWillAccept: (data) {
                        panelController.close();
                        return true;
                      },
                      builder: ((_, __, ___) => Container(
                            color: Colors.transparent,
                            height: backdropAreaHeight,
                          )),
                    ),
                  ),
                  Container(
                      height: panelHeight,
                      color: Colors.transparent,
                      child: MenuEditorScreen(
                          DailyMenuNotifier(bottomSheetDailyMenu))),
                ],
              )
            : Container(),
        onPanelClosed: () {
          //ref.read(_modalBottomSheetDailyMenuProvider.notifier).state = null;
          //panelController.close();
        },
        body: child);
  }
}

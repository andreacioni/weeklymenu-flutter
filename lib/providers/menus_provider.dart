import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:weekly_menu_app/syncronizer/syncro.dart';

import './recipes_provider.dart';
import '../models/menu.dart';
import '../models/enums/meals.dart';
import '../models/recipe.dart';
import 'auth_provider.dart';

const String MENU_BOX = 'menus';

class MenusProvider with ChangeNotifier {
  final log = Logger((MenusProvider).toString());

  static final _dateParser = DateFormat('y-MM-dd');

  LazyBox<DailyMenu> _dailyMenuBox = Hive.lazyBox(MENU_BOX);

  Future<DailyMenu> fetchDailyMenu(DateTime day) => _dailyMenuBox.get(day);

  Future<MenuOriginator> createMenu(Menu menu) async {
    final originator = MenuOriginator(menu);

    var dailyMenu = await _dailyMenuBox.get(menu.date);
    dailyMenu.addMenu(originator);

    notifyListeners();
    return originator;
  }

  Future<void> removeMenu(MenuOriginator menu) async {
    var dailyMenu = await _dailyMenuBox.get(menu.date);
    dailyMenu.removeMenu(menu);
    notifyListeners();
  }

  Future<void> saveMenu(MenuOriginator menu) async {}

  void update(RecipesProvider recipesProvider) {
    List<RecipeOriginator> recipesList = recipesProvider.recipes;
    List<MenuOriginator> menusToBeRemoved = [];

    if (recipesList != null) {
      _dailyMenuBox.keys.forEach(
        (date) async {
          var dailyMenu = await _dailyMenuBox.get(date);
          if (dailyMenu.menus != null) {
            for (MenuOriginator menu in dailyMenu.menus) {
              if (menu.recipes != null) {
                var toBeRemovedList = menu.recipes
                    .where((recipeId) => (recipesList
                            .indexWhere((recipe) => recipe.id == recipeId) ==
                        -1))
                    .toList();

                for (Id recipeIdToBeRemvoved in toBeRemovedList) {
                  menu.removeRecipeById(recipeIdToBeRemvoved);
                }

                if (menu.recipes.isEmpty) {
                  menusToBeRemoved.add(menu);
                }
              }
            }
          }
        },
      );
    }

    Future.delayed(Duration(seconds: 0)).then(
      (_) {
        for (MenuOriginator menu in menusToBeRemoved) {
          try {
            removeMenu(menu);
          } catch (e) {
            log.warning("Failed to remove empty menu ${menu.id}", e);
          }
        }
      },
    );
  }
}

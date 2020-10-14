import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:weekly_menu_app/globals/date.dart';

import './recipes_provider.dart';
import '../models/menu.dart';
import '../models/enums/meals.dart';
import '../models/recipe.dart';
import '../datasource/network.dart';
import 'rest_provider.dart';

class MenusProvider with ChangeNotifier {
  final log = Logger((MenusProvider).toString());
  RestProvider _restProvider;

  static final _dateParser = DateFormat('y-MM-dd');

  Map<Date, DailyMenu> _dayToMenus = {};

  MenusProvider(this._restProvider);

  Future<DailyMenu> fetchDailyMenu(Date day) async {
    if (_dayToMenus[day] == null) {
      //TODO handle pagination
      final jsonPage =
          await _restProvider.getMenusByDay(day.format(_dateParser));
      final List<MenuOriginator> menuList = jsonPage['results']
          .map((jsonMenu) => MenuOriginator(Menu.fromJson(jsonMenu)))
          .toList()
          .cast<MenuOriginator>();

      _dayToMenus[day] = DailyMenu(day, menuList);
    }

    return _dayToMenus[day];
  }

  Future<MenuOriginator> createMenu(Menu menu) async {
    assert(menu.id == null);

    try {
      var toJson = menu.toJson();
      toJson.remove('_id');

      var resp = await _restProvider.createMenu(toJson);
      menu.id = resp['_id'];

      final originator = MenuOriginator(menu);

      if (_dayToMenus[menu.date] == null) {
        _dayToMenus[menu.date].addMenu(originator);
      } else {
        _dayToMenus[menu.date].addMenu(originator);
      }

      notifyListeners();

      return originator;
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeMenu(MenuOriginator menu) async {
    _dayToMenus[menu.date].removeMenu(menu);
    notifyListeners();
    try {
      await _restProvider.deleteMenu(menu.id);
    } catch (e) {
      _dayToMenus[menu.date].addMenu(menu);
      notifyListeners();
      throw e;
    }
  }

  Future<void> saveMenu(MenuOriginator menu) async {
    try {
      await _restProvider.putMenu(menu.id, menu.toJson());
      menu.save();
    } catch (e) {
      menu.revert();
      notifyListeners();
      throw e;
    }
  }

  void update(RestProvider restProvider, RecipesProvider recipesProvider) {
    List<RecipeOriginator> recipesList = recipesProvider.getRecipes;
    List<MenuOriginator> menusToBeRemoved = [];
    if (recipesList != null) {
      _dayToMenus.forEach(
        (date, dailyMenu) {
          if (dailyMenu.menus != null) {
            for (MenuOriginator menu in dailyMenu.menus) {
              if (menu.recipes != null) {
                var toBeRemovedList = menu.recipes
                    .where((recipeId) => (recipesList
                            .indexWhere((recipe) => recipe.id == recipeId) ==
                        -1))
                    .toList();

                for (String recipeIdToBeRemvoved in toBeRemovedList) {
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

    _restProvider = restProvider;
  }
}

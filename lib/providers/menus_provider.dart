import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/menu.dart';
import '../models/enums/meals.dart';
import '../models/recipe.dart';

import '../datasource/network.dart';

class MenusProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();
  static final _dateParser = DateFormat('y-MM-dd');

  Map<DateTime, List<Menu>> _dayToMenus = {};

  Future<void> fetchDailyMenu(DateTime day) async {
    //TODO handle pagination
    final jsonPage = await _restApi.getMenusByDay(_dateParser.format(day));
    _dayToMenus[day] = jsonPage['results']
        .map((jsonMenu) => Menu.fromJson(jsonMenu))
        .toList()
        .cast<Menu>();
  }

  Map<Meal, List<String>> getDailyMenuByMeal(DateTime day) {
    Map<Meal, List<String>> recipeByMeal = {};

    Meal.values.forEach((meal) {
      final Menu menuMeal = _dayToMenus[day] != null
          ? _dayToMenus[day]
              .firstWhere((menu) => menu.meal == meal, orElse: () => null)
          : null;
      if (menuMeal != null) {
        recipeByMeal[meal] = menuMeal.recipes;
      }
    });

    return recipeByMeal;
  }

  Menu getByDateAndMeal(DateTime dateTime, Meal meal) {
    return _dayToMenus[dateTime].firstWhere((menu) => menu.meal == meal);
  }

  Future<void> addRecipeToMenu(
      Recipe recipe, DateTime dateTime, Meal meal) async {
    if (recipe == null || dateTime == null || meal == null) {
      print('can\'t add null recipe');
    }

    Menu menu = getByDateAndMeal(dateTime, meal);

    if (menu == null) {
      await _restApi.createMenu(Menu(
        date: dateTime,
        meal: meal,
        recipes: [recipe.id],
      ).toJSON());
    } else {
      await _restApi.addRecipeToMenu(menu.id, recipe.id);

      if (menu.recipes == null) {
        menu.recipes = [recipe.id];
      }
      menu.recipes.add(recipe.id);
    }

    notifyListeners();
  }

  Future<Menu> addMenu(Menu menu) async {
    try {
      var resp = await _restApi.createMenu(menu.toJSON());
      menu.id = resp['_id'];

      if (_dayToMenus[menu.date] == null) {
        _dayToMenus[menu.date] = [menu];
      } else {
        _dayToMenus[menu.date].add(menu);
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }

    return menu;
  }
}

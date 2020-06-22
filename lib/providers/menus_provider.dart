import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/menu.dart';
import '../models/enums/meals.dart';
import '../models/recipe.dart';

import '../datasource/network.dart';

class MenusProvider with ChangeNotifier {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();
  static final _dateParser = DateFormat('y-MM-dd');

  Map<DateTime, List<MenuOriginator>> _dayToMenus = {};

  Future<List<MenuOriginator>> fetchDailyMenu(DateTime day) async {
    //TODO handle pagination
    final jsonPage = await _restApi.getMenusByDay(_dateParser.format(day));
    final List<MenuOriginator> menuList = jsonPage['results']
        .map((jsonMenu) => MenuOriginator(Menu.fromJson(jsonMenu)))
        .toList()
        .cast<MenuOriginator>();
    _dayToMenus[day] = menuList;

    return menuList;
  }

  MenuOriginator getByDateAndMeal(DateTime dateTime, Meal meal) {
    return _dayToMenus[dateTime].firstWhere((menu) => menu.meal == meal);
  }

  Future<void> addRecipeToMenu(
      RecipeOriginator recipe, DateTime dateTime, Meal meal) async {
    if (recipe == null || dateTime == null || meal == null) {
      print('can\'t add null recipe');
    }

    MenuOriginator menu = getByDateAndMeal(dateTime, meal);

    if (menu == null) {
      await _restApi.createMenu(Menu(
        date: dateTime,
        meal: meal,
        recipes: [recipe.id],
      ).toJson());
    } else {
      await _restApi.addRecipeToMenu(menu.id, recipe.id);

      if (menu.recipes == null) {
        menu.recipes = [recipe.id];
      }
      menu.addRecipe(recipe);
    }

    notifyListeners();
  }

  Future<MenuOriginator> addMenu(Menu menu) async {
    try {
      var resp = await _restApi.createMenu(menu.toJson());
      menu.id = resp['_id'];
      
      final originator = MenuOriginator(menu);

      if (_dayToMenus[menu.date] == null) {
        _dayToMenus[menu.date] = [originator];
      } else {
        _dayToMenus[menu.date].add(originator);
      }

      notifyListeners();
      
      return originator;
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeDayMeal(DateTime day, Meal meal) async {
    if (_dayToMenus[day] == null || _dayToMenus[day].isEmpty) {
      throw ArgumentError("no menu found for day: $day");
    }

    var menuIds = <String>[];

    for (var menu in _dayToMenus[day]) {
      if (menu.meal == meal) {
        menuIds.add(menu.id);
      }
    }

    notifyListeners();

    for (var id in menuIds) {
      await _restApi.deleteMenu(id);
    }
  }
}

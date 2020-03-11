import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../models/meals.dart';
import '../models/recipe.dart';

import './recipes_provider.dart';

List<Menu> _menus = [
  Menu(
      day: DateTime(2020, 03, 11),
      meal: Meal.Lunch,
      recipes: ["adfie82bfiui", "fno2ecb22o"]),
  Menu(
    day: DateTime(2020, 01, 15),
    meal: Meal.Lunch,
    recipes: [
      "adfie82bfiui",
      "fno2ecb22o",
    ],
  ),
  Menu(
    day: DateTime(2020, 01, 15),
    meal: Meal.Dinner,
    recipes: [
      "adfie82bfiui",
      "fno2ecb22o",
    ],
  ),
  Menu(
    day: DateTime(2020, 01, 16),
    meal: Meal.Lunch,
    recipes: ["adfie82bfiui", "fno2ecb22o"],
  ),
];

class MenusProvider with ChangeNotifier {
  List<Menu> get getMenus => [..._menus];

  Map<Meal, List<String>> groupByMeal(DateTime day) {
    var dailyMenus = _menus.where((menu) => menu.day == day);
    Map<Meal, List<String>> recipeByMeal = {};

    Meal.values.forEach((meal) {
      final Menu menuMeal = dailyMenus.firstWhere((menu) => menu.meal == meal,
          orElse: () => null);
      if (menuMeal != null) {
        recipeByMeal[meal] = menuMeal.recipes;
      }
    });

    return recipeByMeal;
  }

  Menu getById(String id) => _menus.firstWhere((menu) => menu.id == id);

  Menu getByDateAndMeal(DateTime dateTime, Meal meal) =>
      _menus.firstWhere((menu) => menu.day == dateTime && menu.meal == meal);

  void addRecipe(Recipe recipe, DateTime dateTime, Meal meal) {
    if (recipe == null || dateTime == null || meal == null) {
      print('can\'t add null recipe');
    }

    Menu menu = getByDateAndMeal(dateTime, meal);

    if (menu == null) {
      menu = Menu(
        day: dateTime,
        meal: meal,
        recipes: [recipe.id],
      );
    } else {
      menu.recipes.add(recipe.id);
    }

    _menus.add(menu);
    notifyListeners();
  }
}

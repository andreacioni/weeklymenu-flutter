import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../models/meals.dart';
import '../models/recipe.dart';

import './recipes_provider.dart';

RecipesProvider _recipesProviders;

List<Menu> _menus = [
  Menu(day: DateTime(2020, 01, 14), meal: Meal.Lunch, recipes: [
    _recipesProviders.getById("adfie82bfiui"),
    _recipesProviders.getById("fno2ecb22o")
  ]),
  Menu(
    day: DateTime(2020, 01, 15),
    meal: Meal.Lunch,
    recipes: [
      _recipesProviders.getById("adfie82bfiui"),
      _recipesProviders.getById("fno2ecb22o"),
    ],
  ),
  Menu(
    day: DateTime(2020, 01, 15),
    meal: Meal.Dinner,
    recipes: [
      _recipesProviders.getById("adfie82bfiui"),
      _recipesProviders.getById("fno2ecb22o"),
    ],
  ),
  Menu(
    day: DateTime(2020, 01, 16),
    meal: Meal.Lunch,
    recipes: [
      _recipesProviders.getById("adfie82bfiui"),
      _recipesProviders.getById("fno2ecb22o")
    ],
  ),
];

class MenusProvider with ChangeNotifier {
  List<Menu> get getMenus => [..._menus];

  Map<Meal, List<Recipe>> groupByMeal(DateTime day) { 
    var dailyMenus = _menus.where((menu) => menu.day == day);
    Map<Meal, List<Recipe>> recipeByMeal = {};

    Meal.values.forEach((meal) {
      Menu menuMeal = dailyMenus.firstWhere((menu) => menu.meal == meal);
      recipeByMeal[meal] = menuMeal.recipes;
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
        recipes: [recipe],
      );
    } else {
      menu.recipes.add(recipe);
    }

    _menus.add(menu);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../models/meals.dart';
import '../models/recipe.dart';

import './recipes_provider.dart';

RecipesProviders _recipesProviders;

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

  Menu getById(String id) => _menus.firstWhere((menu) => menu.id == id);
}

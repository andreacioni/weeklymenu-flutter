import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../globals/utils.dart' as utils;
import '../datasource/network.dart';
import '../globals/utils.dart';
import './enums/meals.dart';
import './recipe.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  final NetworkDatasource _restApi = NetworkDatasource.getInstance();

  static final _dateParser = DateFormat('y-M-d');

  @JsonKey(name: '_id')
  String id;
  @JsonKey(toJson: dateToJson, fromJson: dateFromJson)
  DateTime date;
  Meal meal;

  @JsonKey(includeIfNull: false, defaultValue: [])
  List<String> recipes;

  Menu({this.id, this.date, this.meal, this.recipes});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  void addRecipe(Recipe recipe) {
    if (recipe != null) {
      recipes.add(recipe.id);
    }
  }

  Future<void> save() async {
    return await _restApi.putMenu(id, toJson());
  }

  Menu clone() => Menu.fromJson(this.toJson());

  static String dateToJson(DateTime date) => _dateParser.format(date);

  static DateTime dateFromJson(String date) => _dateParser.parse(date);
}

class DailyMenu with ChangeNotifier {
  final DateTime day;
  List<Menu> _originalMenus;
  List<Menu> _snapshotMenus;
  Map<Meal, List<String>> _selectedRecipesByMeal = {};

  DailyMenu(this.day, this._originalMenus) : assert(_originalMenus != null) {
    _snapshotMenus =
        List<Menu>.from(_originalMenus.map((m) => m.clone()).toList());
  }

  void moveRecipeToMeal(Meal from, to, String recipeId) {
    assert(
        (recipeIdsByMeal[from] != null) && (recipeIdsByMeal[from].isNotEmpty));

    final initialLength = recipeIdsByMeal[from].length;

    List<String> recipeIdsForMeal = recipeIdsByMeal[from];
    recipeIdsForMeal.removeWhere((id) => recipeId == id);

    assert(initialLength != recipeIdsForMeal.length);

    if (recipeIdsByMeal[to] == null) {
      recipeIdsByMeal[to] = <String>[recipeId];
    } else {
      recipeIdsByMeal[to].add(recipeId);
    }

    notifyListeners();
  }

  List<String> getRecipeIdsByMeal(Meal meal) {
    return this.recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  List<Menu> getMenusByMeal(Meal meal) {
    return recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  void addRecipeToMeal(Meal meal, Recipe recipe) async {
    final menu = getMenuByMeal(meal);

    if (menu != null) {
      menu.addRecipe(recipe);
    } else {}

    notifyListeners();
  }

  Map<Meal, List<String>> get recipeIdsByMeal {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (_snapshotMenus != null && _snapshotMenus.isNotEmpty) {
      Meal.values.forEach((meal) {
        final Menu menuMeal = _snapshotMenus != null
            ? _snapshotMenus.firstWhere((menu) => menu.meal == meal,
                orElse: () => null)
            : null;

        if (menuMeal != null) {
          recipeIdsByMeal[meal] = menuMeal.recipes;
        } else {
          recipeIdsByMeal[meal] = [];
        }
      });
    }

    return recipeIdsByMeal;
  }

  Menu getMenuByMeal(Meal meal) {
    if (_snapshotMenus != null && _snapshotMenus.isNotEmpty) {
      return _snapshotMenus.firstWhere((menu) => menu.meal == meal,
          orElse: () => null);
    }

    return null;
  }

  Future<void> save() async {
    for (Menu m in _snapshotMenus) {
      //TODO handle exception of a subset of menu patch request failure
      await m.save();
    }

    _originalMenus = _snapshotMenus;

    notifyListeners();
  }

  void restoreOriginal() {
    _snapshotMenus = _originalMenus;

    notifyListeners();
  }

  void setSelectedRecipe(MealRecipe mealRecipe) {
    List<String> recipesList = _selectedRecipesByMeal[mealRecipe.meal];

    if (recipesList == null) {
      recipesList = [];
    }

    recipesList.add(mealRecipe.recipe.id);
  }

  void removeSelectedRecipe(MealRecipe mealRecipe) {
    final List<String> recipesList = _selectedRecipesByMeal[mealRecipe.meal];

    if (recipesList != null) {
      recipesList.removeWhere((recId) => mealRecipe.recipe.id == recId);
    }
  }

  void clearSelected() {
    _selectedRecipesByMeal.clear();
  }

  Future<void> removeSelectedMealRecipes() async {
    _selectedRecipesByMeal.forEach((meal, recipesId) {
      if (recipesId != null && recipesId.isNotEmpty) {
        Menu menu = getMenuByMeal(meal);
        recipesId.forEach((recipeIdToBeDeleted) async {
          if (menu.recipes != null && menu.recipes.isNotEmpty) {
            menu.recipes.removeWhere(
                (menuRecipeId) => recipeIdToBeDeleted == menuRecipeId);
            
            await menu.save();
          }
        });
      }
    });
  }

  bool get isToday => utils.dateTimeToDate(DateTime.now()) == day;

  bool get isPast => (utils
      .dateTimeToDate(day)
      .add(Duration(days: 1))
      .isBefore(DateTime.now()));
}

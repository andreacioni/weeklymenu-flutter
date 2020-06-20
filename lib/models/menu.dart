import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/globals/memento.dart';

import '../globals/utils.dart' as utils;
import '../datasource/network.dart';
import '../globals/utils.dart';
import './enums/meals.dart';
import './recipe.dart';

part 'menu.g.dart';

class MenuOriginator extends Originator<Menu> {
  MenuOriginator(Menu original) : super(original);
  
  void addRecipe(RecipeOriginator recipe) {
    if (recipe != null) {
      instance.recipes.add(recipe.id);
      setEdited();
    }
  }

  List<String> get recipes => [...instance.recipes];
}

@JsonSerializable()
class Menu implements CloneableAndSaveable<Menu> {
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

  @override
  Future<Menu> save() async {
    await _restApi.putMenu(id, toJson());
    return this;
  }

  @override
  Menu clone() => Menu.fromJson(this.toJson());

  static String dateToJson(DateTime date) => _dateParser.format(date);

  static DateTime dateFromJson(String date) => _dateParser.parse(date);
}

class DailyMenu with ChangeNotifier {
  final DateTime day;

  List<MenuOriginator> _menus;

  Map<Meal, List<String>> _selectedRecipesByMeal = {};

  DailyMenu(this.day, this._menus) : assert(_menus != null);

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

  List<MenuOriginator> getMenusByMeal(Meal meal) {
    return recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  void addRecipeToMeal(Meal meal, RecipeOriginator recipe) async {
    final menu = getMenuByMeal(meal);

    if (menu != null) {
      menu.addRecipe(recipe);
    } else {}

    notifyListeners();
  }

  Map<Meal, List<String>> get recipeIdsByMeal {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (_menus != null && _menus.isNotEmpty) {
      Meal.values.forEach((meal) {
        final MenuOriginator menuMeal = _menus != null
            ? _menus.firstWhere((menu) => menu.instance.meal == meal,
                orElse: () => null)
            : null;

        if (menuMeal != null) {
          recipeIdsByMeal[meal] = menuMeal.instance.recipes;
        } else {
          recipeIdsByMeal[meal] = [];
        }
      });
    }

    return recipeIdsByMeal;
  }

  MenuOriginator getMenuByMeal(Meal meal) {
    if (_menus != null && _menus.isNotEmpty) {
      return _menus.firstWhere((menu) => menu.instance.meal == meal,
          orElse: () => null);
    }

    return null;
  }

  Future<void> save() async {
    for (MenuOriginator m in _menus) {
      //TODO handle exception of a subset of menu patch request failure
      await m.save();
    }

    notifyListeners();
  }

  void restoreOriginal() {
    for (MenuOriginator m in _menus) {
      //TODO handle exception of a subset of menu patch request failure
      m.revert();
    }

    notifyListeners();
  }

  void setSelectedRecipe(MealRecipe mealRecipe) {
    List<String> recipesList = _selectedRecipesByMeal[mealRecipe.meal];

    if (recipesList == null) {
      recipesList = [];
    }

    recipesList.add(mealRecipe.recipe.id);
    _selectedRecipesByMeal[mealRecipe.meal] = recipesList;
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

  void removeSelectedMealRecipes() {
    _selectedRecipesByMeal.forEach(
      (meal, recipesId) {
        if (recipesId != null && recipesId.isNotEmpty) {
          Menu menu = getMenuByMeal(meal).instance;
          recipesId.forEach(
            (recipeIdToBeDeleted) {
              if (menu.recipes != null && menu.recipes.isNotEmpty) {
                menu.recipes.removeWhere(
                    (menuRecipeId) => recipeIdToBeDeleted == menuRecipeId);
              }
            },
          );
        }
      },
    );

    notifyListeners();
  }

  bool get isToday => utils.dateTimeToDate(DateTime.now()) == day;

  bool get isPast => (utils
      .dateTimeToDate(day)
      .add(Duration(days: 1))
      .isBefore(DateTime.now()));
}

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/memento.dart';
import 'package:weekly_menu_app/providers/menus_provider.dart';

import '../globals/utils.dart' as utils;
import '../datasource/network.dart';
import './enums/meals.dart';
import './recipe.dart';

part 'menu.g.dart';

class MenuOriginator extends Originator<Menu> {
  MenuOriginator(Menu original) : super(original);

  void addRecipe(RecipeOriginator recipe) {
    assert(recipe != null);
    addRecipeById(recipe.id);
  }

  void addRecipeById(String recipeId) {
    assert(recipeId != null);
    instance.recipes.add(recipeId);
    setEdited();
  }

  void removeRecipeById(String recipeId) {
    assert(recipeId != null);

    instance.recipes.removeWhere((recId) => recId == recipeId);
    setEdited();
  }

  String get id => instance.id;

  DateTime get date => instance.date;

  Meal get meal => instance.meal;

  List<String> get recipes => [...instance.recipes];

  set recipes(List<String> recipes) {
    setEdited();
    this.recipes = recipes;
  }

  Map<String, dynamic> toJson() => instance.toJson();
}

@JsonSerializable()
class Menu implements Cloneable<Menu> {
  
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
    assert((getMenuByMeal(from) != null) && (getMenuByMeal(to) != null));

    final menuFrom = getMenuByMeal(from);
    final menuTo = getMenuByMeal(to);
    final initialLength = menuFrom.recipes.length;

    menuFrom.removeRecipeById(recipeId);

    assert(initialLength != menuFrom.recipes.length);

    menuTo.addRecipeById(recipeId);

    notifyListeners();
  }

  List<String> getRecipeIdsByMeal(Meal meal) {
    return this.recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  List<MenuOriginator> getMenusByMeal(Meal meal) {
    return recipeIdsByMeal[meal] == null ? [] : recipeIdsByMeal[meal];
  }

  void addMenu(MenuOriginator newMenu) {
    assert(_menus.firstWhere(
          (menu) => menu.meal == newMenu.meal,
          orElse: () => null,
        ) ==
        null);

    newMenu.setEdited();
    _menus.add(newMenu);

    notifyListeners();
  }

  void addRecipeToMeal(Meal meal, RecipeOriginator recipe) {
    var menu = getMenuByMeal(meal);

    assert(menu != null);
    menu.addRecipe(recipe);

    notifyListeners();
  }

  Map<Meal, List<String>> get recipeIdsByMeal {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (_menus != null && _menus.isNotEmpty) {
      Meal.values.forEach((meal) {
        final MenuOriginator menuMeal = _menus != null
            ? _menus.firstWhere((menu) => menu.meal == meal, orElse: () => null)
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

  MenuOriginator getMenuByMeal(Meal meal) {
    if (_menus != null && _menus.isNotEmpty) {
      return _menus.firstWhere((menu) => menu.meal == meal, orElse: () => null);
    }

    return null;
  }

  void restoreOriginal() {
    for (MenuOriginator m in _menus) {
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

  Future<void> removeMenu(MenuOriginator menu) async {
    _menus.removeWhere((element) => element.id == menu.id);
    notifyListeners();
  }

  void removeSelectedMealRecipes() {
    _selectedRecipesByMeal.forEach(
      (meal, recipesId) {
        if (recipesId != null && recipesId.isNotEmpty) {
          MenuOriginator menu = getMenuByMeal(meal);
          recipesId.forEach(
            (recipeIdToBeDeleted) {
              if (menu.recipes != null && menu.recipes.isNotEmpty) {
                menu.removeRecipeById(recipeIdToBeDeleted);
              }
            },
          );
        }
      },
    );

    notifyListeners();
  }

  bool get isEdited {
    bool ret = false;

    _menus.forEach(
      (menu) {
        if (menu.isEdited == true) {
          ret = true;
        }
      },
    );

    return ret;
  }

  List<MenuOriginator> get menus => [..._menus];

  bool get isToday => utils.dateTimeToDate(DateTime.now()) == day;

  bool get isPast => (utils
      .dateTimeToDate(day)
      .add(Duration(days: 1))
      .isBefore(DateTime.now()));
}

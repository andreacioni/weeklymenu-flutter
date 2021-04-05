import 'package:flutter/cupertino.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weekly_menu_app/globals/date.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import '../globals/memento.dart';
import './recipe.dart';
import 'enums/meals.dart';

part 'menu.g.dart';

@JsonSerializable()
@DataRepository([BaseAdapter])
class Menu extends BaseModel<Menu> {
  static final _dateParser = DateFormat('y-M-d');

  @JsonKey(toJson: dateToJson, fromJson: dateFromJson)
  Date date;

  Meal meal;

  @JsonKey(includeIfNull: false, defaultValue: [])
  List<String> recipes;

  Menu({String id, this.date, this.meal, this.recipes}) : super(id: id);

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  Menu clone() => Menu.fromJson(this.toJson());

  static String dateToJson(Date date) => date.format(_dateParser);

  static Date dateFromJson(String date) => Date.parse(_dateParser, date);
}

class MenuOriginator extends Originator<Menu> {
  MenuOriginator(Menu original) : super(original);

  void addRecipe(Recipe recipe) {
    if (recipe != null) {
      addRecipeById(recipe.id);
    }
  }

  void addRecipesByIdList(List<String> selectedRecipes) {
    if (selectedRecipes != null && selectedRecipes.isNotEmpty) {
      selectedRecipes.forEach((recipeId) => addRecipeById(recipeId));
    }
  }

  void addRecipeById(String recipeId) {
    if (recipeId != null && !instance.recipes.contains(recipeId)) {
      instance.recipes.add(recipeId);
      setEdited();
    }
  }

  void removeRecipeById(String recipeId) {
    if (recipeId != null) {
      instance.recipes.removeWhere((recId) => recId == recipeId);
      setEdited();
    }
  }

  void removeAllRecipes() {
    instance.recipes.clear();
    setEdited();
  }

  String get id => instance.id;

  Date get date => instance.date;

  Meal get meal => instance.meal;

  List<String> get recipes => [...instance.recipes];

  bool get isEmpty => instance.recipes == null || instance.recipes.isEmpty;

  Map<String, dynamic> toJson() => instance.toJson();
}

class DailyMenu
    with ChangeNotifier
    implements Revertable<List<MenuOriginator>> {
  final Date day;

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

  void addRecipeToMeal(Meal meal, Recipe recipe) {
    var menu = getMenuByMeal(meal);

    assert(menu != null);
    menu.addRecipe(recipe);

    notifyListeners();
  }

  void addRecipeIdListToMeal(Meal meal, List<String> recipeIds) {
    if (recipeIds != null && recipeIds.isNotEmpty) {
      var menu = getMenuByMeal(meal);

      assert(menu != null);
      menu.addRecipesByIdList(recipeIds);

      notifyListeners();
    }
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

  List<MenuOriginator> revert() {
    for (MenuOriginator m in _menus) {
      m.revert();
    }

    notifyListeners();
    return _menus;
  }

  void setSelectedRecipe(MealRecipe mealRecipe) {
    List<String> recipesList = _selectedRecipesByMeal[mealRecipe.meal];

    if (recipesList == null) {
      recipesList = [];
    }

    recipesList.add(mealRecipe.recipe.id);
    _selectedRecipesByMeal[mealRecipe.meal] = recipesList;
    notifyListeners();
  }

  void removeSelectedRecipe(MealRecipe mealRecipe) {
    final List<String> recipesList = _selectedRecipesByMeal[mealRecipe.meal];

    if (recipesList != null) {
      recipesList.removeWhere((recId) => mealRecipe.recipe.id == recId);
    }
    notifyListeners();
  }

  void clearSelected() {
    _selectedRecipesByMeal.clear();
    notifyListeners();
  }

  Future<void> save(
      BuildContext context, Repository<Menu> menuRepository) async {
    for (MenuOriginator menu in menus) {
      if (menu.recipes.isEmpty) {
        // No recipes in menu means that there isn't a menu for that meal, so when can remove it
        await menuRepository.delete(menu);
        removeMenu(menu);
      } else {
        await menuRepository.save(menu.instance);
      }
    }
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

  /**
   * Get the meal of the selected recipes, _null_ is returned if no recipes are selected.
   * If there are selected recipe that belongs to more meals _null_ is returned.
   */
  Meal get selectedRecipesMeal {
    Meal meal;
    final selectedRecipesClone =
        Map<Meal, List<String>>.from(_selectedRecipesByMeal);

    if (selectedRecipesClone != null && selectedRecipesClone.isNotEmpty) {
      selectedRecipesClone.removeWhere(
          (_, recipeIds) => recipeIds == null || recipeIds.isEmpty);

      if (selectedRecipesClone.length == 1) {
        meal = selectedRecipesClone.entries.first.key;
      }
    }

    return meal;
  }

/**
 *  Returns selected recipes ids. Duplicates are removed.
 */
  List<String> get selectedRecipes {
    final recipeIds = <String>[];

    _selectedRecipesByMeal.forEach((meal, recipeMealIds) {
      recipeMealIds.forEach((recipeId) {
        if (!recipeIds.contains(recipeId)) {
          recipeIds.add(recipeId);
        }
      });
    });

    return recipeIds;
  }

  bool get hasSelectedRecipes => selectedRecipes.isNotEmpty;

  void removeAllRecipesFromMeal(Meal meal) {
    if (_menus != null && _menus.isNotEmpty) {
      final menu = _menus.firstWhere((m) => m.meal == meal, orElse: () => null);
      if (menu != null) {
        menu.removeAllRecipes();
        notifyListeners();
      }
    }
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

  bool get isToday => day.isToday;

  bool get isPast => day.isPast;
}

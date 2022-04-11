// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/main.data.dart';

import '../globals/json_converter.dart';
import 'date.dart';
import 'base_model.dart';
import '../globals/memento.dart';
import './recipe.dart';
import 'enums/meal.dart';

part 'menu.g.dart';

@JsonSerializable()
@DataRepository([BaseAdapter])
@CopyWith()
class Menu extends BaseModel<Menu> {
  @DateConverter()
  Date date;

  Meal meal;

  @JsonKey(includeIfNull: false)
  List<String> recipes;

  Menu(
      {required String id,
      required this.date,
      required this.meal,
      this.recipes = const [],
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  factory Menu.create({
    required Date date,
    required Meal meal,
    List<String> recipes = const [],
  }) =>
      Menu(id: ObjectId().hexString, date: date, meal: meal, recipes: recipes);

  Menu addRecipe(String recipeId) {
    return this.copyWith(recipes: [...recipes, recipeId]).was(this);
  }

  Menu addRecipes(List<String> recipeIds) {
    return this.copyWith(recipes: [...recipes, ...recipeIds]).was(this);
  }

  Menu removeRecipeById(String id) {
    return this
        .copyWith(recipes: recipes..removeWhere((element) => element == id))
        .was(this);
  }

  Menu removeRecipeByIdList(List<String> ids) {
    return this
        .copyWith(recipes: recipes..removeWhere((e) => ids.contains(e)))
        .was(this);
  }

  Menu removeAllRecipes() {
    return this.copyWith(recipes: []).was(this);
  }

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  Menu clone() => Menu.fromJson(this.toJson());
}

class DailyMenu extends StateNotifier<List<Menu>> {
  final Date day;

  DailyMenu(this.day, List<Menu> menuList) : super(menuList) {
    assert(menuList.every((element) => element.date == day));
  }

  void moveRecipeToMeal(Meal from, to, String recipeId) {
    /* assert((getMenuByMeal(from) != null) && (getMenuByMeal(to) != null));

    final menuFrom = getMenuByMeal(from);
    final menuTo = getMenuByMeal(to);

    menuFrom?.removeRecipeById(recipeId);

    assert(initialLength != menuFrom.recipes.length);

    menuTo?.addRecipeById(recipeId);

    */

    throw Error();
  }

  List<String> getRecipeIdsByMeal(Meal meal) {
    return recipeIdsByMeal[meal] ?? [];
  }

  List<Menu> getMenusByMeal(Meal meal) {
    return menus.where((m) => m.meal == meal).toList();
  }

  void addMenu(Menu newMenu) {
    assert(state.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) ==
        null);

    state = [...state, newMenu];
  }

  void updateMenu(Menu newMenu) {
    assert(state.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) !=
        null);
    state.removeWhere((menu) => menu.meal == newMenu.meal);
    state = [...state, newMenu];
  }

  void addRecipeToMeal(Meal meal, Recipe recipe) {
    var menu = getMenuByMeal(meal);

    if (menu == null) {
      menu = Menu.create(date: day, meal: meal, recipes: [recipe.id]);
    } else {
      menu = menu.addRecipe(recipe.id);
    }

    menu.save();
    updateMenu(menu);
  }

  void addRecipeIdListToMeal(Meal meal, List<String> recipeIds) {
    if (recipeIds.isNotEmpty) {
      var menu = getMenuByMeal(meal);

      if (menu != null) {
        menu.addRecipes(recipeIds);
      }
    }
  }

  Map<Meal, List<String>> get recipeIdsByMeal {
    Map<Meal, List<String>> recipeIdsByMeal = {};

    if (state.isNotEmpty) {
      Meal.values.forEach((meal) {
        final menuMeal = state.firstWhereOrNull((menu) => menu.meal == meal);

        if (menuMeal != null) {
          recipeIdsByMeal[meal] = menuMeal.recipes;
        } else {
          recipeIdsByMeal[meal] = [];
        }
      });
    }

    return recipeIdsByMeal;
  }

  Menu? getMenuByMeal(Meal meal) =>
      state.firstWhereOrNull((menu) => menu.meal == meal);

  Future<void> save(DailyMenu dailyMenu) async {
    for (Menu menu in dailyMenu.menus) {
      if (menu.recipes.isEmpty) {
        // No recipes in menu means that there isn't a menu for that meal, so when can remove it
        await menu.delete(params: {'update': true});
        dailyMenu.removeMenu(menu);
      } else {
        await menu.save(params: {'update': true});
      }
    }
  }

  void removeMenu(Menu menu) {
    state.removeWhere((element) => element.id == menu.id);
  }

  void removeRecipesFromMeal(List<String> recipeIds) {
    final copy = [...state];
    copy.forEach((e) => e.removeRecipeByIdList(recipeIds));
  }

  void removeAllRecipesFromMeal(Meal meal) {
    if (state.isNotEmpty) {
      final menu = state.firstWhereOrNull((m) => m.meal == meal);
      if (menu != null) {
        menu.removeAllRecipes();
      }
    }
  }

  List<Menu> get menus => [...menus];

  bool get isToday => day.isToday;

  bool get isPast => day.isPast;
}

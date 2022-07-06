// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
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
      {String? id,
      required this.date,
      required this.meal,
      this.recipes = const [],
      int? insertTimestamp,
      int? updateTimestamp})
      : super(
            id: id ?? ObjectId().hexString,
            insertTimestamp: insertTimestamp,
            updateTimestamp: updateTimestamp);

  Menu addRecipe(String recipeId) {
    return this.copyWith(recipes: [...recipes, recipeId]);
  }

  Menu addRecipes(List<String> recipeIds) {
    return this.copyWith(recipes: [...recipes, ...recipeIds]);
  }

  Menu removeRecipeById(String id) {
    return this
        .copyWith(recipes: recipes..removeWhere((element) => element == id));
  }

  Menu removeRecipeByIdList(List<String> ids) {
    return this.copyWith(recipes: recipes..removeWhere((e) => ids.contains(e)));
  }

  Menu removeAllRecipes() {
    return this.copyWith(recipes: []);
  }

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  Menu clone() => Menu.fromJson(this.toJson());
}

class DailyMenuNotifier extends StateNotifier<DailyMenu> {
  DailyMenuNotifier(DailyMenu dailyMenu) : super(dailyMenu);

  Future<Menu> addMenu(Menu newMenu) async {
    assert(state.menus.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) ==
        null);

    final res = await newMenu.save(params: {'update': false});
    state = state.copyWith(menus: [...state.menus, newMenu]);

    return res;
  }

  Future<Menu> updateMenu(Menu newMenu) async {
    assert(state.menus.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) !=
        null);
    final menuList = state.menus..removeWhere((m) => m.id == newMenu.id);

    final res = await newMenu.save(params: {'update': true});
    state = state.copyWith(menus: [...menuList, newMenu]);

    return res;
  }

  Future<Menu> addRecipeToMeal(Meal meal, Recipe recipe) async {
    var menu = state.getMenuByMeal(meal);

    if (menu != null) {
      menu = menu.addRecipe(recipe.id);
      final res = await updateMenu(menu);
      return res;
    }

    return menu!;
  }

  void addRecipeIdListToMeal(Meal meal, List<String> recipeIds) {
    if (recipeIds.isNotEmpty) {
      var menu = state.getMenuByMeal(meal);

      if (menu != null) {
        final newMenu = menu.addRecipes(recipeIds);
        updateMenu(newMenu);
      }
    }
  }

  Future<void> removeMenu(Menu menu) async {
    final newList = state.menus
      ..removeWhere((element) => element.id == menu.id);
    await menu.delete();
    state = state.copyWith(menus: newList);
  }

  Future<void> save(DailyMenu dailyMenu) async {
    for (Menu menu in dailyMenu.menus) {
      if (menu.recipes.isEmpty) {
        // No recipes in menu means that there isn't a menu for that meal, so when can remove it
        await menu.delete(params: {'update': true});
        removeMenu(menu);
      } else {
        await menu.save(params: {'update': true});
      }
    }
  }

  Future<void> replaceRecipeInMeal(Meal meal,
      {required String oldRecipeId, required String newRecipeId}) async {
    Menu? menu = state.menus.firstWhereOrNull((menu) => menu.meal == meal);

    if (menu != null) {
      final recipeList = [...menu.recipes];
      final recipeIdx = recipeList.indexOf(oldRecipeId);
      if (recipeIdx != -1) {
        recipeList[recipeIdx] = newRecipeId;
        menu = menu.copyWith(recipes: recipeList);
        await updateMenu(menu);
      }
    }
  }

  Future<void> removeRecipeFromMeal(Meal meal, String recipeId) async {
    await removeRecipesFromMeal(meal, [recipeId]);
  }

  Future<void> removeRecipesFromMeal(Meal meal, List<String> recipeIds) async {
    final menuMeal = state.menus.firstWhereOrNull((menu) => menu.meal == meal);

    if (menuMeal != null) {
      final newMenu = menuMeal.removeRecipeByIdList(recipeIds);

      if (newMenu.recipes.isEmpty) {
        await removeMenu(newMenu);
      } else {
        await updateMenu(newMenu);
      }
    }
  }

  void removeAllRecipesFromMeal(Meal meal) {
    if (state.menus.isNotEmpty) {
      final menu = state.menus.firstWhereOrNull((m) => m.meal == meal);
      if (menu != null) {
        menu.removeAllRecipes();
        updateMenu(menu);
      }
    }
  }

  DailyMenu get dailyMenu => state;
}

@CopyWith()
class DailyMenu {
  final Date day;
  final List<Menu> menus;

  DailyMenu({required this.day, required this.menus})
      : assert(menus.every((element) => element.date == day));

  Future<Menu> moveRecipesToMeal(Meal from, to, List<String> recipeIds,
      [Date? toDate]) async {
    assert((getMenuByMeal(from) != null) && (getMenuByMeal(to) != null));

    final menuFrom = getMenuByMeal(from);
    final menuTo = getMenuByMeal(to);

    menuFrom!.removeRecipeByIdList(recipeIds).save(params: {'update': true});

    if (menuTo != null) {
      return await menuTo.addRecipes(recipeIds).save(params: {'update': true});
    } else {
      return await menuFrom
          .copyWith(meal: to, recipes: recipeIds)
          .save(params: {'update': false});
    }
  }

  List<String> getRecipeIdsByMeal(Meal meal) {
    return recipeIdsByMeal[meal] ?? [];
  }

  List<Menu> getMenusByMeal(Meal meal) {
    return menus.where((m) => m.meal == meal).toList();
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

    if (menus.isNotEmpty) {
      Meal.values.forEach((meal) {
        final menuMeal = menus.firstWhereOrNull((menu) => menu.meal == meal);

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
      menus.firstWhereOrNull((menu) => menu.meal == meal);

  bool get isToday => day.isToday;

  bool get isPast => day.isPast;
}

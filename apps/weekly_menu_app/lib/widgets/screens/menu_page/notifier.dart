import 'package:common/constants.dart';
import 'package:data/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/enums/meal.dart';
import 'package:model/menu.dart';

import 'package:collection/collection.dart';
import 'package:model/recipe.dart';

class DailyMenuNotifier extends StateNotifier<DailyMenu> {
  final Repository<Menu> _repository;

  DailyMenuNotifier(DailyMenu dailyMenu, this._repository) : super(dailyMenu);

  Future<Menu> addMenu(Menu newMenu) async {
    assert(state.menus.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) ==
        null);

    final res = await _repository.save(newMenu, params: {UPDATE_PARAM: false});
    state = state.copyWith(menus: [...state.menus, newMenu]);

    return res;
  }

  Future<Menu> updateMenu(Menu newMenu) async {
    assert(state.menus.firstWhereOrNull(
          (menu) => menu.meal == newMenu.meal,
        ) !=
        null);
    final menuList = state.menus..removeWhere((m) => m.idx == newMenu.idx);

    final res = await _repository.save(newMenu, params: {UPDATE_PARAM: true});
    state = state.copyWith(menus: [...menuList, newMenu]);

    return res;
  }

  Future<Menu> addRecipeToMeal(Meal meal, Recipe recipe) async {
    var menu = state.getMenuByMeal(meal);

    if (menu != null) {
      menu = menu.addRecipe(recipe.idx);
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
      ..removeWhere((element) => element.idx == menu.idx);
    await _repository.delete(menu.idx);
    state = state.copyWith(menus: newList);
  }

  Future<void> save(DailyMenu dailyMenu) async {
    for (Menu menu in dailyMenu.menus) {
      if (menu.recipes.isEmpty) {
        // No recipes in menu means that there isn't a menu for that meal, so when can remove it
        await _repository.delete(menu.idx, params: {UPDATE_PARAM: true});
        removeMenu(menu);
      } else {
        await _repository.save(menu, params: {UPDATE_PARAM: true});
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

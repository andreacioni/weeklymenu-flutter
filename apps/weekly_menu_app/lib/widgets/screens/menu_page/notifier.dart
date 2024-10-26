import 'package:common/constants.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/enums/meal.dart';
import 'package:model/daily_menu.dart';

part 'notifier.g.dart';

final menuScreenNotifierProvider =
    StateNotifierProvider.autoDispose<MenuScreenStateNotifier, MenuScreenState>(
        (_) => MenuScreenStateNotifier(MenuScreenState()));

@immutable
@CopyWith()
class MenuScreenState {
  final bool editMode;

  MenuScreenState({this.editMode = false});
}

class MenuScreenStateNotifier extends StateNotifier<MenuScreenState> {
  MenuScreenStateNotifier(MenuScreenState state) : super(state);

  void setEditMode(bool editMode) {
    state = state.copyWith(editMode: editMode);
  }
}

class DailyMenuNotifier extends StateNotifier<DailyMenu> {
  final Repository<DailyMenu> _repository;

  DailyMenuNotifier(DailyMenu dailyMenu, this._repository) : super(dailyMenu);

  Future<DailyMenu> addRecipeToMeal(Meal meal, String recipeId) async {
    final newDailyMenu = state.addRecipesToMeal(meal, [recipeId]);

    state = newDailyMenu;
    final res =
        await _repository.save(newDailyMenu, params: {UPDATE_PARAM: false});

    return res;
  }

  Future<DailyMenu> removeRecipeFromMeal(Meal meal, String recipeId) async {
    final newDailyMenu = state.removeRecipeFromMeal(meal, recipeId);

    state = newDailyMenu;
    final res =
        await _repository.save(newDailyMenu, params: {UPDATE_PARAM: false});

    return res;
  }

  Future<DailyMenu> replaceRecipeInMeal(
      Meal meal, String oldRecipeId, String recipeID) async {
    final newDailyMenu =
        dailyMenu.replaceRecipeInMeal(meal, oldRecipeId, recipeID);
    state = newDailyMenu;

    final res =
        await _repository.save(newDailyMenu, params: {UPDATE_PARAM: false});

    return res;
  }

  DailyMenu get dailyMenu => state;
}

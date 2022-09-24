import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/recipe.dart';

import '../../../models/ingredient.dart';
import '../../../main.data.dart';

part 'recipe_screen_state_notifier.g.dart';

@immutable
@CopyWith()
class RecipeScreenState {
  final bool editEnabled;
  final bool newIngredientMode;

  final RecipeOriginator? recipeOriginator;

  RecipeScreenState({
    this.editEnabled = false,
    this.newIngredientMode = false,
    this.recipeOriginator,
  });
}

class RecipeScreenStateNotifier extends StateNotifier<RecipeScreenState> {
  final Reader read;

  RecipeScreenStateNotifier(this.read, [RecipeScreenState? state])
      : super(state ?? RecipeScreenState());

  set recipeOriginator(RecipeOriginator recipeOriginator) {
    if (state.recipeOriginator == null) {
      state = state.copyWith(recipeOriginator: recipeOriginator);
    }
  }

  bool get editEnabled => state.editEnabled;
  set editEnabled(bool newValue) {
    state = state.copyWith(editEnabled: newValue);
  }

  bool get newIngredientMode => state.editEnabled;
  set newIngredientMode(bool newValue) {
    state = state.copyWith(newIngredientMode: newValue);
  }

  void updateRecipeName(String name) {
    state.recipeOriginator!.state =
        state.recipeOriginator!.state.copyWith(name: name);
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateImageUrl(String? imageUrl) {
    state.recipeOriginator!.state =
        state.recipeOriginator!.state.copyWith(imgUrl: imageUrl);
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addRecipeIngredientFromIngredient(Ingredient ingredient) {
    final newRecipeIngredient = RecipeIngredient(ingredientId: ingredient.id);
    final recipeIngredients = [
      newRecipeIngredient,
      ...state.recipeOriginator!.state.ingredients
    ];

    state.recipeOriginator!.state =
        state.recipeOriginator!.state.copyWith(ingredients: recipeIngredients);

    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addRecipeIngredientFromString(String ingredientName) {
    final newIngredient = Ingredient(name: ingredientName);
    read(ingredientsRepositoryProvider).save(newIngredient);
    final newRecipeIngredient =
        RecipeIngredient(ingredientId: newIngredient.id);
    final recipeIngredients = state.recipeOriginator!.state.ingredients;
    state.recipeOriginator!.state = state.recipeOriginator!.state
        .copyWith(ingredients: [newRecipeIngredient, ...recipeIngredients]);
  }
}

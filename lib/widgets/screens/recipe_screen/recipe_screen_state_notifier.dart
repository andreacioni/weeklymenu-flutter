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
  final bool newStepMode;
  final int currentTab;
  final int? servingsMultiplier;

  final RecipeOriginator recipeOriginator;

  RecipeScreenState(
      {required this.recipeOriginator,
      this.editEnabled = false,
      this.newIngredientMode = false,
      this.newStepMode = false,
      this.currentTab = 0,
      this.servingsMultiplier});

  get displayFAB =>
      editEnabled && !newIngredientMode && !newStepMode && currentTab != 0;

  get displayServingsFAB => !editEnabled && currentTab == 1;
}

class RecipeScreenStateNotifier extends StateNotifier<RecipeScreenState> {
  final Reader read;

  RecipeScreenStateNotifier(this.read, RecipeScreenState state) : super(state);

  bool get isRecipeEdited => state.recipeOriginator.isEdited;

  set servingsMultiplier(int servingsMultiplier) =>
      state = state.copyWith(servingsMultiplier: servingsMultiplier);

  set currentTab(int currentTab) =>
      state = state.copyWith(currentTab: currentTab);

  Recipe saveRecipe() => state.recipeOriginator.save();

  Recipe revertRecipe() => state.recipeOriginator.revert();

  bool get editEnabled => state.editEnabled;
  set editEnabled(bool newValue) {
    state = state.copyWith(editEnabled: newValue);
  }

  bool get newIngredientMode => state.editEnabled;
  set newIngredientMode(bool newValue) {
    state = state.copyWith(newIngredientMode: newValue);
  }

  bool get newStepMode => state.editEnabled;
  set newStepMode(bool newValue) {
    state = state.copyWith(newStepMode: newValue);
  }

  bool get edited => state.recipeOriginator.isEdited;

  void updateRecipeName(String name) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(name: name));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateImageUrl(String? imageUrl) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(imgUrl: imageUrl));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addRecipeIngredientFromIngredient(Ingredient ingredient) {
    final newRecipeIngredient = RecipeIngredient(ingredientId: ingredient.id);
    final recipeIngredients = [
      newRecipeIngredient,
      ...state.recipeOriginator.state.ingredients
    ];

    state.recipeOriginator.update(state.recipeOriginator.instance
        .copyWith(ingredients: recipeIngredients));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addRecipeIngredientFromString(String ingredientName) {
    final newIngredient = Ingredient(name: ingredientName);
    read(ingredientsRepositoryProvider).save(newIngredient);
    final newRecipeIngredient =
        RecipeIngredient(ingredientId: newIngredient.id);
    final recipeIngredients = state.recipeOriginator.state.ingredients;

    state.recipeOriginator.update(state.recipeOriginator.instance
        .copyWith(ingredients: [newRecipeIngredient, ...recipeIngredients]));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void deleteRecipeIngredientByIndex(int index) {
    final newList = state.recipeOriginator.instance.ingredients
      ..removeAt(index);

    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(ingredients: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateDifficulty(String? newValue) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(difficulty: newValue));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateServings(int servs) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(servs: servs));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateEstimatedPreparationTime(int estimatedPreparationTime) {
    state.recipeOriginator.update(state.recipeOriginator.instance
        .copyWith(estimatedPreparationTime: estimatedPreparationTime));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateEstimatedCookingTime(int estimatedCookingTime) {
    state.recipeOriginator.update(state.recipeOriginator.instance
        .copyWith(estimatedCookingTime: estimatedCookingTime));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateAffinity(int? rating) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(rating: rating));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateCost(int cost) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(cost: cost));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateRecipeIngredientAtIndex(
      int idx, RecipeIngredient newRecipeIngredient) {
    final newList = [...state.recipeOriginator.instance.ingredients];

    newList.replaceRange(idx, idx + 1, [newRecipeIngredient]);

    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(ingredients: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addStep(RecipePreparationStep recipePreparationStep) {
    final newList = [
      ...state.recipeOriginator.instance.preparationSteps,
      recipePreparationStep
    ];

    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(preparationSteps: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }
}

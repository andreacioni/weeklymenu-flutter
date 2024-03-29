import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/ingredient.dart';
import 'package:model/recipe.dart';

part 'notifier.g.dart';

final recipeScreenNotifierProvider = StateNotifierProvider.autoDispose<
    RecipeScreenStateNotifier,
    RecipeScreenState>((ref) => throw UnimplementedError());

@immutable
@CopyWith()
class RecipeScreenState {
  final bool editEnabled;
  final bool isNewRecipe;
  final bool newIngredientMode;
  final bool newStepMode;
  final int currentTab;
  final int? servingsMultiplier;

  final RecipeOriginator recipeOriginator;

  RecipeScreenState(
      {required this.recipeOriginator,
      this.editEnabled = false,
      this.newIngredientMode = false,
      this.isNewRecipe = false,
      this.newStepMode = false,
      this.currentTab = 0,
      this.servingsMultiplier});

  get displayAddFAB =>
      editEnabled &&
      (currentTab == 1 || currentTab == 2) &&
      !newIngredientMode &&
      !newStepMode;

  get displayServingsFAB =>
      !editEnabled &&
      currentTab == 1 &&
      recipeOriginator.instance.ingredients.isNotEmpty;

  get displayMoreFAB => editEnabled && currentTab == 0;

  double get servingsMultiplierFactor {
    if (servingsMultiplier != null) {
      return servingsMultiplier! / (recipeOriginator.instance.servs ?? 1);
    }

    return 1;
  }
}

class RecipeScreenStateNotifier extends StateNotifier<RecipeScreenState> {
  final Ref ref;

  RecipeScreenStateNotifier(this.ref, RecipeScreenState state) : super(state);

  bool get isRecipeEdited => state.recipeOriginator.isEdited;

  bool get isNewRecipe => state.isNewRecipe;

  set servingsMultiplier(int servingsMultiplier) =>
      state = state.copyWith(servingsMultiplier: servingsMultiplier);

  set currentTab(int currentTab) =>
      state = state.copyWith(currentTab: currentTab);

  Recipe saveRecipe() => state.recipeOriginator.save();

  Recipe revertRecipe() => state.recipeOriginator.revert();

  set editEnabled(bool newValue) {
    state = state.copyWith(editEnabled: newValue);
  }

  set newIngredientMode(bool newValue) {
    state = state.copyWith(newIngredientMode: newValue);
  }

  set newStepMode(bool newValue) {
    state = state.copyWith(newStepMode: newValue);
  }


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
    final newRecipeIngredient =
        RecipeIngredient(ingredientName: ingredient.name);
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
    ref.read(ingredientsRepositoryProvider).save(newIngredient);
    final newRecipeIngredient =
        RecipeIngredient(ingredientName: newIngredient.name);
    final recipeIngredients = state.recipeOriginator.state.ingredients;

    state.recipeOriginator.update(state.recipeOriginator.instance
        .copyWith(ingredients: [newRecipeIngredient, ...recipeIngredients]));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateRecipeIngredientFromIngredientAtIndex(int idx, Ingredient value) {
    final newRecipeIngredient = state.recipeOriginator.instance.ingredients[idx]
        .copyWith(ingredientName: value.name);

    updateRecipeIngredientAtIndex(idx, newRecipeIngredient);
  }

  void updateRecipeIngredientFromStringAtIndex(int idx, String ingredientName) {
    final newIngredient = Ingredient(name: ingredientName);
    ref.read(ingredientsRepositoryProvider).save(newIngredient);

    updateRecipeIngredientFromIngredientAtIndex(idx, newIngredient);
  }

  void updateRecipeIngredientAtIndex(
      int idx, RecipeIngredient newRecipeIngredient) {
    final newList = [...state.recipeOriginator.instance.ingredients];

    newList.replaceRange(idx, idx + 1, [newRecipeIngredient]);

    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(ingredients: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void deleteRecipeIngredientByIndex(int index) {
    final newList = [...state.recipeOriginator.instance.ingredients];
    newList.removeAt(index);

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

  void addStep(RecipePreparationStep recipePreparationStep) {
    final newList = [
      ...state.recipeOriginator.instance.preparationSteps,
      recipePreparationStep
    ];

    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(preparationSteps: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateStepByIndex(
      int index, RecipePreparationStep recipePreparationStep) {
    final newList = [...state.recipeOriginator.instance.preparationSteps];
    newList.replaceRange(index, index + 1, [recipePreparationStep]);

    //update with the same instance just to set "edited" flag
    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(preparationSteps: newList));
    //we do not want the widget to rebuild here
    //state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void deleteStepByIndex(int index) {
    final newList = [...state.recipeOriginator.instance.preparationSteps];
    newList.removeAt(index);
    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(preparationSteps: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void swapStepsByIndex(int firstIndex, int secondIndex) {
    if (firstIndex < state.recipeOriginator.instance.preparationSteps.length &&
        secondIndex < state.recipeOriginator.instance.preparationSteps.length) {
      final firstStep =
          state.recipeOriginator.instance.preparationSteps[firstIndex];

      final newList = [...state.recipeOriginator.instance.preparationSteps];

      newList.removeAt(firstIndex);
      newList.insert(secondIndex, firstStep);

      state.recipeOriginator.update(
          state.recipeOriginator.instance.copyWith(preparationSteps: newList));
      state = state.copyWith(recipeOriginator: state.recipeOriginator);
    }
  }

  void updateDescription(String description) {
    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(description: description));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateNote(String note) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(note: note));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateSection(String section) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(section: section));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateRecipeUrl(String newLink) {
    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(recipeUrl: newLink));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateVideoUrl(String newVideoUrl) {
    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(videoUrl: newVideoUrl));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void deleteTagByIndex(int index) {
    final newList = state.recipeOriginator.instance.tags..removeAt(index);

    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(tags: [...newList]));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addTag(String newTag) {
    final newList = [...state.recipeOriginator.instance.tags, newTag];

    state.recipeOriginator
        .update(state.recipeOriginator.instance.copyWith(tags: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void addRelatedRecipes(String relatedRecipeId) {
    final newList = [
      ...state.recipeOriginator.instance.relatedRecipes,
      RelatedRecipe(id: relatedRecipeId)
    ];

    state.recipeOriginator.update(
        state.recipeOriginator.instance.copyWith(relatedRecipes: newList));
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }

  void updateRecipe(Recipe newRecipe) {
    state.recipeOriginator.update(newRecipe);
    state = state.copyWith(recipeOriginator: state.recipeOriginator);
  }
}

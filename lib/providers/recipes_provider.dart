import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../models/recipe.dart';

const String RECIPES_BOX = 'recipes';

class RecipesProvider with ChangeNotifier {
  final Box<RecipeOriginator> _recipesBox = Hive.box(RECIPES_BOX);

  List<RecipeOriginator> get recipes => _recipesBox.values;

  List<String> get recipeTags {
    List<String> tags = [];

    _recipesBox.values.forEach((recipe) {
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }

  RecipeOriginator getById(String id) => _recipesBox.get(id);

  Future<RecipeOriginator> addRecipe(Recipe newRecipe) async {
    final RecipeOriginator recipeOriginator = RecipeOriginator(newRecipe);
    await _recipesBox.put(recipeOriginator.id.offlineId, recipeOriginator);
    notifyListeners();
    return recipeOriginator;
  }

  Future<void> removeRecipe(RecipeOriginator recipe) async {
    await _recipesBox.delete(recipe.id.offlineId);
    notifyListeners();
  }

  Future<void> saveRecipe(RecipeOriginator recipe) async {
    assert(recipe.id != null);
    try {
      await _recipesBox.put(recipe.id.offlineId, recipe);
      recipe.save();
    } catch (e) {
      recipe.revert();
      throw e;
    }
  }

  void update(IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.ingredients;
    if (ingredientsList != null) {
      for (RecipeOriginator recipe in _recipesBox.values) {
        if (recipe.ingredients != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = recipe.ingredients
              .where((recipeIngredient) => (ingredientsList.indexWhere(
                      (ingredient) =>
                          ingredient.id.offlineId ==
                          recipeIngredient.ingredientId) ==
                  -1))
              .toList();

          for (RecipeIngredient recipeIngredientToBeRemvoved
              in toBeRemovedList) {
            recipe.deleteRecipeIngredient(
                recipeIngredientToBeRemvoved.ingredientId);
          }
        }
      }
    }
  }
}

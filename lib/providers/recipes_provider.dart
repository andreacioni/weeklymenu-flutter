import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:objectid/objectid.dart';

import 'package:weekly_menu_app/models/ingredient.dart';
import 'package:weekly_menu_app/providers/ingredients_provider.dart';

import '../datasource/network.dart';
import '../models/recipe.dart';
import 'rest_provider.dart';

class RecipesProvider with ChangeNotifier {
  Box<Recipe> _box;

  RestProvider _restApi;

  RecipesProvider(this._restApi);

  Future<void> fetchRecipes() async {
    _box = await Hive.openBox("recipes");

    notifyListeners();
  }

  List<RecipeOriginator> get recipes =>
      _box.values.map((recipe) => RecipeOriginator(recipe));

  List<String> get getAllRecipeTags {
    List<String> tags = [];
    recipes.forEach((recipe) {
      if (recipe.tags != null) {
        tags.addAll(recipe.tags);
      }
    });

    return tags;
  }

  RecipeOriginator getById(String id) => RecipeOriginator(_box.get(id));

  Future<RecipeOriginator> addRecipe(Recipe newRecipe) async {
    assert(newRecipe.id == null);
    newRecipe.id = ObjectId().hexString;

    _box.add(newRecipe);

    notifyListeners();
    return RecipeOriginator(newRecipe);
  }

  Future<void> removeRecipe(RecipeOriginator recipe) async {
    await _box.delete(recipe.id);
    notifyListeners();
  }

  Future<void> saveRecipe(RecipeOriginator recipe) async {
    assert(recipe.id != null);
    await _box.put(recipe.id, recipe.save());
    notifyListeners();
  }

  void update(
      RestProvider restProvider, IngredientsProvider ingredientsProvider) {
    List<Ingredient> ingredientsList = ingredientsProvider.ingredients;

    if (ingredientsList != null) {
      for (RecipeOriginator recipe in recipes) {
        if (recipe.ingredients != null) {
          //This is a list but hopefully we expect only one item to be removed
          var toBeRemovedList = recipe.ingredients
              .where((recipeIngredient) => (ingredientsList.indexWhere(
                      (ingredient) =>
                          ingredient.id == recipeIngredient.ingredientId) ==
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

    _restApi = restProvider;
  }
}
